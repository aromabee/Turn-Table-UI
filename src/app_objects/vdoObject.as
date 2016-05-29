package app_objects
{

	import flash.events.NetStatusEvent;
	import flash.filesystem.File;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/*import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;*/
	
	public class vdoObject extends Sprite
	{
		private var sAssets:AssetManager;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var file:File;
		private var texture:Texture;
		private var image:Image;
		
		//public var name:String;
		
		public var client: Object;
		
		public var totalVideoTime:Number;
		public var videoWidth:Number;
		public var videoHeight:Number;
		public var trackerBarProgressWidth:Number;
		public var currentVideoTime:Number;
		public var minutesTotal:Number;
		public var secondsTotal:Number;
		public var minutesCurrent:Number;
		public var secondsCurrent:Number;


		public var isPlaying:Boolean;
		public var isPause:Boolean;
		public var isSoundMute:Boolean;
		
		
		public function vdoObject()
		{
			//super();
			//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function createObject(vdoPath:String):void
		{
			
			isPlaying = false;
			isSoundMute = false;
			isPause = false;
			nc = new NetConnection();
			nc.connect(null);
			
			
			file = File.applicationDirectory.resolvePath(vdoPath);
			
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, videoStatusEvent);
			
			client = new Object;
			ns.client = client;
			client.onMetaData = nsMetaDataCallback;
		}
		private function nsMetaDataCallback(mdata: Object): void {
			
			totalVideoTime = uint(mdata.duration);
			videoWidth = mdata.width;
			videoHeight = mdata.height;
			trackerBarProgressWidth = 0;
			currentVideoTime = 0;
			
			minutesTotal = Math.floor(totalVideoTime/60);
			secondsTotal = Math.floor(totalVideoTime%60);
			
			trace("total time = " + totalVideoTime, "-->" + minutesTotal+":"+secondsTotal);
			trace("vdo width = " + mdata.width);
			trace("vdo height = " + mdata.height);
			//trace(nsStream.info);
			
			trace("bytesLoaded = " + ns.bytesLoaded);
			trace("bytesTotal = " + ns.bytesTotal);
			
			this.addEventListener(Event.ENTER_FRAME, updatePlayer);
		}
		public function updatePlayer(e: Event): void {
			currentVideoTime = Number(ns.time);
			minutesCurrent = Math.floor(currentVideoTime/60);;
			secondsCurrent = Math.floor(currentVideoTime%60);;
		}
		public function videoStatusEvent(e: NetStatusEvent): void {
			
			switch (e.info.code) {
				case "NetStream.Play.Start":
					trace("video start!");
					break;
				
				case "NetStream.Play.Stop":
					//replay();
					stopVideo();
					playVideo();
					trace("video complete!");
					break;
				
				case "NetStream.Play.StreamNotFound":
					trace("Error : Stream Not Found");
					break;
				
				case "NetStream.Pause.Notify":
					trace("video pause!");
					break;
			}
		}
		public function playVideo():void 
		{
			if(isPlaying == false){
				ns.play(file.url);
			
				texture = Texture.fromNetStream(ns, 1, function():void		
				{
					addChild(new Image(texture));
				});
				isPlaying = true;
			}
			else{
				ns.resume();
				isPause = false;
			}
		}
		public function pauseVideo():void 
		{
			ns.pause();
			isPause = true;
		}
		public function stopVideo():void 
		{
			ns.pause();
			removeTexture();
			isPlaying = false;
			trace("Stop VDO !!!!!");
		}
		public function seekVideo(time:Number):void
		{
			ns.pause();
			ns.seek(time);
			ns.resume();
		}
		private function removeTexture():void 
		{
			while(this.numChildren > 0){
				this.removeChildAt(0, true);
			}
			ns.close();
			texture.dispose();
			trace(this.numChildren);
		}
		
		public function setVolume(intVolume: Number): void {
			var sndTransform:SoundTransform = new SoundTransform(intVolume);
			ns.soundTransform = sndTransform;
		}
		public function muteSound(): void {
			setVolume(0);
			isSoundMute = true;
		}
		public function unmuteSound(): void {
			setVolume(1);
			isSoundMute = false;
		}
		
		
		public function removeObject():void 
		{
			trace("Remove !!!!");
			this.parent.removeChild(this);
			//this.removeChild(normal_box);
		}
	}
}