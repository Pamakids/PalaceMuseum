/**
 * 故宫项目
 * 模块
 * starling
 *
 * */

package views.components.base
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.palace.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.filesystem.File;
	import flash.geom.Point;

	import assets.embed.EmbedAssets;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.global.TailBar;
	import views.global.TopBar;

	public class PalaceModule extends Container
	{
		public function get moduleName():String
		{
			return StringUtils.getClassName(this);
		}

		protected var assetManager:AssetManager;
		public var crtScene:PalaceScene;
		protected var tfHolder:Sprite;
		protected var skipIndex:int=-1;

		[Embed(source="/assets/common/loading.png")]
		public static var loading:Class

		[Embed(source="/assets/common/gamebg.jpg")]
		public static var gameBG:Class

		public function PalaceModule(am:AssetManager=null, width:Number=0, height:Number=0)
		{
			assetManager=am;
			super(width, height);
		}

		override protected function init():void
		{
			SoundAssets.playBGM("main");
			TopBar.hide();
			TailBar.hide();
			LionMC.instance.clear();

			addEventListener("showNext",showNext);
			addEventListener("hideNext",hideNext);
		}

		private function showNext():void
		{
			if(nextButton&&!nextButton.visible)
				nextButton.visible=true;
		}

		private function hideNext():void
		{
			if(nextButton&&nextButton.visible)
				nextButton.visible=false;
		}

		private static var load:flash.display.MovieClip;

		protected var Q1:String="";
		protected var A1:String="";
		protected var Q2:String="";
		protected var A2:String="";
		protected var qa:Class;
		protected var qaPOS:Point;

		protected function addQAS():void
		{
			var isSingle:Boolean=(Q2 == "");
			tfHolder=new Sprite();
			addChild(tfHolder);
			tfHolder.touchable=false;
			var bg:Image=Image.fromBitmap(new gameBG());
			tfHolder.addChild(bg);

			qa=EmbedAssets[moduleName + "Loading"];
			if (qa)
			{
				var img:Image=Image.fromBitmap(new qa());
				tfHolder.addChild(img);
				if (qaPOS)
				{
					img.x=qaPOS.x;
					img.y=qaPOS.y;
				}
				else
				{
					img.x=100;
					img.y=100;
				}
				return;
			}

			var tfQ1:TextField=new TextField(600, 100, Q1, FontVo.PALACE_FONT, 32, 0xffffff, true);
			tfQ1.x=200;
			tfQ1.y=isSingle ? 200 : 100;
			tfQ1.hAlign="left";
			tfQ1.vAlign="top";
			tfHolder.addChild(tfQ1);
			var tfA1:TextField=new TextField(600, 200, A1, FontVo.PALACE_FONT, 28, 0xffffff, true);
			tfA1.x=220;
			tfA1.y=isSingle ? 350 : 180;
			tfA1.hAlign="left";
			tfA1.vAlign="top";
			tfHolder.addChild(tfA1);
			var tfQ2:TextField=new TextField(600, 100, Q2, FontVo.PALACE_FONT, 32, 0xffffff, true);
			tfQ2.x=200;
			tfQ2.y=400;
			tfQ2.hAlign="left";
			tfQ2.vAlign="top";
			tfHolder.addChild(tfQ2);
			var tfA2:TextField=new TextField(600, 200, A2, FontVo.PALACE_FONT, 28, 0xffffff, true);
			tfA2.x=220;
			tfA2.y=480;
			tfA2.hAlign="left";
			tfA2.vAlign="top";
			tfHolder.addChild(tfA2);
		}

		protected function addNext():void
		{
			TopBar.enable=true;
			MC.instance.main.removeMask();
			removeLoading();
			if (skipIndex < 0)
			{
				var next:ElasticButton=new ElasticButton(getImage("nextButton"));
				addChild(next);
				next.pivotX=next.width >> 1;
				next.pivotY=33;
				next.x=1024 - 100;
				next.y=768 - 100;
				next.addEventListener(ElasticButton.CLICK, initScene);
			}
			else
			{
				sceneIndex=skipIndex;
				loadScene(sceneIndex);
			}
		}

		protected function initScene(e:Event):void
		{
			tfHolder.removeFromParent(true);
			var next:ElasticButton=e.currentTarget as ElasticButton;
			next.removeFromParent(true);
			sceneIndex=skipIndex < 0 ? 0 : skipIndex;
			loadScene(sceneIndex);
		}

		protected function addLoading():void
		{
			if (!load)
				load=new LoadingMC();
			MC.instance.addMC(load);
			load.x=1024 - 172;
			load.y=768 - 126;
			load.play();
			addEventListener("sceneover",onSceneOver);
//			addEventListener("gotoNext", nextScene);
		}

		protected function removeLoading():void
		{
			if (load)
			{
				TweenLite.to(load, .5, {x: 1100, onComplete: function():void {
					MC.instance.removeMC(load);
					load.stop();
					load=null;
				}});
			}
		}

		protected function getImage(name:String):Image
		{
			var t:Texture;
			if (MC.assetManager)
				t=MC.assetManager.getTexture(name);
			if (!t && assetManager)
				t=assetManager.getTexture(name)
			if (t)
				return new Image(t);
			else
				return null;
		}

//		protected function onEnterFrame(e:Event):void
//		{
//			if (isLoading)
//				load.rotation+=.2;
//		}

		protected var sceneArr:Array=[];
		protected var birdArr:Array=[];
		protected var sceneIndex:int;

		protected var capture:Image;

		/**
		 * 截屏
		 * dispose scene
		 * 加载下一场景
		 * */
		protected function nextScene(e:Event):void
		{
			UserBehaviorAnalysis.trackEvent("click", "next");
			TopBar.enable=false;

			if(crtScene)
			{
				if(capture)
				{
					capture.removeFromParent(true);
					capture=null;
				}
				capture=new Image(crtScene.getCapture());
				addChild(capture);
				crtScene.removeFromParent(true);
				crtScene=null;
			}

			if (nextButton){
				nextButton.touchable=false;
				this.setChildIndex(nextButton,numChildren-1);
			}
			TweenLite.killTweensOf(shakeNext);

			addMask(0);
			sceneIndex++;
			loadAssets(sceneIndex, function():void {
				removeMask();
				loadScene(sceneIndex);
			});
		}

		protected function loadScene(index:int):void
		{
			if(nextButton){
				TweenLite.killDelayedCallsTo(this);
				TweenMax.killTweensOf(nextButton);
				nextButton.removeFromParent(true);
				nextButton=null;
			}
			if(capture){
				capture.removeFromParent(true);
				capture=null;
			}
			if (crtScene)
			{
				crtScene.removeFromParent(true);
				crtScene=null;
			}
			if (index <= sceneArr.length - 1)
			{
				var scene:Class=sceneArr[index] as Class;
				crtScene=new scene(assetManager);
				addChild(crtScene);
			}
			else
			{
//				removeEventListener("gotoNext", nextScene);
				removeEventListener("sceneover",onSceneOver);
				MC.instance.nextModule();
			}
		}

		protected function shakeNext():void
		{
			if (nextButton)
				TweenMax.to(nextButton, 1, {shake: {rotation: Math.PI / 12, numShakes: 4}, onComplete: function():void
				{
					TweenLite.delayedCall(5, shakeNext);
				}});
		}

		public function addNextLoading():void
		{
			if (nextButton)
			{
				var loading:starling.display.MovieClip=new starling.display.MovieClip(MC.assetManager.getTextures("loadingHalo"), 15);
				Starling.juggler.add(loading);
				loading.loop=true;
				loading.play();
				nextButton.addChild(loading);
				loading.x=8;
				loading.y=32;
				loading.scaleY=.98
			}
		}

		/**
		 * 场景结束
		 * 添加下一页按钮
		 * */
		private function onSceneOver(e:Event):void
		{
			trace("addNext")
			if (nextButton)
			{
				nextButton.removeFromParent(true);
				nextButton=null;
			}
			nextButton=new ElasticButton(getImage("nextButton"));
			nextButton.pivotX=nextButton.width >> 1;
			nextButton.pivotY=33;
			nextButton.x=1024 - 100;
			nextButton.y=768 - 100;
			nextButton.addEventListener(ElasticButton.CLICK, nextScene);
			shakeNext();
			addChildAt(nextButton,numChildren);
			TailBar.hide();
		}

		protected var nextButton:ElasticButton;

		override public function dispose():void
		{
			SoundAssets.removeModuleSnd(moduleName);
			if (crtScene)
			{
				crtScene.removeFromParent(true);
				crtScene=null;
			}
			if (nextButton)
			{
				TweenLite.killDelayedCallsTo(this);
				TweenMax.killTweensOf(nextButton);
				nextButton.removeFromParent(true);
				nextButton=null;
			}
			removeLoading();
			if (assetManager)
				assetManager.purge();
			assetManager=null;
			super.dispose();
		}

		protected function loadAssets(index:int, callback:Function):void
		{
			if (index < 0)
				index=0;
			if(assetManager)
				assetManager.purge()
			assetManager=null;
			assetManager=new AssetManager();
			var scene:Class=sceneArr[index] as Class;
			var sceneName:String=StringUtils.getClassName(scene);
			var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/" + sceneName);
			var birdIndex:int=birdArr[index];
			if(birdIndex<0||checkBird(birdIndex))
			{
				assetManager.enqueue(file);
			}else{
				assetManager.enqueue(file);
				assetManager.enqueue("assets/global/handbook/bird_collection_" + birdIndex + ".png",
									 "assets/global/handbook/mainUI/background_2.png");
			}
//			if (crtScene)
			addNextLoading();
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0 && callback != null)
					callback();
			});
		}

		protected function checkBird(birdIndex:int):Boolean
		{
			var b:Boolean=SOService.instance.getSO("birdCatched" + birdIndex);
			return b;
		}
	}
}

