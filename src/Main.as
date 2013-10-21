package
{
	import com.pamakids.manager.SoundManager;
	
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	import controllers.MC;
	
	import models.Const;
	import models.FontVo;
	import models.SOService;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	import views.Interlude;
	import views.Module1;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.global.map.Map;

	public class Main extends Container
	{
		private var testingModule:Sprite;
		private var testingModuleClass:Class=Module1;

		public function Main()
		{
//			SOService.instance.clear();
//			SOService.instance.init();
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
		
		override protected function init():void
		{
			var lastScene:String=SOService.instance.getSO("lastScene") as String;
			trace(lastScene);
			if(!lastScene)
				initIntro();
			else
				startGame();
		}
		
		private function initIntro():void
		{
			inito = new Interlude("assets/video/intro.mp4", false, null, startGame);
			Starling.current.nativeStage.addChild( inito );
		}

		private function startGame():void
		{
			SoundManager.instance.play('main');
			var lastScene:String=SOService.instance.getSO("lastScene") as String;
			parseMS(lastScene);
		}

		private function parseMS(lastScene:String):void
		{
			if (!lastScene)
			{
				Map.show();
				return;
			}
			var moduleIndex:int=int(lastScene.charAt(0)) - 1;
			var sceneIndex:int=int(lastScene.charAt(1)) - 1;
			if (moduleIndex < 0 || sceneIndex < 0)
				Map.show();
			else if (lastScene.lastIndexOf("map") < 0)
				MC.instance.gotoModule(moduleIndex, sceneIndex);
			else
				Map.show(null, moduleIndex - 1, moduleIndex);
		}

		private function debugInit():void
		{
			if (Capabilities.isDebugger)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
				{
					if (e.keyCode == Keyboard.ENTER)
					{
						if (testingModule)
						{
							removeChild(testingModule);
							testingModule=null;
						}
						else
						{
							testingModule=new testingModuleClass();
							addChild(testingModule);
						}
					}
					else if (e.keyCode == Keyboard.RIGHT)
					{
//						LionMC.instance.say(Math.random().toString());
						MC.instance.nextModule();
					}
				});
				return;
			}
		}
	}
}
