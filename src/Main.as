package
{
	import com.pamakids.manager.LoadManager;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Bitmap;

	import feathers.core.PopUpManager;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	import views.Module1;
	import views.components.FlipAnimation;
	import views.components.Prompt;
	import views.components.base.Container;
	import views.components.base.PalaceModule;

	public class Main extends Container
	{
		private var scale:Number;
		private var moduleArr:Array=[Module1]

		private var moduleIndex:int;
		private var crtModule:PalaceModule;

		public function Main()
		{
			Prompt.parent=this;
			addEventListener(Event.ADDED_TO_STAGE, inits);
			super(1024, 768);
		}

		private function inits(e:Event):void
		{
//			testFlipAnimation();
//			return;
			removeEventListener(Event.ADDED_TO_STAGE, inits);
			scale=DPIUtil.getDPIScale();

			this.scaleX=this.scaleY=scale;

			PopUpManager.root=this;
			PopUpManager.overlayFactory=function defaultOverlayFactory():DisplayObject
			{
				const quad:Quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				return quad;
			};


			addEventListener("gotoNextModule", nextModule);
			moduleIndex=0;
			loadModule(moduleIndex);

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
				removeChild(crtModule);
				crtModule.dispose();
			}
			if (index < moduleArr.length)
			{
				var module:Class=moduleArr[index] as Class;
				crtModule=new module();
				addChild(crtModule);
			}
			else
			{
				trace("nextModule")
			}
		}

		private function testFlipAnimation():void
		{
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', function(b:Bitmap):void
			{
				var f:FlipAnimation=new FlipAnimation(b, 6, 6);
				f.width=width;
				f.height=height;
				addChild(f);
//				TweenLite.to(f, 3, {y: -100});
			});
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
	}
}

