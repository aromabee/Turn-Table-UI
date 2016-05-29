package app_objects
{
//	import starling.core.Starling;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.utils.setTimeout;

	import starling.display.Canvas;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	
	public class videosButtonObject extends Sprite
	{
		private var sAssets:AssetManager;
		public var button_normal:Image;
		public var button_activated:Image;
		public var button_text_normal:Image;
		public var button_text_activated:Image;
		public var button_type:String;

		public var isActivated:Boolean;
		
		private var button_area:Canvas;
				
		public function videosButtonObject()
		{
			//super();
			//this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			//this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		public function createObject(assets:AssetManager, btnType:String):void
		{
			sAssets = assets;
			button_type = btnType;
			isActivated = true;

			button_normal = new Image(sAssets.getTexture("video_icon_normal"));
			button_normal.pivotX = button_normal.width/2;
			button_normal.pivotY = button_normal.height/2;
			this.addChild(button_normal);

			button_activated = new Image(sAssets.getTexture("video_icon_activated"));
			button_activated.pivotX = button_activated.width/2;
			button_activated.pivotY = button_activated.height/2;
			this.addChild(button_activated);

			button_text_normal = new Image(sAssets.getTexture("video_icon_text"));
			button_text_normal.pivotX = button_text_normal.width/2;
			button_text_normal.pivotY = button_text_normal.height/2;
			this.addChild(button_text_normal);

			button_text_activated = new Image(sAssets.getTexture("video_icon_text_activated"));
			button_text_activated.pivotX = button_text_activated.width/2;
			button_text_activated.pivotY = button_text_activated.height/2;
			this.addChild(button_text_activated);

			button_text_normal.y = button_normal.y+70;
			button_text_activated.y = button_normal.y+70;

			setDeactivated();
			
			/*button_area = new Canvas();
			button_area.drawCircle(0, 0, 120);
			button_area.alpha = 0;
			this.addChild(button_area);*/
		}
		public function onTouchDown():void
		{
			TweenMax.to(button_normal, 0.1, {scaleX:0.95, scaleY:0.95, ease:Quint.easeOut});
			TweenMax.to(button_activated, 0.1, {scaleX:0.95, scaleY:0.95, ease:Quint.easeOut});
		}
		public function onTouchUp():void
		{
			TweenMax.to(button_normal, 0.1, {scaleX:1, scaleY:1, ease:Quint.easeOut});
			TweenMax.to(button_activated, 0.1, {scaleX:1, scaleY:1, ease:Quint.easeOut});
		}
		public function setActivated():void
		{
			if(isActivated == false){
				button_activated.visible = true;
				button_text_activated.visible = true;
				button_normal.visible = false;
				button_text_normal.visible = false;
				isActivated = true;
			}
		}
		public function setDeactivated():void
		{
			if(isActivated == true){
				button_activated.visible = false;
				button_text_activated.visible = false;
				button_normal.visible = true;
				button_text_normal.visible = true;
				isActivated = false;
			}
		}
	}
}