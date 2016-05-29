package app_objects
{

import app_events.FullscreenEvent;
import app_events.NavigationEvent;

import com.greensock.*;
import com.greensock.easing.*;

import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.filesystem.FileMode;
import flash.events.Event;
import flash.geom.*;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setTimeout;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

import starling.display.Canvas;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;


public class VideosGalleryObject extends Sprite
{
	[Embed(source="/Resources/systems/fonts/verdana.ttf",fontFamily="Verdana",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
	protected static const Verdana:Class;

	private var dot_active:Image;
	private var dot_inactive:Image;
	private var dot_next:Image;
	private var dot_back:Image;
	private var dot_container:Sprite;
	
	private var fullscreenAreaObject:Sprite;
	private var fullscreenArea:Canvas;

	private var back_img:Image;
	private var next_img:Image;

	private var vdo_frame:Image;
	private var vdo_thumb:Image;
	private var vdo_obj:app_objects.vdoObject;
	private var vdo_play:Image;
	private var vdo_pause:Image;
	private var vdo_full:Image;
	private var vdo_bar_1:Image;
	private var vdo_bar_2:Image;
	private var vdo_bar_3:Image;
	private var vdo_play_button:Image;
	private var isPlaying:Boolean;
	private var isPreview:Boolean;

	private var title:Image;
	private var title_container:Sprite;

	private var sAssets:AssetManager;

	private var rectMask:Canvas;

	private var galleryContainer:Sprite;
	private var picContainer:Sprite;
	private var vdoContainer:Sprite;

	private var touchPosition:Point;
	private var i:Number;
	private var l:Number;
	private var dotSet:int;
	private var dotNum:Number;
	private var dotRemain:Number;
	private var currentDotSet:Number;
	private var picNum:Number;
	private var picWidth:Number;
	private var picHeight:Number;
	private var totalVideos:Number;
	public var galleryPosX:Number;

	private var filesList:Array;
	private var filesList2:Array;

	private var vdoDownPosition:Point;
	private var vdoUpPosition:Point;
	private var prvTouched:Number;
	private var currentTouched:Number;
	private var startTouchTime:Number;
	private var endTouchTime:Number;
	private var elapsedTime:Number;

	private var timeMinute:String;
	private var timeSecond:String;
	private var timeTotalMinute:String;
	private var timeTotalSecond:String;
	private var totalVDOTime:String;

	private var vdoObject:Vector.<Image> = new Vector.<Image>();
	private var dotObject:Vector.<Image> = new Vector.<Image>();
	private var titleObject:Vector.<Image> = new Vector.<Image>();
	private var videosPath:Vector.<String> = new Vector.<String>();

	public var settingComplete:Boolean;
	private var intervalID:uint;
	private var intervalIDPlayButton:uint;
	private var intervalIDReady:uint;
	private var fullscreenMode:Boolean;

	private var vdoTimeText:TextField;

	private var vdoStatus:String;
	
	public var date:Date;
	public var dateRec:String = "";
	public var timeRec:String = "";
	public var fileRecord:File = new File();
	public var fileStream:FileStream;
	public var recIntervalID:uint;


	public function VideosGalleryObject()
	{
		//super();
		//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	private function onAddedToStage(event:starling.events.Event):void
	{
		//this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	public function createGallery(assets:AssetManager):void
	{
		sAssets = assets;

		vdoStatus = "create video gallery";

		isPreview = false;

		settingComplete = false;
		videosPath.length = 0;
		filesList = new Array();
		filesList2 = new Array();
		galleryPosX = 0;
		currentDotSet = 1;
		dotNum = 0;

		galleryContainer = new Sprite();
		galleryContainer.x = 0;
		galleryContainer.y = 0;
		this.addChild(galleryContainer);


		picContainer = new Sprite();
		galleryContainer.addChild(picContainer);

		title_container = new Sprite();
		this.addChild(title_container);

		loadVideos();
		loadTitleImages();

		back_img = new Image(sAssets.getTexture("button_back"));
		back_img.name = "back";
		back_img.pivotX = back_img.width/2;
		back_img.pivotY = back_img.height/2;
		this.addChild(back_img);

		next_img = new Image(sAssets.getTexture("button_next"));
		next_img.name = "next";
		next_img.pivotX = next_img.width/2;
		next_img.pivotY = next_img.height/2;
		this.addChild(next_img);

		vdo_play = new Image(sAssets.getTexture("video_play_button"));
		vdo_play.pivotX = vdo_play.width/2; vdo_play.pivotY = vdo_play.height/2;
		vdo_play.name = "vdo_play";
		this.addChild(vdo_play);

		vdo_pause = new Image(sAssets.getTexture("video_pause_button"));
		vdo_pause.pivotX = vdo_pause.width/2; vdo_pause.pivotY = vdo_pause.height/2;
		vdo_pause.name = "vdo_pause";
		this.addChild(vdo_pause);
		vdo_pause.visible = false;

		vdo_full = new Image(sAssets.getTexture("video_full_button"));
		vdo_full.pivotX = vdo_full.width/2; vdo_full.pivotY = vdo_full.height/2;
		vdo_full.name = "vdo_full";
		this.addChild(vdo_full);

		vdo_bar_1 = new Image(sAssets.getTexture("video_progressbar_bg"));
		this.addChild(vdo_bar_1);

		vdo_bar_2 = new Image(sAssets.getTexture("video_progressbar_display"));
		this.addChild(vdo_bar_2);
		vdo_bar_2.scaleX = 0;

		vdo_bar_3 = new Image(sAssets.getTexture("video_progressbar_position"));
		vdo_bar_3.pivotX = vdo_bar_3.width/2; vdo_bar_3.pivotY = vdo_bar_3.height/2;
		this.addChild(vdo_bar_3);


		vdo_play_button = new Image(sAssets.getTexture("video_playbutton"));
		vdo_play_button.pivotX = vdo_play_button.width/2; vdo_play_button.pivotY = vdo_play_button.height/2;
		vdo_play_button.touchable = false;
		this.addChild(vdo_play_button);


		vdoTimeText = new TextField(200, 30, "00:00|00:00");
		vdoTimeText.format = new TextFormat("verdana", 15, 0xffffff);
		vdoTimeText.format.horizontalAlign = Align.RIGHT;
		vdoTimeText.format.verticalAlign = Align.CENTER;
		vdoTimeText.pivotX = vdoTimeText.width;
		this.addChild(vdoTimeText);
		
		fullscreenAreaObject = new Sprite();
		this.addChild(fullscreenAreaObject);
		fullscreenArea = new Canvas();
		fullscreenArea.drawRectangle(0, 0, 1920, 1080);
		fullscreenAreaObject.addChild(fullscreenArea);
		fullscreenAreaObject.alpha = 0;
		fullscreenAreaObject.visible = false;


		picNum = 0;

		galleryContainer.addEventListener(TouchEvent.TOUCH, onTouch);
		back_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
		next_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
	}
	public function loadVideos():void{
		var picPath:String = "Resources/product_configuration/videos/video_files";
		var picFile:File = File.applicationDirectory.resolvePath(picPath);
		try {
			filesList = picFile.getDirectoryListing();
		} catch (e:Error) {
			//
		}
		totalVideos = filesList.length;
		//trace("totalVideos = "+totalVideos);

		setTimeout(setPic, 200);
	}
	public function loadTitleImages():void{
		var titlePath:String = "Resources/product_configuration/videos/video_titles";
		var titleFile:File = File.applicationDirectory.resolvePath(titlePath);
		filesList2 = titleFile.getDirectoryListing();
		sAssets.enqueue(titleFile);
		sAssets.loadQueue(function(ratio:Number):void
		{
//			trace("Loading assets, progress:", ratio);
			if (ratio == 1.0)
				for(i=0, l=filesList2.length;i<l;++i){
					title = new Image(sAssets.getTexture(getFileName(filesList2[i].name)));
					title.pivotX = title.width;
					title.visible = false;
					title_container.addChild(title);
					titleObject.push(title);
				}
		});

	}
	private function getFileName($url:String):String {
		var extRemoved:String = $url.slice($url.lastIndexOf("/") + 1, $url.lastIndexOf("."));
		return extRemoved;
	}
	private function setPic():void{

		var TextureName:String
		for(i=1, l=totalVideos;i<=l;++i){
			TextureName = filesList[i-1].nativePath;
			videosPath.push(TextureName);
			vdo_thumb = new Image(sAssets.getTexture("video_thumb"));
			vdo_thumb.scale = 1;
			picContainer.addChild(vdo_thumb);
			vdoObject.push(vdo_thumb);
		}
		try {
			picWidth = vdoObject[0].width;
			picHeight = vdoObject[0].height;
		} catch (e:Error) {

		}
		for(i=0, l=vdoObject.length;i<l;++i){
			vdoObject[i].x = 0 + picWidth*i;
			vdoObject[i].y = 0;
		}

		//trace(galleryContainer.width);
		galleryPosX =  (stage.stageWidth - vdoObject[0].width)/2;
		galleryContainer.x = galleryPosX;

		rectMask = new Canvas();
		rectMask.beginFill(0x000000);
		rectMask.drawRectangle(0, 0, picWidth, picHeight);
		
		galleryContainer.mask = rectMask;

		vdo_frame = new Image(sAssets.getTexture("video_frame"));
		this.addChild(vdo_frame);
		vdo_frame.touchable = false;
		vdo_frame.x = galleryContainer.x;
		vdo_frame.y = galleryContainer.y;

		back_img.x = galleryContainer.x - back_img.width/2 - 10;
		back_img.y = galleryContainer.y + picHeight - back_img.height/2;

		next_img.x = galleryContainer.x + picWidth + next_img.width/2 + 10;
		next_img.y = galleryContainer.y + picHeight - next_img.height/2;


		vdo_play.x = galleryContainer.x + 20;
		vdo_play.y = galleryContainer.y + picHeight + 60;
		vdo_pause.x = galleryContainer.x + 20;
		vdo_pause.y = galleryContainer.y + picHeight + 60;

		vdo_full.x = galleryContainer.x + picWidth - 35;
		vdo_full.y = galleryContainer.y + picHeight + 60;

		vdo_bar_1.x = vdo_play.x + 27;
		vdo_bar_1.y = galleryContainer.y + picHeight - vdo_bar_1.height/2 + 60;
		vdo_bar_2.x = vdo_play.x + 27;
		vdo_bar_2.y = galleryContainer.y + picHeight - vdo_bar_2.height/2 + 60;
		vdo_bar_3.x = vdo_bar_1.x;
		vdo_bar_3.y = vdo_play.y;

		vdo_play_button.x = galleryContainer.x + (picWidth/2);
		vdo_play_button.y = galleryContainer.y + (picHeight/2);

		vdoTimeText.x = vdo_bar_1.x + vdo_bar_1.width;
		vdoTimeText.y = vdo_bar_1.y - 40;

		dotSet = int(totalVideos/5);
		dotRemain = totalVideos%5;
		dot_container = new Sprite();
		this.addChild(dot_container);
		for(i=1, l=5;i<=l;++i){
			dot_inactive = new Image(sAssets.getTexture("index_normal"));
			dot_inactive.pivotX = dot_inactive.width/2;
			dot_inactive.pivotY = dot_inactive.height/2;
			dot_inactive.x = dot_inactive.width/2 + (dot_inactive.width+20)*(i-1);
			dot_container.addChild(dot_inactive);
			dotObject.push(dot_inactive);
		}
		dot_active = new Image(sAssets.getTexture("index_current"));
		dot_active.pivotX = dot_active.width/2;
		dot_active.pivotY = dot_active.height/2;
		dot_container.addChild(dot_active);
		dot_active.x = dotObject[0].x;

		dot_container.x = (stage.stageWidth - dot_container.width)/2;
		dot_container.y = 640;

		dot_next = new Image(sAssets.getTexture("dot_next"));
		dot_next.pivotX = dot_next.width/2; dot_next.pivotY = dot_next.height/2;
		this.addChild(dot_next);

		dot_back = new Image(sAssets.getTexture("dot_back"));
		dot_back.pivotX = dot_back.width/2; dot_back.pivotY = dot_back.height/2;
		this.addChild(dot_back);


		title_container.x = galleryContainer.x + picWidth;
		title_container.y = galleryContainer.y - 65;
		try {
			titleObject[0].visible = true;
		} catch (e:Error) {}

//		vdo_play_button.addEventListener(TouchEvent.TOUCH, onPlayVDOTouch);
		galleryContainer.touchable = false;
//		setTimeout(setButtonEvent, 200);

		settingComplete = true;
	}
	public function init():void
	{
		vdoStatus = "init";
		galleryContainer.touchable = false;
		unsetButtonEvent();

		vdo_bar_2.scaleX = 0;
		vdo_bar_3.x = vdo_bar_1.x;

		vdo_play_button.visible = true;
		vdoTimeText.visible = false;
		vdoTimeText.text = "00:00|00:00";
		picContainer.x = 0;
		picNum = 0;
		dotNum = 0;
		currentDotSet = 1;
		dot_active.x = dotObject[0].x;
		if(dotSet < 1){
			setEnableDot(dotRemain);
		}
		else{
			setEnableDot(5);
		}

		setTitle();
		playCurrentVideo();
		setButtonEvent();
		removeVideoButtonEvent();
	}
	public function playCurrentVideo():void
	{
		clearInterval(intervalID);
		if(vdo_obj){
			vdo_obj.stopVideo();
			picContainer.removeChild(vdo_obj);
		}
		vdo_obj = new app_objects.vdoObject();
		vdo_obj.createObject(videosPath[picNum]);
		picContainer.addChild(vdo_obj);
		vdo_obj.muteSound();
		vdo_obj.visible = false;
		vdo_obj.x = vdoObject[picNum].x;

		intervalID = setTimeout(function():void{
			clearInterval(intervalID);
			vdoStatus = "ready";
			play();
			setTimeout(function():void{
				if(vdo_obj.videoHeight == 1080){
					vdo_obj.scale = 0.48;
				}
				else if(vdo_obj.videoHeight == 720){
					vdo_obj.scale = 0.72;
				}
				else{
					vdo_obj.width = 923;
					vdo_obj.height = 520;
				}
//				vdo_obj.visible = true;
				fullscreenMode = false;

				if (vdo_obj.minutesTotal < 10){
					timeTotalMinute = "0" + vdo_obj.minutesTotal;
				}
				else{
					timeTotalMinute = String(vdo_obj.minutesTotal);
				}
				if (vdo_obj.secondsTotal < 10){
					timeTotalSecond = "0" + vdo_obj.secondsTotal;
				}
				else{
					timeTotalSecond = String(vdo_obj.secondsTotal);
				}

				vdo_bar_2.scaleX = 0;
				vdo_bar_3.x = vdo_bar_1.x;
				totalVDOTime = timeTotalMinute+":"+timeTotalSecond;
				vdoTimeText.text = "00:00 | 00:00";
				vdoTimeText.visible = true;

//				clearInterval(intervalIDReady);
				setReady();
//				setVideoButtonEvent();
			},200);

		},200);

	}
	public function setReady():void
	{
		pause();
		goto(10);
		pause();
//		setVideoButtonEvent();
		intervalIDReady = setTimeout(function ():void {
			vdo_obj.visible = true;
			vdo_play_button.visible = true;
			isPreview = true;
		}, 100);
		vdo_pause.visible = false;
		vdo_play.visible = true;

	}
	public function firstPlay():void
	{
		goto(0);
		play();
		setVideoButtonEvent();
		setTimeout(function ():void {
			vdo_obj.unmuteSound();
		}, 100);
		vdoStatus = "playing";
		saveData(filesList[picNum].name);
	}
	public function play():void
	{
		vdo_obj.playVideo();
		vdo_pause.visible = true;
		vdo_play.visible = false;
	}
	public function pause():void
	{
		vdo_obj.pauseVideo();
		vdo_pause.visible = false;
		vdo_play.visible = true;
	}
	public function goto(time:Number):void
	{
		vdo_obj.seekVideo(time);
	}
	/*private function onPlayVDOTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			var current_touchPosition:Point = touch.getLocation(stage);
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				if(stage.hitTest(current_touchPosition) == touch.target){
					if(vdoStatus == "ready"){
						firstPlay();
						touch.target.visible = false;
					}
					else{
						play();
						touch.target.visible = false;
					}
				}

			}
		}
	}*/
	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(stage);
		var distance:int;
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			touchPosition = touch.getLocation(this);
			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				trace("on finger down");
				if(fullscreenMode == false) {
					startTouchTime = getTimer();
					vdoDownPosition = touchPosition;
					prvTouched = touchPosition.x;
					currentTouched = touchPosition.x;
//				clearInterval(intervalIDPlayButton);
					vdo_play_button.visible = false;
				}
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger move
				trace("on finger move");
				if(fullscreenMode == false){
					prvTouched = currentTouched;
					currentTouched = touchPosition.x;
					distance = int(currentTouched - prvTouched)
					picContainer.x += (int(distance));
//				clearInterval(intervalIDPlayButton);
					vdo_play_button.visible = false;
				}
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				trace("on finger up");
				endTouchTime = getTimer();
				elapsedTime = endTouchTime - startTouchTime;
				vdoUpPosition = touchPosition;
				//trace("elapsedTime = "+elapsedTime);
				if(elapsedTime < 400 && vdoUpPosition.x != vdoDownPosition.x){
//					clearInterval(intervalIDPlayButton);
//					clearInterval(intervalIDReady);
					vdo_play_button.visible = false;
					checkDirection("touch");
				}
				else if(elapsedTime < 400 && vdoUpPosition.x == vdoDownPosition.x){
//					play();
					//trace("vdoStatus--"+vdoStatus, "fullscreenMode--"+fullscreenMode);
					if(vdoStatus == "ready" && isPreview == true){
						firstPlay();
//						clearInterval(intervalIDPlayButton);
//						clearInterval(intervalIDReady);
						vdo_play_button.visible = false;
					}
					else if(vdoStatus == "playing" && fullscreenMode == false){
						pause();
						vdo_play_button.visible = true;
						vdoStatus = "pause";
					}
					else if(vdoStatus == "playing" && fullscreenMode == true){
						exitFullscreen();

					}
					else if(vdoStatus == "pause" && fullscreenMode == false){
						play();
						vdo_play_button.visible = false;
						vdoStatus = "playing";
					}
				}
				else{
					if(Math.abs(vdoUpPosition.x - vdoDownPosition.x) > picWidth/2){
						checkDirection("touch");
						/*if(fullscreenMode == false){
							checkDirection("touch");
						}*/
					}
					else{
						unsetButtonEvent();
						if(vdoStatus == "ready" || vdoStatus == "pause"){
							intervalIDPlayButton = setTimeout(function ():void {
//								clearInterval(intervalIDPlayButton);
								vdo_play_button.visible = true;
							}, 500);
						}
						TweenMax.to(picContainer, 0.5, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
					}
				}
			}
		}
	}
	private function onButtonTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(stage);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			var touchedButton:Image = event.currentTarget as Image;

			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				TweenMax.to(touchedButton, 0.2, {scaleX:0.85, scaleY:0.85, ease:Sine.easeOut});
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				TweenMax.to(touchedButton, 0.2, {scaleX:1, scaleY:1, ease:Sine.easeOut});

				checkDirection(touchedButton.name);
			}
		}
	}
	private function checkDirection(actionType:String):void
	{
		var touchDirection:String = "";
		if(actionType == "touch"){
			if(vdoUpPosition.x > vdoDownPosition.x && fullscreenMode == false){
				touchDirection = "back";
				picNum--;
				if(picNum < 0){
					picNum = 0;
					unsetButtonEvent();
					TweenMax.to(picContainer, 0.3, {x:0, ease:Sine.easeOut, onComplete:setButtonEvent});
				}
				else{
					unsetButtonEvent();
					TweenMax.to(picContainer, 0.3, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
				}
			}
			else if(vdoUpPosition.x < vdoDownPosition.x && fullscreenMode == false){
				touchDirection = "next";
				picNum++;
				if(picNum > totalVideos-1){
					picNum = totalVideos-1
					unsetButtonEvent();
					TweenMax.to(picContainer, 0.3, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
				}
				else{
					unsetButtonEvent();
					TweenMax.to(picContainer, 0.3, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
				}
			}
		}
		else if(actionType == "back"){
//			clearInterval(intervalIDReady);
			touchDirection = actionType;
			picNum--;
			if(picNum < 0){
				picNum = 0;
				unsetButtonEvent();
				TweenMax.to(picContainer, 0.2, {x:20, ease:Sine.easeOut});
				TweenMax.to(picContainer, 0.2, {x:0, ease:Sine.easeOut, delay:0.2, onComplete:setButtonEvent});
			}
			else{
				unsetButtonEvent();
				TweenMax.to(picContainer, 0.3, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
			}
		}
		else if(actionType == "next"){
//			clearInterval(intervalIDReady);
			touchDirection = actionType;
			picNum++;
			if(picNum > totalVideos-1){
				picNum = totalVideos-1
				unsetButtonEvent();
				TweenMax.to(picContainer, 0.2, {x:-(picNum*picWidth+40), ease:Sine.easeOut});
				TweenMax.to(picContainer, 0.2, {x:-(picNum*picWidth), ease:Sine.easeOut, delay:0.2, onComplete:setButtonEvent});
			}
			else{
				unsetButtonEvent();
				TweenMax.to(picContainer, 0.3, {x:-(picNum*picWidth), ease:Sine.easeOut, onComplete:setButtonEvent});
			}
		}
		setActiveDot(touchDirection);
		setTitle();
		playCurrentVideo();
		removeVideoButtonEvent();
		vdoTimeText.visible = false;
		vdo_play_button.visible = false;
		isPreview = false;
//		clearInterval(intervalIDPlayButton);
//		clearInterval(intervalIDReady);
	}
	public function setButtonEvent():void
	{
		galleryContainer.touchable = true;
		back_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
		next_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
	}
	public function unsetButtonEvent():void
	{
		vdo_play_button.visible = false;
		galleryContainer.touchable = false;
		back_img.removeEventListener(TouchEvent.TOUCH, onButtonTouch);
		next_img.removeEventListener(TouchEvent.TOUCH, onButtonTouch);
	}

	public function setTitle():void
	{
		for(i=0, l=titleObject.length;i<l;++i){
			titleObject[i].visible = false;
		}
		try {
			titleObject[picNum].visible = true;
		} catch (e:Error) {
			//
		}
	}
	public function setActiveDot(direction:String):void
	{

		//trace("dotNum before = "+dotNum, dotRemain, currentDotSet, dotSet);
		if(direction == "next"){
			dotNum++;
			if(currentDotSet == (dotSet+1) &&  dotNum > dotRemain-1){
				currentDotSet = currentDotSet;
				dotNum = dotNum-1;
			}
			else if(dotNum > 4){

				currentDotSet++;
				if(currentDotSet > dotSet && dotRemain == 0){
					setEnableDot(5);
					currentDotSet = dotSet;
					dotNum = 4;
				}
				else if(currentDotSet == (dotSet+1) && dotRemain > 0){
					setEnableDot(dotRemain);
					dotNum = 0;
				}
				else{
					setEnableDot(5);
					dotNum = 0;
				}
			}
		}
		else if(direction == "back"){
			dotNum--;
			if(dotNum < 0){
				if(currentDotSet == 1 && dotSet < 1){
					setEnableDot(dotRemain);
				}
				else{
					setEnableDot(5);
				}
				currentDotSet--;
				if(currentDotSet < 1){
					currentDotSet = 1;
					dotNum = 0;
				}
				else{
					dotNum = 4;
					setEnableDot(5);
				}
			}
		}
		//trace("dotNum after = "+dotNum);

		dot_active.x = dotObject[dotNum].x;

	}
	public function setEnableDot(dot:int):void
	{
		for(i=0, l=dotObject.length;i<l;++i){
			if(i > dot-1){
				dotObject[i].alpha = 0;
			}
			else{
				dotObject[i].alpha = 1;
			}
		}
		if(totalVideos == 1){
			dot_container.visible = false;
		}
		else{
			dot_container.visible = true;
		}
		trace(dotSet, currentDotSet);
		if(dotSet == 0){
			dot_next.visible = false; dot_back.visible = false;
		}
		else if(dotSet == 1 && totalVideos == 5){
			dot_next.visible = false; dot_back.visible = false;
		}
		else if(dotSet> 0 && currentDotSet == 1){
			dot_next.visible = true; dot_back.visible = true;
			dot_next.alpha = 1; dot_back.alpha = 0.3;
		}
		else if(dotSet> 0 && currentDotSet == dotSet+1){
			dot_next.visible = true; dot_back.visible = true;
			dot_next.alpha = 0.3; dot_back.alpha = 1;
		}
		else if(dotSet> 1 && currentDotSet != dotSet){
			dot_next.visible = true; dot_back.visible = true;
			dot_next.alpha = 1; dot_back.alpha = 1;
		}
		dot_container.x = (stage.stageWidth - dot_container.width*(dot/5))/2;
		dot_back.x = dot_container.x - 30; dot_back.y = dot_container.y;
		var lastDotX:Number = dot_inactive.width/3 + (dot_inactive.width+20)*dot;
		dot_next.x = dot_container.x + lastDotX; dot_next.y = dot_container.y;

	}
	public function setVideoButtonEvent():void
	{
		vdo_play.addEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		vdo_pause.addEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		vdo_full.addEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		addEventListener(starling.events.Event.ENTER_FRAME, chkProgress);
	}
	public function removeVideoButtonEvent():void
	{
		vdo_play.removeEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		vdo_pause.removeEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		vdo_full.removeEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
		removeEventListener(starling.events.Event.ENTER_FRAME, chkProgress);
	}
	public function chkProgress(e:starling.events.Event):void {
		vdo_bar_2.scaleX = vdo_obj.currentVideoTime / vdo_obj.totalVideoTime;
		vdo_bar_3.x = vdo_bar_2.x + vdo_bar_2.width;
		if (vdo_bar_2.scaleX > 1) {
			vdo_bar_2.scaleX = 1;
			vdo_bar_3.x = vdo_bar_2.x + vdo_bar_2.width;
		}
		if (vdo_obj.minutesCurrent < 10){
			timeMinute = "0" + vdo_obj.minutesCurrent;
		}
		else{
			timeMinute = String(vdo_obj.minutesCurrent);
		}
		if (vdo_obj.secondsCurrent < 10){
			timeSecond = "0" + vdo_obj.secondsCurrent;
		}
		else{
			timeSecond = String(vdo_obj.secondsCurrent);
		}

		vdoTimeText.text = timeMinute+":"+timeSecond+" | "+totalVDOTime;
	}
	private function onVideoButtonTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			var touchedButton:Object = event.currentTarget;
			var touchedObj:app_objects.vdoObject = event.currentTarget as app_objects.vdoObject;

			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				trace("touch down");
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger moved

			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				trace("touch up");
				if(touchedButton.name == "vdo_play"){
					if(vdo_obj.isPause == true){
						play();
						vdo_play_button.visible = false;
						vdoStatus = "playing";
					}
				}
				else if(touchedButton.name == "vdo_pause"){
					if(vdo_obj.isPause == false){
						pause();
						vdo_play_button.visible = true;
						vdoStatus = "pause";
					}
				}
				else if(touchedButton.name == "vdo_full" && vdoStatus == "playing"){
					setFullscreen();
				}
				else if(touchedButton == fullscreenAreaObject){
					trace("vdo touch");
					exitFullscreen();
				}

				var current_touchPosition:Point;
				current_touchPosition = touch.getLocation(this);
				if(stage.hitTest(current_touchPosition) == touch.target){
//
				}
			}
		}
	}

	public function setFullscreen():void
	{
		if(fullscreenMode == false){
			fullscreenAreaObject.visible = true;
			vdo_frame.visible = false;
			dot_container.visible = false;
			next_img.visible = false;
			back_img.visible = false;
			vdo_bar_1.visible = false;
			vdo_bar_2.visible = false;
			vdo_bar_3.visible = false;
			vdo_play.visible = false;
			vdo_pause.visible = false;
			vdo_full.visible = false;
			vdoTimeText.visible = false;
			for(i=0, l=totalVideos;i<l;++i){
				vdoObject[i].visible = false;
			}

			this.x = 0;
			this.y = 0;
			galleryContainer.x = 0;
			galleryContainer.y = 0;
			rectMask.width = 1920;
			rectMask.height = 1080;
			if(vdo_obj.videoHeight == 1080){
				vdo_obj.scale = 1;
			}
			else if(vdo_obj.videoHeight == 720){
				vdo_obj.scale = 1.5;
			}
			else{
				vdo_obj.width = 1920;
				vdo_obj.height = 1080;
			}
			fullscreenMode = true;
			vdo_obj.addEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
			fullscreenAreaObject.addEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
			this.dispatchEvent(new FullscreenEvent(FullscreenEvent.VDO_FULLSCREEN, {id: "vdofullscreen"}, true));
		}
	}
	public function exitFullscreen():void
	{
		if(fullscreenMode == true){
			fullscreenAreaObject.visible = false;
			vdo_frame.visible = true;
			dot_container.visible = true;
			next_img.visible = true;
			back_img.visible = true;
			vdo_bar_1.visible = true;
			vdo_bar_2.visible = true;
			vdo_bar_3.visible = true;
			vdo_pause.visible = true;
			vdo_full.visible = true;
			vdoTimeText.visible = true;
			for(i=0, l=totalVideos;i<l;++i){
				vdoObject[i].visible = true;
			}

			this.x = 0;
			this.y = 200;
			galleryContainer.x = galleryPosX;
			galleryContainer.y = 0;
			rectMask.width = picWidth;
			rectMask.height = picHeight;
			if(vdo_obj.videoHeight == 1080){
				vdo_obj.scale = 0.48;
			}
			else if(vdo_obj.videoHeight == 720){
				vdo_obj.scale = 0.72;
			}
			else{
				vdo_obj.width = 923;
				vdo_obj.height = 520;
			}
			fullscreenMode = false;
			vdo_obj.removeEventListener(TouchEvent.TOUCH, onVideoButtonTouch);
			this.dispatchEvent(new FullscreenEvent(FullscreenEvent.VDO_NORMAL, {id: "vdonormal"}, true));
		}
	}

	//---------------------------------- save data log --------------------------------------
	public function saveData(fileName:String){
			getDateRec();
			getTimeRec();
			
			var allData:String = dateRec +","+ timeRec +","+ fileName +"\r\n";
			
			fileRecord = File.applicationDirectory;
			fileRecord = fileRecord.resolvePath(fileRecord.nativePath+"//Resources//product_configuration//log.csv");
			trace("Native path = "+fileRecord.nativePath);
		
			if(fileRecord.exists == false){
				trace("created file");
				allData = "DATE,TIME,FILE NAME\r\n" + allData;
				
				fileStream = new FileStream();
				fileStream.openAsync(fileRecord, FileMode.WRITE);
				fileStream.writeUTFBytes(allData);
				fileStream.addEventListener(flash.events.Event.CLOSE, fileClosed);
				fileStream.close();
				
			}
			else{
				trace("saved");
				fileStream = new FileStream();
				fileStream.openAsync(fileRecord, FileMode.APPEND);
				fileStream.writeUTFBytes(allData);
				fileStream.addEventListener(starling.events.Event.CLOSE, fileClosed);
				fileStream.close();
			}
	}
	public function fileClosed(event:flash.events.Event):void {
		trace("file seved complete");
		
	}
	public function getDateRec(){
		date = new Date();
		dateRec = String((date.dateUTC<10 ? "0"+date.dateUTC : date.dateUTC)+"/"+
						(date.monthUTC<10 ? "0"+(date.monthUTC+1) : date.monthUTC+1)+"/"+date.fullYearUTC);
		trace(dateRec);
	}
	public function getTimeRec(){
		date = new Date();
		timeRec = date.toLocaleTimeString();
		trace(timeRec);
	}
	//-------------------------------------------------------------------------------------------------------
	
	public function disposeObject():void
	{
		unsetButtonEvent();
		if(vdo_obj){
			vdo_obj.stopVideo();
			picContainer.removeChild(vdo_obj);
		}
		removeVideoButtonEvent();
		clearInterval(recIntervalID);
		
	}
	public function removeMe(e:starling.events.Event):void {
		if (videosPath.length == 0) {
			settingComplete = false;
			clearInterval(intervalID);
			removeEventListener(starling.events.Event.ENTER_FRAME, removeMe);
			this.parent.removeChild(this);
			trace("Remove !!!!");
		}
	}

}
}