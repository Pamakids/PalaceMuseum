package
{
	import com.pamakids.manager.SoundManager;

	import flash.filesystem.File;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.Const;
	import models.FontVo;
	import models.SOService;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.Interlude;
	import views.components.ElasticButton;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.map.Map;
	import views.global.userCenter.UserCenterManager;

	public class Main extends Container
	{
		public function Main()
		{
//			SOService.instance.clear();
//			SOService.instance.init();
//			SOService.instance.setSO("lastScene", "31map");
			super(Const.WIDTH, Const.HEIGHT);
			scaleX=scaleY=scale;
			MC.instance.init(this);
			UserBehaviorAnalysis.trackEvent("全局", "游戏开始");
			//以免第一次初始化提示的时候卡顿
			var label:TextField=new TextField(1, 1, '0', FontVo.PALACE_FONT, 16, 0x561a1a, true);
			addChild(label);
			label.x=-10;
			label.y=-10;

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
		}

		private var inito:Interlude;

		private var startHolder:Sprite;

		public function get lastScene():String
		{
			return SOService.instance.getSO("lastScene") as String;
		}

		override protected function init():void
		{
//			if (!lastScene)
//				showStart();
//			else
//				startGame();
		}

		private function initialize():void
		{
			if (!lastScene)
				showStart();
			else
				startGame();
		}

		[Embed(source="/assets/start/title.png")]
		public static var Title:Class

		[Embed(source="/assets/start/sb1.png")]
		public static var StartBtn:Class

		[Embed(source="/assets/start/sb2.png")]
		public static var StartBtn2:Class

		public function showStart():void
		{
			startHolder=new Sprite();
			startHolder.addChild(Image.fromBitmap(new PalaceModule.gameBG()));
			var title:Image=Image.fromBitmap(new Title());
			title.x=171;
			startHolder.addChild(title);
			addChild(startHolder);

			var startBtn:ElasticButton=new ElasticButton(Image.fromBitmap(new StartBtn()));
			startBtn.shadow=Image.fromBitmap(new StartBtn2());
			startBtn.x=512;
			startBtn.y=488;
			startHolder.addChild(startBtn);
			startBtn.addEventListener(ElasticButton.CLICK, onStart);
		}

		private function onStart(e:Event):void
		{
			startHolder.removeFromParent(true);
			if (!lastScene)
				initIntro();
			else
				startGame();
		}

		override public function restart():void
		{
			showStart();
		}

		private function initIntro():void
		{
			inito=new Interlude("assets/video/intro.mp4", true, null, startGame);
			Starling.current.nativeStage.addChild(inito);
		}

		private function startGame():void
		{
			SoundManager.instance.play("main");
			parseMS(lastScene);
		}

		private function parseMS(_lastScene:String):void
		{
			if (!_lastScene)
			{
				Map.show();
				return;
			}
			var moduleIndex:int=int(_lastScene.charAt(0)) - 1;
			var sceneIndex:int=int(_lastScene.charAt(1)) - 1;
			if (lastScene.indexOf("end") >= 0)
				UserCenterManager.showUserCenter(0, 0, false);
			else if (moduleIndex < 0 || sceneIndex < 0)
				Map.show();
			else if (_lastScene.lastIndexOf("map") < 0)
				MC.instance.gotoModule(moduleIndex, sceneIndex);
			else
				Map.show(null, moduleIndex - 1, moduleIndex);
		}
	}
}
