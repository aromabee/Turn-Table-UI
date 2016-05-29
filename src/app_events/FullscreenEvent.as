package app_events
{
	import starling.events.Event;
	
	public class FullscreenEvent extends Event
	{
		public static const VDO_FULLSCREEN:String = "vdofullscreen";
		public static const VDO_NORMAL:String = "vdonormal";
		public var params:Object;
		
		public function FullscreenEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}