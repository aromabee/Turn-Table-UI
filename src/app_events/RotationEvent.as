package app_events
{
	import starling.events.Event;
	
	public class RotationEvent extends Event
	{
		public static const ROTATION_STATE:String = "rotationstate";
		public var params:Object;
		
		public function RotationEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}