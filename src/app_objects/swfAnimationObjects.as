package {
	import starling.core.Starling;
	//import starling.display.*;
	import starling.events.*;
	import starling.utils.AssetManager;
	import starling.animation.DelayedCall;
	import starling.animation.Juggler;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	public class swfAnimationObjects  
	{
		
		//---------------------------------------------------- Start Game Here !!! -----------------
		public static function sayHi()
		{
			trace("Hello my friend :)");
		}
		public static function drawScaledMovieClip(mc:MovieClip, mcWidth:Number, mcHeight:Number):Vector.<Texture>
		{
			var _textures:Vector.<Texture> = new Vector.<Texture>();
		 
			// Loop through passed in movieclip frames and build the bitmaps.
			for (var i:int = 1; i <= mc.totalFrames; i++)
			{
				mc.gotoAndStop(i);
				_textures.push(Texture.fromBitmap(swfAnimationObjects.drawBitmapScaled(mc, mcWidth, mcHeight, false), false));
			}
		 
			return(_textures);
		}
		public static function drawBitmapScaled(mc:MovieClip, mcWidth:Number, mcHeight:Number, hasPadding:Boolean = false):Bitmap
		{
			// Store the original width and height of the passed in clip.
			var tempW:Number = mc.width;
			var tempH:Number = mc.height;
		 
			// Set the mc clip to the passed in width and height.
			mc.width = mcWidth;
			mc.height = mcHeight;
		 
			// Store the X and Y scales of the mc clip that has been altereted with the passed in width and height.
			var scaleX:Number = mc.scaleX;
			var scaleY:Number = mc.scaleY;
		 
			// Reset passed in mc to it's original width and height stored at the start of the function.
			mc.width = tempW;
			mc.height = tempH;
		 
			// Setup bitmap data.
			var scaleBmpd:BitmapData;
		 
			if (!hasPadding)
			{
				scaleBmpd = new BitmapData(Math.round(mc.width * scaleX), Math.round(mc.height * scaleY), true, 0x00000000);
			}
			else
			{
				scaleBmpd = new BitmapData(Math.round(mc.width * scaleX) + 10, Math.round(mc.height * scaleY) + 10, true, 0x00000000);
			}
		 
			// Setup bitmap and associated matrix.
			var scaledBitmap:Bitmap = new Bitmap(scaleBmpd, PixelSnapping.ALWAYS, true);
			var scaleMatrix:Matrix = new Matrix();
		 
			scaleMatrix.scale(scaleX, scaleY);
		 
			if (hasPadding)
			{
				scaleMatrix.translate(1, 1);
			}
		 
			scaleBmpd.draw(mc, scaleMatrix);
		 
			return scaledBitmap;
		}
	}
}
		