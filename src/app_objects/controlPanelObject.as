package app_objects
{

import flash.utils.setTimeout;

import starling.display.Image;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchPhase;
import starling.events.TouchEvent;
import starling.display.Sprite;
import starling.events.Event;
import starling.core.Starling;
import starling.utils.AssetManager;
import starling.display.Canvas;
import starling.animation.Transitions;
import starling.animation.Tween;

import app_events.RotationEvent;

// import flash.utils.getTimer;
import flash.filesystem.File;
	
import com.greensock.*;
import com.greensock.easing.*;
import flash.geom.Point;


public class controlPanelObject extends Sprite
{

	private var sAssets:AssetManager;
	private var videoPath:String;
	
	public var panel_canvas:Canvas;
	public var panel_BG:Sprite;
	
	public var panel_area:Image;
	public var sound_on:Image;
	public var sound_off:Image;
	public var sound_text:Image;
	public var exit_app:Image;
	public var set_home:Image;
	

	public function controlPanelObject()
	{
		//super();
		//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	private function onAddedToStage(event:starling.events.Event):void
	{
		//this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
	}
	public function createObject(assets:AssetManager):void
	{
		sAssets = assets;
		
		panel_BG = new Sprite();
		this.addChild(panel_BG);
		panel_canvas = new Canvas();
		panel_canvas.drawRectangle(0, 0, 1920, 1080);
		panel_BG.addChild(panel_canvas);
		panel_BG.alpha = 0;
		
        panel_area = new Image(sAssets.getTexture("panelBG"));
        panel_area.pivotX = panel_area.width;
        panel_area.pivotY = panel_area.height;
        this.addChild(panel_area);
		
		sound_on = new Image(sAssets.getTexture("sound_on"));
		sound_on.name = "sound_on";
        sound_on.pivotX = sound_on.width/2;
        sound_on.pivotY = sound_on.height/2;
        this.addChild(sound_on);
		
		sound_off = new Image(sAssets.getTexture("sound_off"));
		sound_off.name = "sound_off";
        sound_off.pivotX = sound_off.width/2;
        sound_off.pivotY = sound_off.height/2;
        this.addChild(sound_off);
		
		sound_text = new Image(sAssets.getTexture("sound_text"));
		sound_text.pivotY = sound_text.height/2;
        this.addChild(sound_text);
		
		exit_app = new Image(sAssets.getTexture("exit_button"));
		exit_app.name = "exit_app";
        exit_app.pivotX = exit_app.width/2;
        exit_app.pivotY = exit_app.height/2;
        this.addChild(exit_app);
		
		set_home = new Image(sAssets.getTexture("sethome_button"));
		set_home.name = "set_home";
        set_home.pivotX = set_home.width/2;
        set_home.pivotY = set_home.height/2;
        this.addChild(set_home);
		
		sound_on.visible = true;
		sound_off.visible = false;
		
		panel_area.x = 1920;
		panel_area.y = 1080;
		sound_on.x = 1920 - sound_on.width + 30;
		sound_on.y = 1080 - 240;
		sound_off.x = 1920 - sound_off.width + 30;
		sound_off.y = 1080 - 240;
		exit_app.x = 1920 - panel_area.width/2;
		exit_app.y = 1080 - 50;
		sound_text.x = 1920 - 350; 
		sound_text.y = 1080 - 240;
		set_home.x = 1920 - panel_area.width/2;
		set_home.y = 1080 - 150;
		
		panel_BG.addEventListener(TouchEvent.TOUCH, onTouch);
		sound_on.addEventListener(TouchEvent.TOUCH, onTouch);
		sound_off.addEventListener(TouchEvent.TOUCH, onTouch);
		exit_app.addEventListener(TouchEvent.TOUCH, onTouch);
		set_home.addEventListener(TouchEvent.TOUCH, onTouch);
			
	}
	 private function onTouch(event:TouchEvent):void
    {
        var touch:Touch = event.getTouch(event.currentTarget as DisplayObject);
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
				var current_touchPosition:Point = touch.getLocation(this);
                if(stage.hitTest(current_touchPosition) == touch.target){
					if(touchedButton == exit_app){
						Root.exitApp();
					}
					else if(touchedButton == sound_off){
						sound_on.visible = true;
						sound_off.visible = false;
						Root.muteSound();
					}
					else if(touchedButton == sound_on){
						sound_on.visible = false;
						sound_off.visible = true;
						Root.muteSound();
					}
					else if(touchedButton == panel_BG){
						this.visible = false;
					}
					else if(touchedButton == set_home){
						this.dispatchEvent(new RotationEvent(RotationEvent.ROTATION_STATE, {id: "set_home"}, true));
					}
                }
			}
        }
    }
	
	
}
}