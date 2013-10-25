package
{
	import flash.filesystem.File;

	import controllers.MC;

	import models.Const;
	import models.FontVo;
	import models.SOService;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.Interlude;
	import views.Module1;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.map.Map;

	public class Main extends Container
	{
		private var testingModule:Sprite;
		private var testingModuleClass:Class=Module1;

		public function Main()
		{
//			SOService.instance.clear();
//			SOService.instance.init();
//			SOService.instance.setSO("lastScene", "53map");
			super(Const.WIDTH, Const.HEIGHT);
			scaleX=scaleY=scale;
			MC.instance.init(this);
			//以免第一次初始化提示的时候卡顿
			var label:TextField=new TextField(1, 1, '0', FontVo.PALACE_FONT, 16, 0x561a1a, true);
			addChild(label);
			label.removeFromParent(true);

			var am:AssetManager=new AssetManager();
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			am.enqueue(f);
			am.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
					Prompt.addAssetManager(am);
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
			if (!lastScene)
				showStart();
			else
				startGame();
		}

		[Embed(source="/assets/common/title.png")]
		public static var Title:Class

		public function showStart():void
		{
			startHolder=new Sprite();
			startHolder.addChild(Image.fromBitmap(new PalaceModule.gameBG()));
			var title:Image=Image.fromBitmap(new Title());
			title.x=1024 - title.width >> 1;
			title.y=768 - title.height >> 1;
			startHolder.addChild(title);
			addChild(startHolder);
			startHolder.addEventListener(TouchEvent.TOUCH, onStart);
		}

		private function onStart(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(startHolder, TouchPhase.ENDED)
			if (tc)
			{
				startHolder.removeFromParent(true);
				if (!lastScene)
					initIntro();
				else
					startGame();
			}
		}

		override public function restart():void
		{
			showStart();
		}

		private function initIntro():void
		{
			inito=new Interlude("assets/video/intro.mp4", false, null, startGame);
			Starling.current.nativeStage.addChild(inito);
		}

		private function startGame():void
		{
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
			if (moduleIndex < 0 || sceneIndex < 0)
				Map.show();
			else if (_lastScene.lastIndexOf("map") < 0)
				MC.instance.gotoModule(moduleIndex, sceneIndex);
			else
				Map.show(null, moduleIndex - 1, moduleIndex);
		}
	}
}
