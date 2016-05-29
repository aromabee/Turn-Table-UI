package starling.extensions.plasticsturgeon 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Zachary Foley
	 */
	public class StarlingTimerEvent extends Event 
	{
		/**
		 * Defines the value of the type property of a timer event object.
		 * This event has the following properties:PropertyValuebubblesfalsecancelablefalse; there is no default behavior to cancel.currentTargetThe object that is actively processing the Event 
		 * object with an event listener.targetThe Timer object that has reached its interval.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const TIMER : String = "starlingTimer";

		/**
		 * Defines the value of the type property of a timerComplete event object.
		 * This event has the following properties:PropertyValuebubblesfalsecancelablefalse; there is no default behavior to cancel.currentTargetThe object that is actively processing the Event 
		 * object with an event listener.targetThe Timer object that has completed its requests.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const TIMER_COMPLETE : String = "starlingTimerComplete";
		
		public function StarlingTimerEvent(type:String, bubbles:Boolean=false, data:Object=null) 
		{
			super(type, bubbles, data);			
		}
		
	}

}