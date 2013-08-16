package
{
	import modules.Module1;

	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,inits);
		}

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,inits);

			var module:Sprite=new Module1();
			addChild(module);
		}
	}
}

