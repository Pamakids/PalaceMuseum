package
{
	import com.greensock.TweenLite;

	import flash.filesystem.File;
	import flash.system.Capabilities;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import events.UserBehaviorEvent;

	import models.FontVo;
	import models.PosVO;
	import models.SOService;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.Interlude;
	import views.components.PalaceGuide;
	import views.components.base.Container;
	import views.global.books.BooksManager;
	import views.global.map.Map;

	public class Main extends Container
	{
		public function Main()
		{
			if (Capabilities.isDebugger)
			{
//				SOService.instance.clear();
				SOService.instance.setSO("lastScene", "61map");
			}
			super();

			this.scaleX=this.scaleY=PosVO.scale;

			SoundAssets.init();
			showStart();

			MC.instance.init(this);
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
			if(!musicPlayed)
				return;
			if(MC.assetManager==null)
				return;
			onStart(null);
		}

		[Embed(source="/assets/start/title.png")]
		public static var Title:Class
		private var musicPlayed:Boolean;

		public function showStart():void
		{
			startHolder=new Sprite();
			var title:Image=Image.fromBitmap(new Title());
			startHolder.addChild(title);
			addChild(startHolder);
			TweenLite.delayedCall(1, function():void {
				SoundAssets.playSFX("dang", false, 1);
			});

			TweenLite.delayedCall(4.8,function():void{
				musicPlayed=true;
				initialize();
			});
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
			if(MC.isIOS)
			{
				inito=new Interlude(0, true, null, startGame);
				MC.instance.stage.addChild(inito);
			}
			else
				startGame()
//			Starling.current.nativeStage.addChild(inito);
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
				MC.instance.stage.hintShowed=false;
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

//			BooksManager.showBooks(0, 0, 0, false);
//			MC.instance.showMenu();
//			return;

			var moduleIndex:int=int(_lastScene.charAt(0)) - 1;
			var sceneIndex:int=int(_lastScene.charAt(1)) - 1;

			if(moduleIndex==5)
				moduleIndex=1;
			else if(moduleIndex>0)
				moduleIndex++;

			if(MC.isFinished())
			{
				MC.instance.showMenu();
				return;
			}

			if (lastScene.indexOf("end") >= 0)
//				BooksManager.showBooks(0, 0, 0, false);
				MC.instance.showMenu();
			else if (moduleIndex < 0 || sceneIndex < 0)
				Map.show();
			else if (_lastScene.lastIndexOf("map") < 0)
			{
//				if (Capabilities.isDebugger)
				MC.instance.gotoModule(moduleIndex, sceneIndex);
//				else
//					MC.instance.showMenu();
//					BooksManager.showBooks(0, 0, 0, false);
			}
			else
				Map.show(null, moduleIndex - 1, moduleIndex);
		}
	}
}


