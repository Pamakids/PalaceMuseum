package
{
	import flash.filesystem.File;

	import modules.module1.scene2.ClothPuzzle;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	public class Main extends Sprite
	{
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, inits);
		}

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, inits);

//			var module:Sprite=new Module1();
//			addChild(module);
			var am:AssetManager=new AssetManager();
			var file:File=File.applicationDirectory.resolvePath('assets/module1/scene12');
			am.enqueue(file);
			am.loadQueue(function(ratio:Number):void
			{
				trace(ratio);
				if (ratio == 1)
				{
					addChild(new ClothPuzzle(am));
				}
			});
		}
	}
}

