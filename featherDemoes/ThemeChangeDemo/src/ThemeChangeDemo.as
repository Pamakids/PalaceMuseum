package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	public class ThemeChangeDemo extends Sprite
	{
		private var _star:Starling;
		
		public function ThemeChangeDemo()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		protected function initialize(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_star = new Starling(Main, stage);
//			_star.enableErrorChecking = true;
			_star.start();
		}
	}
}