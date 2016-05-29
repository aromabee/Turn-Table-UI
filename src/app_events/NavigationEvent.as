package app_events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String = "changeScreen";
		
		public var params:Object;
		
		public function NavigationEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}