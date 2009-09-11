package com.thread.draw 
{	import com.geom.Line;
	import com.thread.draw.IDrawer;

	import flash.display.Sprite;
	import flash.geom.Point;

	/**	 * @author plemarquand	 */	public class CircleDrawer implements IDrawer 
	{				
		public function draw(drawTarget : Sprite, lines : Vector.<Line>) : void
		{
			var len : int = lines.length;
			for (var i : Number = 0; i < len; i++) 
			{
				var midPt : Point = lines[i].interpolate(.5);
				var radius : Number = lines[i].length / 2;
				
				drawTarget.graphics.drawCircle( midPt.x, midPt.y, radius);
			}
		}
	}}