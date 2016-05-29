package app_objects
{
//	import starling.core.Starling;
import app_events.NavigationEvent;

import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quint;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import app_events.SoundsEvent;

	import starling.animation.Transitions;

	import starling.animation.Tween;
	import starling.core.Starling;

import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	import starling.utils.deg2rad;
	
	public class mainMenuObject extends Sprite
	{
		public var sAssets:AssetManager;

		public var menu_navigator:Sprite;
		public var menu_navigator_circle:Image;
		public var menu_navigator_arrow:Image;
		public var menu_circle:Image;

		public var images_button:imagesButtonObject;
		public var videos_button:videosButtonObject;

		public var rotation_object:rotationObject;
		public var images_gallery_text:Image;
		public var videos_gallery_text:Image;

		public var tween:Tween;
		public var tween2:Tween;

		public var menu_status:String;

		private var intervalID:uint;

		public var myID:Number = 0;

		private var i:Number;
		private var l:Number;
		
		private var currentButton:String;
		
		private var touch:Touch;
		private var current_touchPosition:Point;
		private var prev_touchPosition:Point;
		private var start_touchPosition:Point;
		
		private var logo_touch_area:Canvas;
		public var touch_area:Sprite;
		

		public function mainMenuObject()
		{
			//super();
			//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function createObject(assets:AssetManager):void
		{
			sAssets = assets;

			menu_status = "rotation";
			menu_navigator = new Sprite();
			this.addChild(menu_navigator);

			menu_navigator_arrow = new Image(sAssets.getTexture("menu_navigate"));
			menu_navigator_arrow.pivotX = menu_navigator_arrow.width/2;
			menu_navigator.addChild(menu_navigator_arrow);

			menu_navigator_circle = new Image(sAssets.getTexture("menu_circle2"));
			menu_navigator_circle.pivotX = menu_navigator_circle.width/2;
			menu_navigator_circle.pivotY = menu_navigator_circle.height/2;
			menu_navigator.addChild(menu_navigator_circle);

			menu_navigator_arrow.y = menu_navigator_arrow.y - menu_navigator_circle.width/2 - 18;

			menu_circle = new Image(sAssets.getTexture("menu_circle1"));
			menu_circle.pivotX = menu_circle.width/2;
			menu_circle.pivotY = menu_circle.height/2;
			this.addChild(menu_circle);

			rotation_object = new rotationObject();
			rotation_object.createObject(sAssets);
			this.addChild(rotation_object);

			images_gallery_text = new Image(sAssets.getTexture("gallery_images_text"));
			images_gallery_text.pivotX = images_gallery_text.width/2;
			images_gallery_text.pivotY = images_gallery_text.height/2;
			this.addChild(images_gallery_text);

			videos_gallery_text = new Image(sAssets.getTexture("gallery_videos_text"));
			videos_gallery_text.pivotX = videos_gallery_text.width/2;
			videos_gallery_text.pivotY = videos_gallery_text.height/2;
			this.addChild(videos_gallery_text);
			
			images_button = new imagesButtonObject();
			images_button.createObject(sAssets, "images_button");
			this.addChild(images_button);

			videos_button = new videosButtonObject();
			videos_button.createObject(sAssets, "videos_button");
			this.addChild(videos_button);

			menu_circle.x = 960;  menu_circle.y = 1085;
			menu_navigator.x = 960;  menu_navigator.y = 1085;

			rotation_object.x = 960; rotation_object.y = 1080;
			images_gallery_text.x = 960; images_gallery_text.y = 1200; //1035
			videos_gallery_text.x = 960; videos_gallery_text.y = 1200; //1035


			images_button.x = menu_circle.x -270; images_button.y = 915;
			videos_button.x = menu_circle.x +270; videos_button.y = 915;

			images_button.addEventListener(TouchEvent.TOUCH, onTouch);
			videos_button.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(event.currentTarget as DisplayObject);
			if (touch && touch.phase != TouchPhase.HOVER)
			{

				var touchedButton:Object = event.currentTarget;
				trace(touchedButton);
				if(touch.phase == TouchPhase.BEGAN){ //on finger down
					trace("touch down");
					touchedButton.onTouchDown();
				}
				if(touch.phase == TouchPhase.MOVED){ //on finger moved

				}
				if(touch.phase == TouchPhase.ENDED){ //on finger up
					trace("touch up");
					touchedButton.onTouchUp();
					current_touchPosition = touch.getLocation(this);
					if(stage.hitTest(current_touchPosition) == touch.target){
//						playSound("click3_snd");
						resetButton();
						currentButton = touchedButton.button_type;
						if(currentButton == "images_button"){
							images_button.touchable = false;
							Starling.juggler.removeTweens(menu_navigator);
							tween = new Tween(menu_navigator, 1, Transitions.EASE_OUT_BACK);
							tween.rotateTo(deg2rad(-55));
							Starling.juggler.add(tween);

							tween2 = new Tween(images_gallery_text, 0.4, Transitions.EASE_OUT);
							tween2.delay = 0.4;
							tween2.moveTo(960, 1035);
							Starling.juggler.add(tween2);
							gotoScreen("images_screen");
						}
						else if(currentButton == "videos_button"){
							videos_button.touchable = false;
							Starling.juggler.removeTweens(menu_navigator);
							tween = new Tween(menu_navigator, 1, Transitions.EASE_OUT_BACK);
							tween.rotateTo(deg2rad(55));
							Starling.juggler.add(tween);

							tween2 = new Tween(videos_gallery_text, 0.4, Transitions.EASE_OUT);
							tween2.delay = 0.4;
							tween2.moveTo(960, 1035);
							Starling.juggler.add(tween2);
							gotoScreen("videos_screen");
						}

						touchedButton.setActivated();

						/*setTimeout(function():void{
							playSound("menu2_snd");
						}, 300);*/
					}
				}
			}
		}
		private function resetButton():void{
			images_button.touchable = true;
			videos_button.touchable = true;
			images_button.setDeactivated();
			videos_button.setDeactivated();
			var tween:Tween = new Tween(rotation_object, 0.4, Transitions.EASE_IN); tween.moveTo(960, 1300); Starling.juggler.add(tween);
			var tween1:Tween = new Tween(images_gallery_text, 0.4, Transitions.EASE_IN); tween1.moveTo(960, 1200); Starling.juggler.add(tween1);
			var tween2:Tween = new Tween(videos_gallery_text, 0.4, Transitions.EASE_IN); tween2.moveTo(960, 1200); Starling.juggler.add(tween2);
		}
		public function displayRotation():void{
			resetButton();
			Starling.juggler.removeTweens(menu_navigator);
			tween = new Tween(menu_navigator, 1, Transitions.EASE_OUT_BACK);
			tween.rotateTo(deg2rad(0));
			Starling.juggler.add(tween);

			tween2 = new Tween(rotation_object, 0.4, Transitions.EASE_OUT);
			tween2.delay = 0.4;
			tween2.moveTo(960, 1085);
			Starling.juggler.add(tween2);
		}

		private function setTouchEvent():void{
			clearTimeout(intervalID);
			trace("set TouchEvent");
			/*for(i=1, l=5; i<=l; ++i){
				this["button_"+i].addEventListener(TouchEvent.TOUCH, onTouch);
			}
			stageTouch.addEventListener(TouchEvent.TOUCH, onStageTouch);*/
			
		}
		private function removeTouchEvent():void{
			trace("remove TouchEvent");
			/*for(i=1, l=5; i<=l; ++i){
				this["button_"+i].removeEventListener(TouchEvent.TOUCH, onTouch);
			}
			stageTouch.removeEventListener(TouchEvent.TOUCH, onStageTouch);
			stageTouch.touchable = false;*/
		}

		public function playSound(soundType:String):void{
			this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {id: soundType}, true));
		}
		public function stopSound(soundType:String):void{
			this.dispatchEvent(new SoundsEvent(SoundsEvent.STOP_SOUND, {id: soundType}, true));
		}
		public function gotoScreen(screenEvent:String):void{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: screenEvent}, true));
		}

	}
}