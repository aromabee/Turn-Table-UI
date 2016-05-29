package {
	
	import starling.core.Starling;
	import starling.display.*;
	import starling.events.*;
	import starling.utils.AssetManager;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	//import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.events.*;
	
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	import app_events.SoundsEvent;
	
	
    public class SoundsControl
    {
		//Sounds ------------------------------------ Config Sound here
		private var click_snd:SoundChannel;
		private var button_snd:SoundChannel;
		private var correct_snd:SoundChannel;
		private var correct2_snd:SoundChannel;
		private var incorrect_snd:SoundChannel;
		private var effect1_snd:SoundChannel;
		private var effect2_snd:SoundChannel;
		private var effect3_snd:SoundChannel;
		private var flipAll_snd:SoundChannel;
		private var reset_snd:SoundChannel;
		private var close_snd:SoundChannel;
		private var complete_snd:SoundChannel;
		private var spin_snd:SoundChannel;
		private var vdoOpen_snd:SoundChannel;
		
		//-------------------------------------------------------------
		private static var soundPlaying:Boolean;
		
		private static var currentSound:Array = new Array();
		private static var currentSoundNum:Number;
		private static var lastPosition:Number;
		private static var soundObj:Object;
		private static var soundVolume:SoundTransform;
		private static var soundLoopVolume:SoundTransform;
		
		private static var sAssets:AssetManager;
		
		
        public function SoundsControl(){
			//trace("Sound Start!!!");
		}
		public function initialize(assets:AssetManager):void {
			
			sAssets = assets;
			//trace("Sound initialize!!!");
			soundVolume= new SoundTransform();
			soundVolume.volume = 1;
			
			soundLoopVolume= new SoundTransform();
			soundLoopVolume.volume = 0.5;
			
		}
		public function setVolume(volume:Number):void{
			soundVolume.volume = volume;
		}
		public function setLoopVolume(volume:Number):void{
			soundLoopVolume.volume = volume;
		}
		public function playSound(soundType:String, sndVol:Number=1):void{
			setVolume(sndVol);
			this[soundType] = sAssets.playSound(soundType, 0, 1, soundVolume);
			//this[soundType].addEventListener(flash.events.Event.SOUND_COMPLETE, removeSound);
		}
		/*private function removeSound(event:flash.events.Event):void{
			event.currentTarget.stop();
		}*/
		public function playLoopSound(soundType:String, sndVol:Number=1):void{
			//setLoopVolume(sndVol);
			this[soundType] = sAssets.playSound(soundType, 0, 999, soundLoopVolume);
		}
		public function pauseSound(soundType:String):void{
			lastPosition = this[soundType].position;
			this[soundType].stop();
			trace(lastPosition );
		}
		public function resumeSound(soundType:String, sndVol:Number=1):void{
			setVolume(sndVol);
			this[soundType] = sAssets.playSound(soundType, lastPosition, 1, soundVolume);
		}
		public function resumeLoopSound(soundType:String, sndVol:Number=1):void{
			//setLoopVolume(sndVol);
			this[soundType] = sAssets.playSound(soundType, lastPosition, 999, soundLoopVolume);
		}
		public function stopSound(soundType:String):void{
			if(this[soundType]){
				this[soundType].stop();
			}
		}
    }
}