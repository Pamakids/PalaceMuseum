package
{
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	import views.Module1;
	import views.components.Prompt;

	public class Main extends Sprite
	{
		private var scale:Number;

		public function Main()
		{
			Prompt.parent=this;
			addEventListener(Event.ADDED_TO_STAGE, inits);
		}

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, inits);
			scale=DPIUtil.getDPIScale();

			this.scaleX=this.scaleY=scale;

			PopUpManager.root=this;
			PopUpManager.overlayFactory=function defaultOverlayFactory():DisplayObject
			{
				const quad:Quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				return quad;
			}

			var module:Sprite=new Module1();
			addChild(module);
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
////					addChild(new ClothPuzzle(am));
//				}
//			});
		}
	}
}

