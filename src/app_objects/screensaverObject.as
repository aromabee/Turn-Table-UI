package app_objects
{

import flash.utils.setTimeout;

// import starling.display.Image;
// import starling.events.Touch;
// import starling.events.TouchPhase;
// import starling.events.TouchEvent;
import starling.display.Sprite;
import starling.events.Event;
import starling.core.Starling;
import starling.utils.AssetManager;
import starling.display.Canvas;
import starling.animation.Transitions;
import starling.animation.Tween;


// import flash.utils.getTimer;
import flash.filesystem.File;
import app_objects.vdoObject;
	
import com.greensock.*;
import com.greensock.easing.*;


public class screensaverObject extends Sprite
{

	private var sAssets:AssetManager;
	private var videoPath:String;
	public var vdo_loop:vdoObject;
	
	public var fade_canvas:Canvas;
	public var fade_Object:Sprite;

	public function screensaverObject()
	{
		//super();
		//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	private function onAddedToStage(event:starling.events.Event):void
	{
		//this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	public function createScreensaver(vdoPath:String):void
	{
		videoPath = vdoPath;
		
		var vdoPath:String = vdoPath;
        var vdoFile:File = File.applicationDirectory.resolvePath(vdoPath);
        var filesList:Array = vdoFile.getDirectoryListing();
		
		vdo_loop = new vdoObject();
        vdo_loop.createObject(filesList[0].nativePath);
        this.addChild(vdo_loop);
		
		fade_Object = new Sprite();
		this.addChild(fade_Object);
		fade_canvas = new Canvas();
		fade_canvas.drawRectangle(0, 0, 1920, 1080);
		fade_Object.addChild(fade_canvas);
		fade_Object.alpha = 0;
		
	}
	public function chkVDOTimer(e:Event):void
	{
		if(vdo_loop.currentVideoTime >= vdo_loop.totalVideoTime-5){
			this.removeEventListener(Event.ENTER_FRAME, chkVDOTimer);
			var tween:Tween = new Tween(fade_Object, 1, Transitions.LINEAR);
				tween.fadeTo(1);
				Starling.juggler.add(tween);
			var tween2:Tween = new Tween(fade_Object, 1.2, Transitions.LINEAR);
				tween2.delay = 2;
				tween2.fadeTo(0);
				Starling.juggler.add(tween2);
			setTimeout(replayScreensaver, 1500);
			setTimeout(chkVDOTimerAgain, 1900);
		}
	}
	public function playScreensaver():void
	{
		vdo_loop.playVideo();
		this.addEventListener(Event.ENTER_FRAME, chkVDOTimer);
	}
	public function stopScreensaver():void
	{
		fade_Object.alpha = 0;
		vdo_loop.stopVideo();
		this.removeEventListener(Event.ENTER_FRAME, chkVDOTimer);
	}
	public function replayScreensaver():void
	{
		vdo_loop.seekVideo(5);
	}
	public function chkVDOTimerAgain():void
	{
		this.addEventListener(Event.ENTER_FRAME, chkVDOTimer);
	}
	
}
}