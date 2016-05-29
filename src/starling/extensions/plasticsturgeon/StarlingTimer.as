package starling.extensions.plasticsturgeon
{
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.events.EventDispatcher;
	
	/**
	 * This class implements the flash.utils.Timer Interface 
	 * as a Starling-compatible Timer using the Starling Juggler
	 * @author Zachary Foley
	 */
	public class StarlingTimer extends EventDispatcher
	{
		private var _currentCount:int;
		private var _delay:Number;
		private var _repeatCount:int;
		private var _juggler:Juggler;
		private var delayedCall:DelayedCall;
		private var _running:Boolean;
		
		/**
		 * Constructs a new Timer object with the specified delay
		 * and repeatCount states.
		 *
		 *   The timer does not start automatically; you must call the start() method
		 * to start it.
		 * @param	juggler	Reference to the Juggler that updates this timer.
		 *   This is often the Starling.juggler.
		 * @param	delay	The delay between timer events, in milliseconds. A delay lower than 20 milliseconds is not recommended. Timer frequency
		 *   is limited to 60 frames per second, meaning a delay lower than 16.6 milliseconds causes runtime problems.
		 * @param	repeatCount	Specifies the number of repetitions.
		 *   If zero, the timer repeats infinitely.
		 *   If nonzero, the timer runs the specified number of times and then stops.		 
		 * @langversion	3.0
		 * @throws	Error if the delay specified is negative or not a finite number
		 */
		public function StarlingTimer(juggler:Juggler, delay:Number, repeatCount:int = 0)
		{
			super();
			if (isNaN(delay) || delay < 0) {
				throw new Error("StarlingTimer invalid delay value:", delay);
			}
			_delay = delay;
			_repeatCount = repeatCount;
			_juggler = juggler;		
			_running = false;
		}
		
		/**
		 * The total number of times the timer has fired since it started
		 * at zero. If the timer has been reset, only the fires since
		 * the reset are counted.
		 * @langversion	3.0
		 */
		public function get currentCount():int
		{
			return _currentCount;
		}
		
		/**
		 * The delay, in milliseconds, between timer
		 * events. If you set the delay interval while
		 * the timer is running, the timer will restart
		 * at the same repeatCount iteration.
		 * Note: A delay lower than 20 milliseconds is not recommended. Timer frequency
		 * is limited to 60 frames per second, meaning a delay lower than 16.6 milliseconds causes runtime problems.
		 * @langversion	3.0
		 * @throws	Error Throws an exception if the delay specified is negative or not a finite number.
		 */
		public function get delay():Number
		{
			return _delay;
		}
		
		public function set delay(value:Number):void
		{
			if (isNaN(value) || value < 0) {
				throw new Error("StarlingTimer invalid delay value:", value);
			}
			_delay = value;
		}
		
		/**
		 * The total number of times the timer is set to run.
		 * If the repeat count is set to 0, the timer continues forever
		 * or until the stop() method is invoked or the program stops.
		 * If the repeat count is nonzero, the timer runs the specified number of times.
		 * If repeatCount is set to a total that is the same or less then currentCount
		 * the timer stops and will not fire again.
		 * @langversion	3.0
		 */
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		/**
		 * The timer's current state; true if the timer is running, otherwise false.
		 * @langversion	3.0
		 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * Stops the timer, if it is running, and sets the currentCount property back to 0,
		 * like the reset button of a stopwatch. Then, when start() is called,
		 * the timer instance runs for the specified number of repetitions,
		 * as set by the repeatCount value.
		 * @langversion	3.0
		 */
		public function reset():void
		{
			_juggler.remove(delayedCall);
			_currentCount = 0;
		}
		
		/**
		 * Starts the timer, if it is not already running.
		 * @langversion	3.0
		 */
		public function start():void
		{
			
			delayedCall = new DelayedCall(onTimerTick, _delay / 1000);
			if (delayedCall != null) {
				_juggler.remove(delayedCall);
			}
			_juggler.add(delayedCall);
			_running = true;
		}
		
		/**
		 * Stops the timer. When start() is called after stop(), the timer
		 * instance runs for the remaining number of repetitions, as set by the repeatCount property.
		 * @langversion	3.0
		 */
		public function stop():void
		{
			_running = false;
			_juggler.remove(delayedCall);
			trace("Stopping Timer");
		}
		
		private function onTimerTick():void
		{
			var e:StarlingTimerEvent = new StarlingTimerEvent(StarlingTimerEvent.TIMER, true);
			dispatchEvent(e);
			_currentCount ++;
			if (_repeatCount == 0 || _repeatCount - _currentCount > 0 ) {
				if (delayedCall != null) {
					_juggler.remove(delayedCall);
				}
				delayedCall = new DelayedCall(onTimerTick, _delay / 1000);
				_juggler.add(delayedCall);
			} else {
				onTimerComplete();
			}
		}
		
		private function onTimerComplete():void
		{
			_juggler.remove(delayedCall);
			_running = false;
			var e:StarlingTimerEvent = new StarlingTimerEvent(StarlingTimerEvent.TIMER_COMPLETE, true);
			dispatchEvent(e);
		}
	
	}

}