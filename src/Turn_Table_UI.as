package {

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import starling.core.Starling;
import starling.events.Event;
import starling.utils.AssetManager;
import starling.utils.RectangleUtil;
import starling.utils.ScaleMode;


import utils.ProgressBar;

//    import flash.utils.clearTimeout;
//    import flash.utils.getDefinitionByName;
//    import flash.utils.getTimer;
//	import starling.display.DisplayObject;
[SWF(frameRate="60", width="1920", height="1080", backgroundColor="0xffffff")]   // Horizontal******

public class Turn_Table_UI extends Sprite {

//        private var stats:Stats;
    private var mStarling:Starling;
    private var contentRatio:Number;
    private var mProgressBar:ProgressBar;
    private var mBackground: Loader;
    private var StageWidth:Number;
    private var StageHeight:Number;
    private var assets:AssetManager;


    public function Turn_Table_UI() {
        if (stage)
            start();
        else
            addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);

    }
    private function onAddedToStage(event:flash.events.Event):void {
        removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);

        start();

    }
    private function setDisplay(dimension:String, displayWidth:Number, displayHeight:Number):void {
        StageWidth = displayWidth;
        StageHeight = displayHeight;
        var displayType:String = dimension;

        if(displayType == "vertical"){
            contentRatio = StageWidth/StageHeight;
        }
        else{
            contentRatio = StageHeight/StageWidth;
        }
        trace("contentRatio = "+contentRatio);
    }
    private function start():void {
        //stage.quality = StageQuality.HIGH;

        stage.scaleMode = StageScaleMode.SHOW_ALL;
        stage.align = StageAlign.TOP_LEFT;

        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        stage.addEventListener(flash.events.Event.ENTER_FRAME,setFullScreen);

        setDisplay("horizontal", 1920, 1080);

        var stageSize:Rectangle = new Rectangle(0, 0, StageWidth, StageHeight);
        var screenSize:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
        var viewPortRectangle:Rectangle = RectangleUtil.fit(stageSize, screenSize, ScaleMode.SHOW_ALL, true);


        Starling.multitouchEnabled = true; // for Multitouch Scene
        //Starling.handleLostContext = true; // recommended everywhere when using AssetManager
        //RenderTexture.optimizePersistentBuffers = true; // should be safe on Desktop

        mStarling = new Starling(Root, stage, viewPortRectangle);
        mStarling.antiAliasing = 1;
        mStarling.stage.stageWidth = StageWidth; // <- same size on all devices!
        mStarling.stage.stageHeight = StageHeight; // <- same size on all devices!
        mStarling.simulateMultitouch = true;
        mStarling.enableErrorChecking = Capabilities.isDebugger;


        mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function (event:starling.events.Event):void
        {
            loadAssets(startGame);
        });
        mStarling.start();
        initElements();

        /*stats = new Stats();
         stats.scaleX = stats.scaleY = 1.5;
         this.addChild(stats);*/

        stage.addEventListener(flash.events.Event.RESIZE, onResize);
    }
    private function loadAssets(onComplete:Function):void {
        // Our assets are loaded and managed by the 'AssetManager'. To use that class,
        // we first have to enqueue pointers to all assets we want it to load.

        /*var assets:AssetManager = new AssetManager();
         assets.verbose = Capabilities.isDebugger;
         assets.enqueue(EmbeddedAssets);*/

        var appDir:File = File.applicationDirectory;
        assets = new AssetManager();

        assets.verbose = Capabilities.isDebugger;
        assets.enqueue(
                /*appDir.resolvePath("app_assets/sounds"),*/
                appDir.resolvePath("Resources/product_configuration/home/logo"),
                appDir.resolvePath("Resources/systems")
        );

        // Now, while the AssetManager now contains pointers to all the assets, it actually
        // has not loaded them yet. This happens in the "loadQueue" method; and since this
        // will take a while, we'll update the progress bar accordingly.

        assets.loadQueue(function(ratio:Number):void
        {
            mProgressBar.ratio = ratio;

            if (ratio == 1)
            {
                // now would be a good time for a clean-up
                System.pauseForGCIfCollectionImminent(0);
                System.gc();

                onComplete(assets);
                setTimeout(resizeStage, 100);
            }
        });
    }

    private function startGame(assets:AssetManager):void {
        var appRoot:Root = mStarling.root as Root;
        appRoot.start(assets);
        setTimeout(removeElements, 150); // delay to make 100% sure there's no flickering.

    }
    private function initElements():void{
        // init Element
        trace("init Loading");

        // Add background image. By using "loadBytes", we can avoid any flickering.
        /* var bgPath: String = "Resources/systems/textures/bg.png";
         var bgFile: File = File.applicationDirectory.resolvePath(bgPath);
         var bytes: ByteArray = new ByteArray();
         var stream: FileStream = new FileStream();
         stream.open(bgFile, FileMode.READ);
         stream.readBytes(bytes, 0, stream.bytesAvailable);
         stream.close();

         mBackground = new Loader();
         mBackground.loadBytes(bytes);
         mStarling.nativeOverlay.addChild(mBackground);

         mBackground.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,
         function (e: Object): void {
         (mBackground.content as Bitmap)
         .smoothing = true;
         mBackground.x = (StageWidth - mBackground.width)/2;
         mBackground.y = (StageHeight - mBackground.height)/2;
         });*/

        // While the assets are loaded, we will display a progress bar.
        mProgressBar = new ProgressBar(300, 25);
        mProgressBar.x = (StageWidth - mProgressBar.width) / 2;
        mProgressBar.y =  StageHeight * 0.5;
        mProgressBar.visible = false;
        mStarling.nativeOverlay.addChild(mProgressBar);

        setTimeout(function():void{ mProgressBar.visible = true;}, 50); //delay to display progress bar
    }
    private function removeElements():void{

        // remove Element
        /* if (mBackground) {
         mStarling.nativeOverlay.removeChild(mBackground);
         mBackground = null;
         }*/

        trace("remove Loading");
        if (mProgressBar)
        {
            mStarling.nativeOverlay.removeChild(mProgressBar);
            mProgressBar = null;
        }
    }
    public function setFullScreen(e:flash.events.Event):void {
        if (stage.displayState == StageDisplayState.NORMAL) {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            resizeStage();
        }
    }
    private function onResize(event:flash.events.Event):void{
        resizeStage();
    }
    private function resizeStage():void{
        RectangleUtil.fit(
                new Rectangle(0, 0, StageWidth, StageHeight),
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight),
                ScaleMode.SHOW_ALL, false,
                Starling.current.viewPort
        );
    }
}
}
