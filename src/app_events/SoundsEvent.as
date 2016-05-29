package app_events
{
	import starling.events.Event;
	
	public class SoundsEvent extends Event
	{
		public static const PLAY_SOUND:String = "playSound";
		public static const PAUSE_SOUND:String = "pauseSound";
		public static const RESUME_SOUND:String = "resumeSound";
		public static const RESUME_LOOP_SOUND:String = "resumeLoopSound";
		public static const STOP_SOUND:String = "stopSound";
		public static const LOOP_SOUND:String = "loopSound";
		public var params:Object;
		
		public function SoundsEvent(_type:String, _params:Object = null, bubbles:Boolean=false)
		{
			super(_type, bubbles);
			this.params = _params;
		}
	}
}