package app_objects
{
//	import starling.core.Starling;
import app_events.NavigationEvent;
import app_events.ControlEvent;
import app_events.RotationEvent;

import com.greensock.*;
import com.greensock.easing.*;

import flash.geom.Point;

import flash.utils.setTimeout;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Canvas;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

	
	public class rotationObject extends Sprite
	{
		private var sAssets:AssetManager;
		public var hand_button:handButtonObject;
		public var rotate_button:rotateButtonObject;
		public var rotate_product_text:Image;
		private var touch:Touch;
		private var current_touchPosition:Point;
				
		public function rotationObject()
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

			rotate_product_text = new Image(sAssets.getTexture("rotate_product_text"));
			rotate_product_text.pivotX = rotate_product_text.width/2;
			rotate_product_text.pivotY = rotate_product_text.height/2;
			this.addChild(rotate_product_text);
			
			hand_button = new handButtonObject();
			hand_button.createObject(sAssets, "hand_button");
			this.addChild(hand_button);

			rotate_button = new rotateButtonObject();
			rotate_button.createObject(sAssets, "rotate_button");
			this.addChild(rotate_button);

			rotate_product_text.y = -40;
			hand_button.x =  -50; hand_button.y = -110;
			rotate_button.x = 50; rotate_button.y = -110;



		}
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(event.currentTarget as DisplayObject);
			if (touch && touch.phase != TouchPhase.HOVER)
			{
				var touchedButton:Object = event.currentTarget;
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

					if(this.hitTest(current_touchPosition) == touch.target){
//						playSound("click3_snd");
						resetButton();
						var currentButton:String;
						currentButton = touchedButton.button_type;
						trace(currentButton);
						if(currentButton == "hand_button"){
							this.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_TYPE, {id: "manual"}, true));
						}
						else if(currentButton == "rotate_button"){
							this.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_TYPE, {id: "auto"}, true));
						}
						touchedButton.touchable = false;
						touchedButton.setActivated();

						/*setTimeout(function():void{
						 playSound("menu2_snd");
						 }, 300);*/
					}
				}
			}
		}
		public function setButtonEvent():void{
			hand_button.addEventListener(TouchEvent.TOUCH, onTouch);
			rotate_button.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function removeButtonEvent():void{
			hand_button.removeEventListener(TouchEvent.TOUCH, onTouch);
			rotate_button.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		public function resetButton():void{
			trace("reset");
			hand_button.setDeactivated();
			rotate_button.setDeactivated();
			hand_button.touchable = true;
			rotate_button.touchable = true;
		}
		public function setInit():void{
			hand_button.setDeactivated();
			rotate_button.setActivated();
			hand_button.touchable = true;
			rotate_button.touchable = false;
		}
	}
}