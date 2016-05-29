package app_objects
{

import flash.utils.setTimeout;

import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchPhase;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.utils.AssetManager;
import starling.display.Canvas;

import com.greensock.*;
import com.greensock.easing.*;

import flash.utils.getTimer;
import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.filesystem.FileMode;
import flash.events.Event;
import flash.geom.*;
import flash.utils.clearInterval;



public class ImagesGalleryObject extends Sprite
{

	private var dot_active:Image;
	private var dot_inactive:Image;
	private var dot_next:Image;
	private var dot_back:Image;
	private var dot_container:Sprite;

	private var back_img:Image;
	private var next_img:Image;
	private var pic:Image;

	private var title:Image;
	private var title_container:Sprite;

	private var sAssets:AssetManager;

	private var rectMask:Canvas;

	private var galleryContainer:Sprite;
	private var picContainer:Sprite;

	private var touchPosition:Point;
	private var i:Number;
	private var l:Number;
	private var dotSet:int;
	private var dotNum:Number;
	private var dotRemain:Number;
	private var currentDotSet:Number;
	private var picNum:Number;
	private var picWidth:Number;
	private var totalImages:Number;
	public var galleryPosX:Number;

	private var filesList:Array;
	private var filesList2:Array;

	private var picDownPosition:Point;
	private var picUpPosition:Point;
	private var prvTouched:Number;
	private var currentTouched:Number;
	private var startTouchTime:Number;
	private var endTouchTime:Number;
	private var elapsedTime:Number;

	private var picObject:Vector.<Image> = new Vector.<Image>();
	private var dotObject:Vector.<Image> = new Vector.<Image>();
	private var titleObject:Vector.<Image> = new Vector.<Image>();
	private var currentTexture:Vector.<String> = new Vector.<String>();
	
	public var date:Date;
	public var dateRec:String = "";
	public var timeRec:String = "";
	public var fileRecord:File = new File();
	public var fileStream:FileStream;
	public var recIntervalID:uint;
	
	

	public var settingComplete:Boolean;

	public function ImagesGalleryObject()
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

		settingComplete = false;
		currentTexture.length = 0;
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

		loadImages();
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

		picNum = 0;

		galleryContainer.addEventListener(TouchEvent.TOUCH, onTouch);
		back_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
		next_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
	}
	public function loadImages():void{
		var picPath:String = "Resources/product_configuration/images/image_files";
		var picFile:File = File.applicationDirectory.resolvePath(picPath);
		filesList = picFile.getDirectoryListing();
		totalImages = filesList.length;
		trace("totalImages = "+totalImages);
		for(i=0, l=filesList.length;i<l;++i){
//			trace(filesList[i].nativePath);
//			trace(filesList[i].name);
		}

		sAssets.enqueue(picFile);
		sAssets.loadQueue(function(ratio:Number):void
		{
			trace("Loading assets, progress:", ratio);
			if (ratio == 1.0)
				setTimeout(setPic, 200);
		});

	}
	public function loadTitleImages():void{
		var titlePath:String = "Resources/product_configuration/images/image_titles";
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
		for(i=1, l=totalImages;i<=l;++i){
			TextureName = getFileName(filesList[i-1].name);
			currentTexture.push(TextureName);
			pic = new Image(sAssets.getTexture(TextureName));
			pic.scale = 1;
			picContainer.addChild(pic);
			picObject.push(pic);

		}
		picWidth = picObject[0].width;
		for(i=0, l=picObject.length;i<l;++i){
			picObject[i].x = 0 + picWidth*i;
			picObject[i].y = 0;
		}
		trace(galleryContainer.width);
		galleryPosX =  (stage.stageWidth - picObject[0].width)/2;
		galleryContainer.x = galleryPosX;

		rectMask = new Canvas();
		rectMask.beginFill(0x000000);
		rectMask.drawRectangle(0, 0, picWidth, 500);
//		this.addChild(rectMask);
		galleryContainer.mask = rectMask;

		back_img.x = galleryContainer.x + back_img.width/2;
		back_img.y = galleryContainer.y + galleryContainer.height - back_img.height/2;

		next_img.x = galleryContainer.x + picWidth - next_img.width/2;
		next_img.y = galleryContainer.y + galleryContainer.height - next_img.height/2;


		dotSet = int(totalImages/5);
		dotRemain = totalImages%5;
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
		dot_container.y = 540;

		dot_next = new Image(sAssets.getTexture("dot_next"));
		dot_next.pivotX = dot_next.width/2; dot_next.pivotY = dot_next.height/2;
		this.addChild(dot_next);

		dot_back = new Image(sAssets.getTexture("dot_back"));
		dot_back.pivotX = dot_back.width/2; dot_back.pivotY = dot_back.height/2;
		this.addChild(dot_back);


		title_container.x = galleryContainer.x + picWidth;
		title_container.y = galleryContainer.y - 65;
		titleObject[0].visible = true;
		trace(titleObject.length);

		setButtonEvent();

		settingComplete = true;
	}
	public function init():void
	{
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
		recIntervalID = setTimeout(saveData, 5000, filesList[picNum].name);

	}
	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(stage);
		var distance:int;
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			touchPosition = touch.getLocation(this);

			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				trace("on finger down");
				startTouchTime = getTimer();
				picDownPosition = touchPosition;
				prvTouched = touchPosition.x;
				currentTouched = touchPosition.x;
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger move
				trace("on finger move");
				prvTouched = currentTouched;
				currentTouched = touchPosition.x;
				distance = int(currentTouched - prvTouched)
				picContainer.x += (int(distance));
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				trace("on finger up");
				endTouchTime = getTimer();
				elapsedTime = endTouchTime - startTouchTime;
				picUpPosition = touchPosition;
				trace("elapsedTime = "+elapsedTime);
				if(elapsedTime < 400){
					checkDirection("touch");
				}
				else{
					if(Math.abs(picUpPosition.x - picDownPosition.x) > picWidth/2){
						checkDirection("touch");
					}
					else{
						unsetButtonEvent();
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
			if(picUpPosition.x > picDownPosition.x){
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
			else if(picUpPosition.x < picDownPosition.x){
				touchDirection = "next";
				picNum++;
				if(picNum > totalImages-1){
					picNum = totalImages-1
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
			touchDirection = actionType;
			picNum++;
			if(picNum > totalImages-1){
				picNum = totalImages-1
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
		clearInterval(recIntervalID);
		recIntervalID = setTimeout(saveData, 3000, filesList[picNum].name);
		
	}
	public function setButtonEvent():void
	{
		galleryContainer.touchable = true;
		back_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
		next_img.addEventListener(TouchEvent.TOUCH, onButtonTouch);
	}
	public function unsetButtonEvent():void
	{
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

		trace("dotNum before = "+dotNum, dotRemain, currentDotSet, dotSet);
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
				/*else if(currentDotSet > dotSet && dotRemain > 0){
					currentDotSet = currentDotSet-1;
					dotNum = dotNum-1;
				}*/
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
		trace("dotNum after = "+dotNum);

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
		if(totalImages == 1){
			dot_container.visible = false;
		}
		else{
			dot_container.visible = true;
		}
		trace(dotSet, currentDotSet);
		if(dotSet == 0){
			dot_next.visible = false; dot_back.visible = false;
		}
		else if(dotSet == 1 && totalImages == 5){
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
		clearInterval(recIntervalID);
		/*while(currentTexture.length > 0){
			sAssets.removeTexture(currentTexture[0], true);
			currentTexture.splice(0, 1);
		}
		picContainer.dispose();
		galleryContainer.dispose();
		addEventListener(starling.events.Event.ENTER_FRAME, removeMe);*/
	}
	public function removeMe(e:starling.events.Event):void {
		if (currentTexture.length == 0) {
			settingComplete = false;
			removeEventListener(starling.events.Event.ENTER_FRAME, removeMe);
			this.parent.removeChild(this);
			trace("Remove !!!!");
		}
	}

}
}