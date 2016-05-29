package app_events
{
	import starling.events.Event;
	
	public class ControlEvent extends Event
	{
		public static const CONTROL_TYPE:String = "controltype";
		public var params:Object;
		
		public function ControlEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}