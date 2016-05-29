package app_objects{

import com.greensock.TweenMax;
import com.greensock.easing.*;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.display.Image;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import app_events.RotationEvent;
import app_events.ControlEvent;



public class rotateControlObject extends Sprite {

	private var rotator_circle:Image;
	
	private var left_button:Image;
	private var right_button:Image;

	private  var sAssets:AssetManager;

	private  var _tween1:Tween;
	private  var _tween2:Tween;

	private var container:Sprite;

	private  var touchPosition:Point;
	
	public function rotateControlObject(assets:AssetManager) {

		sAssets = assets;
		draw();

	}
	private function draw():void {

		//container = new Sprite();
		//this.addChild(container);

		rotator_circle = new Image(sAssets.getTexture("rotator_circle"));
		rotator_circle.pivotX = rotator_circle.width/2;
		rotator_circle.pivotY = rotator_circle.height/2;
		this.addChild(rotator_circle);

		left_button = new Image(sAssets.getTexture("left_button"));
		left_button.pivotX = left_button.width/2;
		left_button.pivotY = left_button.height/2;
		this.addChild(left_button);
		
		right_button = new Image(sAssets.getTexture("right_button"));
		right_button.pivotX = right_button.width/2;
		right_button.pivotY = right_button.height/2;
		this.addChild(right_button);
		
		right_button.alpha = 0;
		left_button.alpha = 0;
		
		
		rotator_circle.addEventListener(TouchEvent.TOUCH, onTouch);
	}

	public function rotateLeft():void {
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "left"}, true));
	}
	public function rotateRight():void {
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "right"}, true));
	}
	public function stopRotate():void {
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "stop"}, true));
	}
	public function resetRotate():void {
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "reset"}, true));
	}
	
	public function setInit():void {
		right_button.alpha = 0;
		left_button.alpha = 0;
		right_button.x = 0;
		right_button.y = 0;
		left_button.x = 0;
		left_button.y = 0;
		right_button.removeEventListener(TouchEvent.TOUCH, onTouch);
		left_button.removeEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	public function showButton():void {
		TweenMax.to(right_button, 0.5, {alpha:1, x:160, ease:Back.easeOut});
		TweenMax.to(left_button, 0.5, {alpha:1, x:-160, ease:Back.easeOut});
		right_button.addEventListener(TouchEvent.TOUCH, onTouch);
		left_button.addEventListener(TouchEvent.TOUCH, onTouch);
	}
	public function hideButton():void {
		TweenMax.to(right_button, 0.5, {alpha:0, x:0, ease:Cubic.easeOut});
		TweenMax.to(left_button, 0.5, {alpha:0, x:0, ease:Cubic.easeOut});
		right_button.removeEventListener(TouchEvent.TOUCH, onTouch);
		left_button.removeEventListener(TouchEvent.TOUCH, onTouch);
	}
	
	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			touchPosition = touch.getLocation(this);

			var touchedButton:Object = event.currentTarget;
			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				if(touchedButton == left_button){
					rotateLeft();
				}
				else if(touchedButton == right_button){
					rotateRight();	
				}
				TweenMax.to(touchedButton, 0.1, {scaleX:0.95, scaleY:0.95, ease:Linear.easeNone});
			}
			if(touch.phase == TouchPhase.MOVED){ //on finger moved
				
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				if(touchedButton == left_button || touchedButton == right_button){
					stopRotate(); 
				}
				else if(touchedButton == rotator_circle){
					if(Root.controlState == "auto"){
						this.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_TYPE, {id: "manual"}, true));
					}
					else{
						resetRotate(); 
					}
				}
				TweenMax.to(touchedButton, 0.1, {scaleX:1, scaleY:1, ease:Linear.easeNone});
				var current_touchPosition:Point = touch.getLocation(this);
				if(stage.hitTest(current_touchPosition) == touch.target){
                    if(touchedButton == rotator_circle){
						resetRotate();
					}
                }
			}
		}
	}

}
}
