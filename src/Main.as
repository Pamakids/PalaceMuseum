package
{
	import flash.filesystem.File;
	import flash.system.Capabilities;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import events.UserBehaviorEvent;

	import models.Const;
	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.Interlude;
	import views.components.PalaceGuide;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.books.BooksManager;
	import views.global.map.Map;

	public class Main extends Container
	{
		public function Main()
		{
//			SOService.instance.clear();
//			SOService.instance.init();
			SOService.instance.setSO("lastScene", "21");
			super(Const.WIDTH, Const.HEIGHT);
			scaleX=scaleY=scale;
			MC.instance.init(this);
			SoundAssets.init();
			//以免第一次初始化提示的时候卡顿
			var label:TextField=new TextField(1, 1, '0', FontVo.PALACE_FONT, 16, 0x561a1a, true);
			addChild(label);
			label.x=-10;
			label.y=-10;

			showStart();

			var am:AssetManager=new AssetManager();
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			am.enqueue(f);
			am.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0) {
					MC.assetManager=am;
					initialize();
				}
			});

			Map.loadAssets();

			if (!lastScene)
			{
				PalaceGuide.init();
			}
		}

		private function onRecordUserBehavior(e:UserBehaviorEvent):void
		{
			var data:Object=e.data;
			UserBehaviorAnalysis.trackEvent(data['catetory'], data['action'], data['label'], data['value']);
		}

		private var inito:Interlude;

		private var startHolder:Sprite;

		public function get lastScene():String
		{
			return SOService.instance.getSO("lastScene") as String;
		}

		override protected function init():void
		{
		}

		private function initialize():void
		{
			onStart(null);
		}

		[Embed(source="/assets/start/title.png")]
		public static var Title:Class

//		[Embed(source="/assets/start/sb1.png")]
//		public static var StartBtn:Class
//
//		[Embed(source="/assets/start/sb2.png")]
//		public static var StartBtn2:Class

		public function showStart():void
		{
			startHolder=new Sprite();
			startHolder.addChild(Image.fromBitmap(new PalaceModule.gameBG()));
			var title:Image=Image.fromBitmap(new Title());
			title.x=171;
			startHolder.addChild(title);
			addChild(startHolder);
//			var startBtn:ElasticButton=new ElasticButton(Image.fromBitmap(new StartBtn()));
//			startBtn.shadow=Image.fromBitmap(new StartBtn2());
//			startBtn.x=512;
//			startBtn.y=488;
//			startHolder.addChild(startBtn);
//			startBtn.addEventListener(ElasticButton.CLICK, onStart);
		}

		private function onStart(e:Event):void
		{
			if (startHolder)
			{
				startHolder.removeFromParent(true);
				startHolder=null;
			}
			if (!lastScene)
				initIntro();
			else
				startGame();
		}

		override public function restart():void
		{
//			showStart();
			onStart(null);
		}

		private function initIntro():void
		{
			inito=new Interlude("assets/video/intro.mp4", true, null, startGame);
			Starling.current.nativeStage.addChild(inito);
		}

		private function startGame():void
		{
			SoundAssets.initVol();
			SoundAssets.playBGM("main");
			parseMS(lastScene);
		}

		private function parseMS(_lastScene:String):void
		{
			if (!_lastScene)
			{
				var cb:Function=function():void {
					touchable=false;
					MC.needGuide=true;
					Map.show();
				};
				if (!PalaceGuide.assetManager)
					PalaceGuide.init(cb)
				else
					cb();
				return;
			}

			BooksManager.showBooks(0, 0, 0, false);
			return;

			var moduleIndex:int=int(_lastScene.charAt(0)) - 1;
			var sceneIndex:int=int(_lastScene.charAt(1)) - 1;
			if (lastScene.indexOf("end") >= 0)
				BooksManager.showBooks(0, 0, 0, false);
			else if (moduleIndex < 0 || sceneIndex < 0)
				Map.show();
			else if (_lastScene.lastIndexOf("map") < 0)
			{
				if (Capabilities.isDebugger)
					MC.instance.gotoModule(moduleIndex, sceneIndex);
				else
					BooksManager.showBooks(0, 0, 0, false);
			}
			else
				Map.show(null, moduleIndex - 1, moduleIndex);
		}
	}
}
