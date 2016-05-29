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

	
	public class rotateButtonObject extends Sprite
	{
		private var sAssets:AssetManager;
		public var button_normal:Image;
		public var button_activated:Image;
		public var button_type:String;

		public var isActivated:Boolean;
		
		private var button_area:Canvas;
				
		public function rotateButtonObject()
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

			button_normal = new Image(sAssets.getTexture("rotate_icon"));
			button_normal.pivotX = button_normal.width/2;
			button_normal.pivotY = button_normal.height/2;
			this.addChild(button_normal);

			button_activated = new Image(sAssets.getTexture("rotate_icon_activated"));
			button_activated.pivotX = button_activated.width/2;
			button_activated.pivotY = button_activated.height/2;
			this.addChild(button_activated);

			/*button_area = new Canvas();
			button_area.drawCircle(0, 0, 120);
			button_area.alpha = 0;
			this.addChild(button_area);*/

			setDeactivated();
		}
		public function onTouchDown():void
		{
			TweenMax.to(this, 0.1, {scaleX:0.95, scaleY:0.95, ease:Quint.easeOut});
		}
		public function onTouchUp():void
		{
			TweenMax.to(this, 0.1, {scaleX:1, scaleY:1, ease:Quint.easeOut});
		}
		public function setActivated():void
		{
			if(isActivated == false){
				button_activated.visible = true;
				button_normal.visible = false;
				isActivated = true;
			}
		}
		public function setDeactivated():void
		{
			if(isActivated == true){
				button_activated.visible = false;
				button_normal.visible = true;
				isActivated = false;
			}
		}
	}
}