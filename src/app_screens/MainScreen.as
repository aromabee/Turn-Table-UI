/**
 * Created by aromabee on 2016-05-12.
 */
package app_screens {

import flash.filesystem.File;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import app_events.SoundsEvent;
import app_events.NavigationEvent;
import app_events.RotationEvent;
import app_events.ControlEvent;

import app_objects.vdoBGObject;
import app_objects.knobObject;
import app_objects.rotateControlObject;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Canvas;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import com.greensock.*;
import com.greensock.easing.*;

public class MainScreen extends Sprite{

    public var vdo_bg:vdoBGObject;
    public var rotator:knobObject;
	public var rotationControl:rotateControlObject;
	

    public var loop_symbol:Image;
	public var loop_rotation_symbol:Image;
    public var manual_symbol:Image;
	public var loop_symbol_object:Sprite;
	
	public var manual_shortcut:Sprite;
	public var manual_shortcut_area:Canvas;
	

    private var touch:Touch;
    private var screenName:String;
    private var screenStatus:String;
    private var gameStatus:String;

    private var sAssets:AssetManager;


    //Normal variable
    private var intervalID:uint;
    private var intervalID2:uint;
    private var i:Number;
    private var l:Number;
    private var touchDistance:Number;
    private var disposeStatus:Boolean;
    private var current_touchPosition:Point;
    private var prev_touchPosition:Point;
    private var start_touchPosition:Point;
    public var drawScreenComplete:Boolean = false;


    public function MainScreen() {

    }
    public function initialize(assets:AssetManager):void
    {
        screenName = "Main";
        trace("Welcome to "+screenName+" Screen");

        sAssets = assets;

        this.visible = false;
        drawScreen();
    }
    private function drawScreen():void
    {
        trace("Drawing "+screenName+" Screen.......");
        addEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);

        vdo_bg = new vdoBGObject();
        vdo_bg.createObject("Resources/product_configuration/home/video_background/");
        this.addChild(vdo_bg);

        //rotator = new knobObject(sAssets);
        //this.addChild(rotator);
		
		rotationControl = new rotateControlObject(sAssets);
        this.addChild(rotationControl);

        manual_symbol = new Image(sAssets.getTexture("manual_symbol"));
        manual_symbol.pivotX = manual_symbol.width/2;
        manual_symbol.pivotY = manual_symbol.height/2;
        manual_symbol.touchable = false;
        this.addChild(manual_symbol);

		
		loop_symbol_object = new Sprite();
		this.addChild(loop_symbol_object);
		loop_symbol_object. visible = false;
		
        loop_symbol = new Image(sAssets.getTexture("loop_symbol"));
        loop_symbol.pivotX = loop_symbol.width/2;
        loop_symbol.pivotY = loop_symbol.height/2;
        loop_symbol_object.addChild(loop_symbol);
		
		loop_rotation_symbol = new Image(sAssets.getTexture("rotation_animate"));
        loop_rotation_symbol.pivotX = loop_rotation_symbol.width/2;
        loop_rotation_symbol.pivotY = loop_rotation_symbol.height/2;
        loop_symbol_object.addChild(loop_rotation_symbol);
		
		manual_shortcut = new Sprite();
		this.addChild(manual_shortcut);
		manual_shortcut_area = new Canvas();
		manual_shortcut_area.drawCircle(0, 0, 80);
		manual_shortcut.addChild(manual_shortcut_area);
		manual_shortcut.alpha = 0;
		
		manual_shortcut.addEventListener(TouchEvent.TOUCH, onTouch);

    }
    public function chkDrawScreenComplete(e:Event):void{
        if(vdo_bg){
            trace("Draw "+screenName+" Screen Complete");
            removeEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);
            drawScreenComplete = true;
        }
    }
    public function startScreen():void{

        gameStatus = "start";
        disposeStatus = false;
        initScreen();
        this.visible = true;
    }
    public function initScreen():void{


        vdo_bg.playVDO();

		
		rotationControl.x = stage.stageWidth/2;
        rotationControl.y = 800;
		rotationControl.setInit();
		rotationControl.alpha = 0;
		
		manual_shortcut.x = rotationControl.x;
		manual_shortcut.y = 785;
		
        manual_symbol.x = rotationControl.x;
        manual_symbol.y = 785;
        manual_symbol.visible = false;
		manual_shortcut.visible = true;
		loop_rotation_symbol.x = loop_symbol.x;
		loop_rotation_symbol.y = loop_symbol.y -15;
		loop_rotation_symbol.rotation = 0;
        loop_symbol_object.x = rotationControl.x;
        loop_symbol_object.y = 785;
        loop_symbol_object.alpha = 0;
        loop_symbol_object.visible = true;

        playAnimationIn();

//			intervalID = setTimeout(playAnimationIn, 50);
    }
    private function playAnimationIn():void{
		TweenMax.to(rotationControl, 0.6, {alpha:1, y:785, ease:Cubic.easeOut, delay:0.8});
        TweenMax.to(loop_symbol_object, 0.5, {alpha:1, ease:Cubic.easeOut, delay:1.3, onComplete:startLoop});

        setTouchEvent();
    }
    private function playAnimationOut():void{

    }

    public function startLoop():void{
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "auto"}, true));
		addEventListener(Event.ENTER_FRAME, loopRotate);
    }
	 public function stopLoop():void{
		this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "stop"}, true));
        removeEventListener(Event.ENTER_FRAME, loopRotate);
    }
	public function loopRotate(e:Event):void {
		loop_rotation_symbol.rotation += 0.02;
	}

    private function setTouchEvent():void{
        trace("set TouchEvent");
//            button_container.addEventListener(TouchEvent.TOUCH, onTouch);
    }
    private function removeTouchEvent():void{
        trace("remove TouchEvent");
//            button_container.removeEventListener(TouchEvent.TOUCH, onTouch);
    }
    private function onTouch(event:TouchEvent):void
    {
        touch = event.getTouch(event.currentTarget as DisplayObject);
        if (touch && touch.phase != TouchPhase.HOVER)
        {
            var touchedButton:Object = event.currentTarget;

            if(touch.phase == TouchPhase.BEGAN){ //on finger down
                trace("touch down");
            }
            if(touch.phase == TouchPhase.MOVED){ //on finger moved

            }
            if(touch.phase == TouchPhase.ENDED){ //on finger up
                trace("touch up");
                current_touchPosition = touch.getLocation(this);
                if(stage.hitTest(current_touchPosition) == touch.target){
                    this.dispatchEvent(new ControlEvent(ControlEvent.CONTROL_TYPE, {id: "manual"}, true));
                }
            }
        }
    }

    public function playSound(soundType:String):void{
        this.dispatchEvent(new SoundsEvent(SoundsEvent.PLAY_SOUND, {id: soundType}, true));
    }
    public function stopSound(soundType:String):void{
        this.dispatchEvent(new SoundsEvent(SoundsEvent.STOP_SOUND, {id: soundType}, true));
    }
    public function loopSound(soundType:String):void{
        this.dispatchEvent(new SoundsEvent(SoundsEvent.LOOP_SOUND, {id: soundType}, true));
    }
    public function gotoScreen(screenEvent:String):void{
        this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: screenEvent}, true));
    }

    public function disposeTemporarily():void
    {
        if(disposeStatus == false){
            this.visible = false;
            disposeStatus = true;
            clearTimeout(intervalID);
            clearTimeout(intervalID2);
            removeTouchEvent();
			stopLoop();
            if(vdo_bg.isPlaying == true){
                vdo_bg.stopVDO();
            }
            trace("Dispose "+screenName+" Screen.....");
        }
    }
}
}
