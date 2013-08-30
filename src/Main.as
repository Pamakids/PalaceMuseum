package
{
	import com.pamakids.manager.LoadManager;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Bitmap;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	import controls.MainCtrl;

	import feathers.core.PopUpManager;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	import views.Module2;
	import views.components.FlipAnimation;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;
	import views.global.Map;
	import views.global.userCenter.UserCenterManager;

	public class Main extends Container
	{
		private var scale:Number;
		private var moduleArr:Array=[Module2]

		private var moduleIndex:int;
		private var crtModule:PalaceModule;
		private var testingModule:Sprite;
		private var testingModuleClass:Class=Map;

		public function Main()
		{
			MainCtrl.instance.main=this;
			Prompt.parent=this;
			super(1024, 768);
		}

		override protected function init():void
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
							testingModule=new testingModuleClass(width, height);
							addChild(testingModule);
						}
					}
				});
				return;
			}
			else
			{
				this.scaleX=this.scaleY=scale;
				PopUpManager.root=this;
				PopUpManager.overlayFactory=function defaultOverlayFactory():DisplayObject
				{
					const quad:Quad=new Quad(1024, 768, 0x000000);
					quad.alpha=.4;
					return quad;
				};

				initLayers();

				addEventListener("gotoNextModule", nextModule);
				moduleIndex=0;
				loadModule(moduleIndex);
			}
		}

		private var UILayer:Sprite;
		private var contentLayer:Sprite;

		private function initLayers():void
		{
			contentLayer=new Sprite();
			addChild(contentLayer);
			UILayer=new Sprite();
			addChild(UILayer);
		}

		private function nextModule():void
		{
			moduleIndex++;
			loadModule(moduleIndex);
		}

		private function loadModule(index:int):void
		{
			if (crtModule)
			{
//				contentLayer.removeChild(crtModule);
//				crtModule.dispose();
			}
			if (index < moduleArr.length)
			{
				playCutscene();
				var module:Class=moduleArr[index] as Class;
				crtModule=new module();
				contentLayer.addChild(crtModule);
			}
			else
			{
				trace("nextModule")
			}
		}

		private function playCutscene():void
		{
			// TODO Auto Generated method stub

		}

		private function testFlipAnimation():void
		{
			testingModule=new Map(width, height);
			addChild(testingModule);
		}

		private function testClothPuzzleAndPrompt():void
		{
//			var am:AssetManager=new AssetManager();
//			var file:File=File.applicationDirectory.resolvePath('assets/module1/scene12');
//			am.enqueue(file);
//			am.loadQueue(function(ratio:Number):void
//			{
//				Prompt.addAssetManager(am);
//				trace(ratio);
//				if (ratio == 1)
//				{
//					stage.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void
//					{
//						var t:Touch=e.getTouch(stage);
//						if (t && t.phase == TouchPhase.BEGAN)
//						{
//							Prompt.show(1024 / 2, 768 / 2, 'hint-bg-2', 'hint-ok-常服');
//							trace('show');
//						}
//					});
//					//					addChild(new ClothPuzzle(am));
//				}
//			});
		}


		private function testUserCenter():void
		{
			UserCenterManager.userCenterContainer=this;
			UserCenterManager.showUserCenter();
		}
	}
}

