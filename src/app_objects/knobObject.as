package app_objects{

import com.greensock.TweenMax;
import com.greensock.easing.Cubic;

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


public class knobObject extends Sprite {

	private var rotator_circle:Image;
	private var rotator_dragger:Image;

	private  var sAssets:AssetManager;

	private  var _tween1:Tween;
	private  var _tween2:Tween;

	private var container:Sprite;

	private  var touchPosition:Point;

	public var oldRotation:Number;
	public var ax:Number;
	public var ay:Number;
	public var bx:Number;
	public var by:Number;
	public var thetaA:Number;
	public var thetaB:Number;
	public var delTheta:Number;
	public var newTheta:Number;

	public var direction:String;
	public var setDirection:Boolean;
	

	public function knobObject(assets:AssetManager) {

		sAssets = assets;
		setDirection = false;
		draw();

	}

	private function onTouch(event:TouchEvent):void
	{
		var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
		if (touch && touch.phase != TouchPhase.HOVER)
		{
			touchPosition = touch.getLocation(this);

//			var touchedButton:Object = touch.target;
			if(touch.phase == TouchPhase.BEGAN){ //on finger down
				// trace("touch down");
				oldRotation = container.rotation;
				ax = touchPosition.x - container.x;
				ay = touchPosition.y - container.y;
				thetaA = Math.atan2(ay,ax);

				if (thetaA < 0)
				{
					thetaA =  -thetaA;
				}
				else
				{
					thetaA = Math.PI*2 - thetaA;
				}

			}
			if(touch.phase == TouchPhase.MOVED){ //on finger moved
				touchPosition = touch.getLocation(this);
				bx = touchPosition.x - container.x;
				by = touchPosition.y - container.y;
				thetaB = Math.atan2(by,bx);
				// trace(bx, by, thetaB);

				if (thetaB < 0)
				{
					thetaB =  -  thetaB;
				}
				else
				{
					thetaB = Math.PI*2 - thetaB;
				}

				delTheta = thetaB - thetaA;
				newTheta = oldRotation - delTheta;

				// trace("delTheta = "+delTheta, "newTheta = "+newTheta);

				var tween:Tween = new Tween(container, 0, Transitions.EASE_OUT);
//				tween.rotateTo(deg2rad(newTheta));
				tween.rotateTo(newTheta);
				Starling.juggler.add(tween);

				checkDirection();
			}
			if(touch.phase == TouchPhase.ENDED){ //on finger up
				// trace("touch up");
				setDirection = false;
				var current_touchPosition:Point;
				current_touchPosition = touch.getLocation(this);
				if(stage.hitTest(current_touchPosition) == touch.target){
//
				}
			}
		}
	}

	public function checkDirection():void
	{

		
		
	}
	private function draw():void {

		container = new Sprite();
		this.addChild(container);

		rotator_circle = new Image(sAssets.getTexture("rotator_circle"));
		rotator_circle.pivotX = rotator_circle.width/2;
		rotator_circle.pivotY = rotator_circle.height/2;
		container.addChild(rotator_circle);

		rotator_dragger = new Image(sAssets.getTexture("rotator_dragger"));
		rotator_dragger.pivotX = rotator_dragger.width/2;
		rotator_dragger.pivotY = rotator_dragger.height/2;
		container.addChild(rotator_dragger);

		rotator_dragger.y = rotator_circle.y + rotator_circle.height/2;

		container.addEventListener(TouchEvent.TOUCH, onTouch);
	}

	public function resetKnob():void {
		stopLoop();
		container.rotation = 0;
	}
	public function autoLoop():void {
		addEventListener(Event.ENTER_FRAME, loopRotate);

	}
	public function loopRotate():void {
		container.rotation += 0.01;
	}
	public function stopLoop():void {
		removeEventListener(Event.ENTER_FRAME, loopRotate);
	}

}
}
