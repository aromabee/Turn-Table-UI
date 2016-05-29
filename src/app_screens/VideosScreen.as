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

import app_objects.VideosGalleryObject;
import app_objects.vdoBGObject;


import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.Canvas;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;

import com.greensock.*;
import com.greensock.easing.*;

public class VideosScreen extends Sprite{

    public var gallery:VideosGalleryObject;
    public var vdo_bg:vdoBGObject;


    private var touch:Touch;
    private var screenName:String;
    private var screenStatus:String;
    private var gameStatus:String;
	
    private var sAssets:AssetManager;
    public var exit_button:Image;

    //Normal variable
    private var intervalID:uint;
    private var intervalID2:uint;
    private var i:Number;
    private var l:Number;
    private var touchDistance:Number;
    private var disposeStatus:Boolean;
    private var current_touchPosition:Point;
    public var drawScreenComplete:Boolean = false;


    public function VideosScreen() {

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
        vdo_bg.createObject("Resources/product_configuration/videos/video_background/");
        this.addChild(vdo_bg);

        gallery = new VideosGalleryObject();
        gallery.createGallery(sAssets);
        this.addChild(gallery);
        gallery.y = 300;


        exit_button = new Image(sAssets.getTexture("button_exit"));
        exit_button.pivotX = exit_button.width/2; exit_button.pivotY = exit_button.height/2;
        this.addChild(exit_button);

        exit_button.addEventListener(TouchEvent.TOUCH, onTouch);


    }
    public function chkDrawScreenComplete(e:Event):void{
        if(gallery.settingComplete == true && vdo_bg){
            trace("Draw "+screenName+" Screen Complete");
            removeEventListener(Event.ENTER_FRAME, chkDrawScreenComplete);
            drawScreenComplete = true;
        }
    }
    public function startScreen():void{

        gameStatus = "start";
        disposeStatus = false;
        initScreen();
        exit_button.x = gallery.galleryPosX;
        exit_button.y = 200;
        exit_button.scale = 0;
        this.visible = true;

    }
    public function initScreen():void{
        gallery.init();
        vdo_bg.playVDO();
        vdo_bg.scaleY = 1.01;
        gallery.alpha = 0;
        gallery.y = 300;

        playAnimationIn();
//			intervalID = setTimeout(playAnimationIn, 50);
    }
    private function playAnimationIn():void{
        TweenMax.to(gallery, 0.5, {y:200, alpha:1, ease:Cubic.easeOut, delay:0.5});
        TweenMax.to(exit_button, 0.4, {scaleX:1, scaleY:1, ease:Back.easeOut, delay:1, onComplete:onAnimationComplete});

        setTouchEvent();
    }
    private function onAnimationComplete():void{
        //
    }
    private function playAnimationOut():void{

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
                TweenMax.to(touchedButton, 0.1, {scaleX:0.95, scaleY:0.95, ease:Quint.easeOut});
            }
            if(touch.phase == TouchPhase.MOVED){ //on finger moved

            }
            if(touch.phase == TouchPhase.ENDED){ //on finger up
                TweenMax.to(touchedButton, 0.1, {scaleX:1, scaleY:1, ease:Quint.easeOut});
//              playSound("button_snd");
                trace("touch up");
                current_touchPosition = touch.getLocation(this);
                if(stage.hitTest(current_touchPosition) == touch.target){
                    intervalID = setTimeout(function():void{
                        clearTimeout(intervalID);
                        gotoScreen("main_screen");
                    }, 100);
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
            if(vdo_bg.isPlaying == true){
                vdo_bg.stopVDO();
            }
            gallery.disposeObject();
            removeTouchEvent();
            trace("Dispose "+screenName+" Screen.....");
        }
    }
}
}
