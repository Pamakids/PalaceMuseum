/**
 * 故宫项目
 * 模块
 * starling
 *
 * */

package views.components.base
{
	import com.greensock.TweenLite;
	import com.pamakids.manager.SoundManager;
	import com.pamakids.palace.utils.StringUtils;

	import flash.display.MovieClip;
	import flash.geom.Point;

	import assets.loadings.LoadingAssets;

	import controllers.MC;

	import models.FontVo;

	import sound.SoundAssets;

	import starling.display.Image;
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
			SoundManager.instance.play("main");
			MC.isTopBarShow=false;
			TopBar.hide();
			TailBar.hide();
			LionMC.instance.clear();
		}

		private var load:MovieClip;
		protected var _isLoading:Boolean;

		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		public function set isLoading(value:Boolean):void
		{
			if (_isLoading == value)
				return;
			_isLoading=value;
			if (value)
			{
				if (!load)
					load=new LoadingMC();
				MC.instance.addMC(load);
				load.x=1024 - 130;
				load.y=768 - 126;
				load.play();
			}
			else
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
		}


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

			qa=LoadingAssets[moduleName + "Loading"];
			if (qa)
			{
				var img:Image=Image.fromBitmap(new qa());
				tfHolder.addChild(img);
				if (qaPOS)
				{
					img.x=qaPOS.x;
					img.y=qaPOS.y;
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
			isLoading=true;
			addEventListener("gotoNext", nextScene);
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
		protected var sceneIndex:int;

		protected function nextScene(e:Event):void
		{
			sceneIndex++;
			loadScene(sceneIndex);
		}

		protected function loadScene(index:int):void
		{
			isLoading=false;
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
//				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeEventListener("gotoNext", nextScene);
				MC.instance.nextModule();
			}
		}

		override public function dispose():void
		{
			SoundAssets.removeModuleSnd(moduleName);
			if (crtScene)
			{
				crtScene.removeFromParent(true);
				crtScene=null;
			}
			isLoading=false;
			if (assetManager)
				assetManager.purge();
			assetManager=null;
			super.dispose();
		}
	}
}

