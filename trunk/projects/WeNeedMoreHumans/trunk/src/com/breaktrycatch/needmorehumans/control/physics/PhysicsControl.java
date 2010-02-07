package com.breaktrycatch.needmorehumans.control.physics;

import java.awt.Point;
import java.awt.Rectangle;
import java.awt.geom.Point2D;

import org.jbox2d.common.Vec2;
import org.jbox2d.dynamics.Body;

import processing.core.PApplet;
import processing.core.PImage;

import com.breaktrycatch.lib.display.DisplayObject;
import com.breaktrycatch.lib.display.ImageFrame;
import com.breaktrycatch.needmorehumans.model.BodyVO;
import com.breaktrycatch.needmorehumans.model.PhysicsShapeDefVO;
import com.breaktrycatch.needmorehumans.tracing.ImageAnalysis;
import com.breaktrycatch.needmorehumans.utils.PhysicsUtils;
import com.breaktrycatch.needmorehumans.utils.RectUtils;

public class PhysicsControl extends DisplayObject
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static PApplet DEBUG_APP;
	private PhysicsWorldWrapper _physWorld;
	private Point _lastMousePos;
	private Rectangle _scrollBounds;

	public PhysicsControl(PApplet app)
	{
		super(app);
		DEBUG_APP = app;
		_scrollBounds = new Rectangle(-Integer.MAX_VALUE / 2, -Integer.MAX_VALUE / 2, Integer.MAX_VALUE, Integer.MAX_VALUE);
	}

	public void setScrollBounds(Rectangle bounds)
	{
		_scrollBounds = bounds;
	}

	public Rectangle getScrollBounds()
	{
		return _scrollBounds;
	}

	/**
	 * Call after setting width/height
	 */
	public void init()
	{
		_physWorld = new PhysicsWorldWrapper((float) width, (float) height);
		_physWorld.enableDebugDraw(getApp());

		PhysicsShapeDefVO vo = new PhysicsShapeDefVO();
		vo.density = 0.0f;
		vo.friction = 1.0f;
		//_physWorld.createRect(0, height + 10, width, height, vo);
		PhysicsUserDataVO userData = new PhysicsUserDataVO();
		userData.breaksHumanJoints = true;
		Body[] bounds = _physWorld.createHollowBox(width/2.0f, height/2.0f, width, height, 15.0f, vo);
		bounds[1].setUserData(userData);
		bounds[2].setUserData(userData);
		bounds[3].setUserData(userData);
		
		addDebugSmileBoxes();
		// addDebugPolyHuman();
		// _physWorld.createRect(50, 150, 150, 250, new PhysicsShapeDefVO());
	}

	private void addDebugSmileBoxes()
	{
		float size = 20;
		PImage img = getApp().loadImage("../data/physics/BoxMcSmiles.png");
		// PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();

		for (int i = 0; i < 20; i++)
		{
			for (int j = 0; j < 10; j++)
			{
				float x, y;
				x = (i * size) + width / 2 - ((20/2) * size);
				y = (j * size) + 310;
				Body rect = _physWorld.createRect(x, y, x + size, y + size, new PhysicsShapeDefVO());
				ImageFrame sprite = new ImageFrame(getApp(), img);
				sprite.setRotateAroundCenter(true);
				add(sprite);
				rect.setUserData(sprite);
			}
		}
	}

	private void addDebugPolyHuman()
	{
		PImage img = getApp().loadImage("../data/tracing/RealPerson_1.png");
		img.loadPixels();

		ImageFrame sprite = new ImageFrame(getApp(), img);
		// sprite.setRotateAroundCenter(true);
		sprite.x = 400;
		sprite.y = 200;

		addHuman(sprite);
	}

	public void addHuman(ImageFrame sprite)
	{
		sprite.setRotateAroundCenter(true);
		
		ImageAnalysis imageAnalysis = new ImageAnalysis(getApp());
		BodyVO analyzedBody = imageAnalysis.analyzeImage(sprite.getDisplay());

		Body human = _physWorld.createPolyHuman(analyzedBody.polyDefs, new PhysicsShapeDefVO(), sprite.x + sprite.width /2.0f, sprite.y + sprite.height / 2.0f, -sprite.rotationRad);
		
		PhysicsUserDataVO userData = new PhysicsUserDataVO();
		userData.display = sprite;
		
		//Convert all of the extremity points to world space
		Vec2 axisTransform = new Vec2(1, -1);
		//Vec2 offset = new Vec2(sprite.width/2.0f, sprite.height/2.0f);
		Vec2 offset = new Vec2(0.0f, 0.0f);
		
		for (Vec2 extremity : analyzedBody.extremities) 
		{
			//extremity.mulLocal(_physWorld.getPhysScale());
			//extremity.y *= -1.0f;
			PhysicsUtils.genericTransform(extremity, _physWorld.getPhysScale(), offset, axisTransform, true);
		}
		
		userData.extremities = analyzedBody.extremities;
		
		userData.isHuman = true;
		human.setUserData(userData);

		add(sprite);
	}
	
	

	@Override
	public void draw()
	{
		// TODO Auto-generated method stub
		

		getApp().fill(0x22000000);
		getApp().rect(0, 0, width, height);
		//getApp().tint(0,0,0,90);
		if (getApp().mouseX > this.x && getApp().mouseX < this.width + this.x && getApp().mousePressed)
		{
			if (_lastMousePos != null)
			{
				this.y += getApp().mouseY - _lastMousePos.y;
				this.x += getApp().mouseX - _lastMousePos.x;
			}
			_lastMousePos = new Point(getApp().mouseX, getApp().mouseY);
		} else
		{
			_lastMousePos = null;
		}

		
		constrainToBounds();
		_physWorld.step();
		
		super.draw();
	}

	public void constrainToBounds()
	{
		Point2D.Float pt = RectUtils.constrain(new Point2D.Float((int) x, (int) y), _scrollBounds);
		this.x = pt.x;
		this.y = pt.y;
	}

	@Override
	public void dispose()
	{
		_physWorld.destroy();

		super.dispose();
	}
}
