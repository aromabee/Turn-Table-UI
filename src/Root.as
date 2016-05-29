package {
//import original flash library

import app_events.FullscreenEvent;
import app_events.NavigationEvent;
import app_events.ControlEvent;
import app_events.SoundsEvent;
import app_events.RotationEvent;

import app_objects.mainMenuObject;
import app_objects.screensaverObject;
import app_objects.controlPanelObject;

import app_screens.MainScreen;
import app_screens.ImagesScreen;
import app_screens.VideosScreen;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.desktop.NativeApplication;
import flash.ui.Mouse;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

import starling.core.Starling;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.Canvas;
import starling.events.Touch;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import starling.extensions.plasticsturgeon.StarlingTimer;
import starling.extensions.plasticsturgeon.StarlingTimerEvent;


public class Root extends Sprite
{

	private var touch:Touch;
	private static var sAssets:AssetManager;

	public var main_menu:mainMenuObject;
	public var screensaver:screensaverObject;
	public var controlPanel:controlPanelObject;
	

	private var main_screen:MainScreen;
	private var images_screen:ImagesScreen;
	private var videos_screen:VideosScreen;
	
	private var hiddenButton:Sprite;
	private var hiddenButtonArea:Canvas;

	private var logo_img:Image;
	
	public static var controlStatus:String;

	private var mouseStatus:String;
	private static var sound_mute:Boolean;
	private static var sounds_manager:SoundsControl;

	private var touchPosition:Point;
	private var _RootObject:Vector.<Object> = new Vector.<Object>();

	private var i:Number;
	private var l:Number;
	private var current_touchPosition:Point;
	private var intervalID:uint;
	private var cPanelIntervalID:uint;
	private var currentGameScreen:String;

	//Timer
	private var xmlLoader:URLLoader = new URLLoader();
	public var home_idle_time:StarlingTimer;
	public var screensaver_idle_time:StarlingTimer;



	public function Root()
	{
		mouseStatus = "show";
		
	}
		
	//----------------------------------------------------- Rotation Functions ----------------------------------------------
	//---------------------------------------------------------------------------------------------------------------------------
	
	private function rotateLeft():void // rotate left
	{
		trace("rotate left");
	}
	private function rotateRight():void // rotate right
	{
		trace("rotate right");
	}
	private function stopRotate():void // stop rotate 
	{
		trace("stop rotate");
	}
	private function resetRotate():void // reset rotatation or set to default
	{
		trace("reset rotatation");
	}
	private function setHomeRotate():void // set home rotation
	{
		trace("set home");
	}
	private function autoRotate():void // set auto rotation
	{
		//rotateLeft();
		trace("set auto");
	}
	
	//---------------------------------------------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------------------------------------------
	
	
	
	
	//---------------------------------------------------- Start App Here !!! ------------------------------------------------
	private function startApp():void{
	
		//-------------- insert code hear ---------------------
	
		this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "main_screen"}, true));
	}
	//---------------------------------------------------------------------------------------------------------------------------
	
	public function start(assets:AssetManager):void {
		sAssets = assets;
		
		sound_mute = false;
		
		sounds_manager = new SoundsControl();
		sounds_manager.initialize(sAssets);

		xmlLoader.addEventListener(flash.events.Event.COMPLETE, getConfig);
		xmlLoader.load(new URLRequest("Resources/settings/setting.xml"));

		main_screen = new MainScreen();
		main_screen.initialize(sAssets);
		this.addChild(main_screen);
		_RootObject.push(main_screen);

		images_screen = new ImagesScreen();
		images_screen.initialize(sAssets);
		this.addChild(images_screen);
		_RootObject.push(images_screen);

		videos_screen = new VideosScreen();
		videos_screen.initialize(sAssets);
		this.addChild(videos_screen);
		_RootObject.push(videos_screen);

				
		main_menu = new mainMenuObject();
		main_menu.createObject(sAssets);
		this.addChild(main_menu);


		var vdoPath:String = "Resources/product_configuration/home/logo/";
        var vdoFile:File = File.applicationDirectory.resolvePath(vdoPath);
        var filesList:Array = vdoFile.getDirectoryListing();
		
		logo_img = new Image(sAssets.getTexture(getFileName(filesList[0].name)));
		this.addChild(logo_img);
		logo_img.x = 50;  logo_img.y = 50;
		
		hiddenButton = new Sprite();
		this.addChild(hiddenButton);
		hiddenButtonArea = new Canvas();
		hiddenButtonArea.drawRectangle(0, 0, 100, 100);
		hiddenButton.addChild(hiddenButtonArea);
		hiddenButtonArea.alpha = 0; 
		hiddenButton.x = 1920 - hiddenButton.width;
		hiddenButton.y = 1080 - hiddenButton.height;
		
		controlPanel = new controlPanelObject();
		controlPanel.createObject(sAssets);
		this.addChild(controlPanel);
		controlPanel.visible = false;
		
		
		screensaver = new screensaverObject();
		screensaver.createScreensaver("Resources/product_configuration/videos_screensaver/");
		this.addChild(screensaver);
		screensaver.visible = false;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, chkKB);
		this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);

		this.addEventListener(SoundsEvent.PLAY_SOUND, onPlaySound);
		this.addEventListener(SoundsEvent.PAUSE_SOUND, onPauseSound);
		this.addEventListener(SoundsEvent.RESUME_SOUND, onResumeSound);
		this.addEventListener(SoundsEvent.RESUME_LOOP_SOUND, onResumeLoopSound);
		this.addEventListener(SoundsEvent.STOP_SOUND, onStopSound);
		this.addEventListener(SoundsEvent.LOOP_SOUND, onPlayLoopSound);

		this.addEventListener(FullscreenEvent.VDO_FULLSCREEN, onFullscreenVDO);
		this.addEventListener(FullscreenEvent.VDO_NORMAL, onNormalVDO);

		this.addEventListener(ControlEvent.CONTROL_TYPE, onControlStatus);
		
		this.addEventListener(RotationEvent.ROTATION_STATE, onRotateStatus);

		logo_img.addEventListener(TouchEvent.TOUCH, onTouch);
		hiddenButton.addEventListener(TouchEvent.TOUCH, onTouch);

		addEventListener(Event.ENTER_FRAME, chkScreensComplete);

	}
	private function getFileName($url:String):String {
		var extRemoved:String = $url.slice($url.lastIndexOf("/") + 1, $url.lastIndexOf("."));
		return extRemoved;
	}
	public function getConfig(e:flash.events.Event): void {

		XML.ignoreWhitespace = true;
		var config:XML = new XML(e.target.data);
		var myXmlStr:String = config.toString();
		var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
		myXmlStr = myXmlStr.replace(xmlnsPattern, "");
		config = new XML(myXmlStr);
		var homeIdleTime:Number = Number(config.APP_SEETING.home_idle_time)*1000;
		//trace("setting time = "+homeIdleTime);
		home_idle_time = new StarlingTimer(Starling.juggler, homeIdleTime ,1);
		
		var screensaverIdleTime:Number = Number(config.APP_SEETING.screeaver_idle_time)*1000;
		screensaver_idle_time = new StarlingTimer(Starling.juggler, screensaverIdleTime ,1);
		
	}
	private function chkScreensComplete(event:Event):void{
		if(_RootObject.length >= 3) {
			var completeCount:int = 0;
			for(i=0, l=_RootObject.length; i<l; ++i){
				if(_RootObject[0].drawScreenComplete == true) {
					completeCount++;
				}
			}
			if(completeCount == _RootObject.length){
				removeEventListener(Event.ENTER_FRAME, chkScreensComplete);
				trace("all screens are complete");
				disposeAllScreens();
				startApp();
			}
		}
	}
	
	
	
	
	private function disposeAllScreens():void
	{
		for(i=0, l=_RootObject.length; i<l; ++i){
			_RootObject[i].disposeTemporarily();
		}
	}
	public static function exitApp():void
	{
		NativeApplication.nativeApplication.exit();
	}
	public static function muteSound():void
	{
		if(sound_mute == false){
			SoundMixer.soundTransform = new SoundTransform(0);
			sound_mute = true;
		}
		else{
			SoundMixer.soundTransform = new SoundTransform(1);
			sound_mute = false;
		}
	}
	private function displayControlPanel():void {
		controlPanel.visible = true;
	}
	
	public function gotoScreen(targetScreen:String):void{
		this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: targetScreen}, true));
	}

	private function onTouch(event:TouchEvent):void
	{
		touch = event.getTouch(event.currentTarget as DisplayObject);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			var touchedObject:Object = event.currentTarget;

			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				//trace("touch down");
				cPanelIntervalID = setTimeout(displayControlPanel, 2000);
				
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger moved

			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				//trace("touch up");
				current_touchPosition = touch.getLocation(this);
				if(touchedObject == logo_img){
					if(stage.hitTest(current_touchPosition) == touch.target){
						main_menu.displayRotation();
						startApp();
					}
				}
				else if(touchedObject == screensaver){
					hideScreensaver();
				}
				else if(touchedObject == hiddenButton){
					clearTimeout(cPanelIntervalID);
				}
			}
		}
	}

	public static function get assets():AssetManager { return sAssets; }

	public static function get controlState():String { return controlStatus; }
	
	private function onRotateStatus(event:RotationEvent):void {
		switch (event.params.id)
		{
			case "left":
				rotateLeft();
				break;
				
			case "right":
				rotateRight();
				break;
				
			case "stop":
				stopRotate()
				break;
				
			case "reset":
				resetRotate();
				break;
				
			case "auto":
				autoRotate();
				break;
				
			case "set_home":
				setHomeRotate();
				break;
		}
	}
	private function onControlStatus(event:ControlEvent):void {
		switch (event.params.id)
		{
			case "manual":
				controlStatus = "manual";
				main_screen.stopLoop();
				main_screen.rotationControl.showButton();
				main_screen.manual_symbol.visible = true;
				main_screen.loop_symbol_object.visible = false;
				main_menu.rotation_object.resetButton();
				main_menu.rotation_object.hand_button.touchable = false;
				main_menu.rotation_object.hand_button.setActivated();
				main_screen.manual_shortcut.visible = false;
			
				break;
				
			case "auto":
				controlStatus = "auto";
				main_screen.startLoop();
				main_screen.rotationControl.hideButton();
				main_screen.loop_symbol_object.visible = true;
				main_screen.manual_symbol.visible = false;
				main_screen.manual_shortcut.visible = true;
				break;
		}
	}
	
	private function onChangeScreen(event:NavigationEvent):void {
		disposeAllScreens();
		clearTimeout(cPanelIntervalID);
		main_menu.rotation_object.removeButtonEvent();
		if(home_idle_time && home_idle_time.running){
			home_idle_time.stop();
			home_idle_time.removeEventListener(TimerEvent.TIMER, chkIdleTime);
			stage.removeEventListener(TouchEvent.TOUCH, resetIdleTimer);
		}
		if(screensaver_idle_time && screensaver_idle_time.running){
			screensaver_idle_time.stop();
			screensaver_idle_time.removeEventListener(TimerEvent.TIMER, chkIdleTime);
			stage.removeEventListener(TouchEvent.TOUCH, resetIdleTimer);
		}

		switch (event.params.id)
		{
			case "main_screen":
				main_screen.startScreen();
				currentGameScreen = "main_screen";
				main_menu.displayRotation();
				main_menu.rotation_object.setInit();
				setTimeout(function():void{main_menu.rotation_object.setButtonEvent();}, 1800);
//				playSound("spin_snd");
				screensaver_idle_time.addEventListener(StarlingTimerEvent.TIMER, chkIdleTime);
				stage.addEventListener(TouchEvent.TOUCH, resetIdleTimer);
				screensaver_idle_time.start();
				break;
			case "images_screen":
				images_screen.startScreen();
				currentGameScreen = "images_screen";
				home_idle_time.addEventListener(StarlingTimerEvent.TIMER, chkIdleTime);
				stage.addEventListener(TouchEvent.TOUCH, resetIdleTimer);
				home_idle_time.start();
				break;
			case "videos_screen":
				videos_screen.startScreen();
				currentGameScreen = "videos_screen";
				home_idle_time.addEventListener(StarlingTimerEvent.TIMER, chkIdleTime);
				stage.addEventListener(TouchEvent.TOUCH, resetIdleTimer);
				home_idle_time.start();
				break;
		}
	}
	
	private function displayScreensaver():void {
		screensaver.visible = true;
		screensaver.playScreensaver();
		screensaver.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	private function hideScreensaver():void {
		screensaver.visible = false;
		screensaver.stopScreensaver();
		screensaver.removeEventListener(TouchEvent.TOUCH, onTouch);
		gotoScreen("main_screen");
	}
	
	private function chkIdleTime(e:StarlingTimerEvent):void{

		if(currentGameScreen == "main_screen"){
			if(home_idle_time.running){
				home_idle_time.stop();
				home_idle_time.reset();
				home_idle_time.start();
				home_idle_time.stop();
				home_idle_time.removeEventListener(TimerEvent.TIMER, chkIdleTime);
				stage.removeEventListener(TouchEvent.TOUCH, resetIdleTimer);
			} 
			else if(screensaver_idle_time.running){
				//displayScreensaver
				disposeAllScreens();
				displayScreensaver();
				//trace("go to screensaver");
			}			
		}
		else{
			home_idle_time.stop();
			home_idle_time.removeEventListener(TimerEvent.TIMER, chkIdleTime);
			stage.removeEventListener(TouchEvent.TOUCH, resetIdleTimer);
			//trace("There is no activity");
			gotoScreen("main_screen");
		}
	}

	private function resetIdleTimer(event:TouchEvent):void{
		touch = event.getTouch(stage);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			var touchedButton:Sprite = event.currentTarget as Sprite;

			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				if(home_idle_time.running){
					home_idle_time.stop();
					home_idle_time.reset();
					home_idle_time.start();
				}
				else if(screensaver_idle_time.running){
					screensaver_idle_time.stop();
					screensaver_idle_time.reset();
					screensaver_idle_time.start();
				}
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger moved
				if(home_idle_time.running){
					home_idle_time.stop();
					home_idle_time.reset();
					home_idle_time.start();
				}
				else if(screensaver_idle_time.running){
					screensaver_idle_time.stop();
					screensaver_idle_time.reset();
					screensaver_idle_time.start();
				}
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				if(home_idle_time.running){
					home_idle_time.stop();
					home_idle_time.reset();
					home_idle_time.start();
				}
				else if(screensaver_idle_time.running){
					screensaver_idle_time.stop();
					screensaver_idle_time.reset();
					screensaver_idle_time.start();
				}
			}
		}
	}

	private function onFullscreenVDO(event:FullscreenEvent):void {
		logo_img.visible = false;
		main_menu.visible = false;
		videos_screen.exit_button.visible = false;
	}
	private function onNormalVDO(event:FullscreenEvent):void {
		logo_img.visible = true;
		main_menu.visible = true;
		videos_screen.exit_button.visible = true;
	}

	

	////---------------------- Sound Part -------------------------------------------------------------

	private static function onPlaySound(event:SoundsEvent):void
	{
		sounds_manager.playSound(event.params.id);
	}
	private static function onPlayLoopSound(event:SoundsEvent):void
	{
		sounds_manager.playLoopSound(event.params.id);
	}
	private static function onPauseSound(event:SoundsEvent):void
	{
		sounds_manager.pauseSound(event.params.id);
	}
	private static function onResumeSound(event:SoundsEvent):void
	{
		sounds_manager.resumeSound(event.params.id);
	}
	private static function onResumeLoopSound(event:SoundsEvent):void
	{
		sounds_manager.resumeLoopSound(event.params.id);
	}
	private static function onStopSound(event:SoundsEvent):void
	{
		sounds_manager.stopSound(event.params.id);
	}

	//---------------------- Keybord Part -------------------------------------------------------------
	public function chkKB(e:KeyboardEvent):void {

		if(e.keyCode == 77 && e.ctrlKey){ // hide or show mouse >> Ctrl+M
			if(mouseStatus == "show"){
				Mouse.hide();
				mouseStatus = "hide";
			}
			else if(mouseStatus == "hide"){
				Mouse.show();
				mouseStatus = "show";
			}
		}
		if(e.keyCode == 32){ // space bar
			//startApp();
			exitApp();
		}
	}
}
}