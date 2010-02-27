package com.sequencer.element {
	import com.fuelindustries.core.AssetProxy;
	
	/**
	 * @author fuel
	 */
	public class Node extends AssetProxy {
		
		public static const STATE_ON:String = "on";
		public static const STATE_OFF:String = "off";
		
		public var childNodes:Array = new Array();
		protected var _currentState:String = STATE_OFF;
		public function get currentState() : String {
			return _currentState;
		}
		
		public function Node() {
			super();
			
			linkage = "node_mc";
		}

		override protected function completeConstruction() : void {
			super.completeConstruction();
			
			setState(_currentState);
		}
		
		public function setState(state : String) : void {
			if(state != currentLabel)
			{
				gotoAndStop(state);
			}
		}
		
		
	}
}
