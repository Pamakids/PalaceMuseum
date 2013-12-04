package views.global.books.userCenter.screen
{
	import starling.events.Event;
	
	import views.global.books.events.BookEvent;

	public class DeveloperScreen extends BaseScreen
	{
		public function DeveloperScreen()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			dispatchEvent( new Event( BookEvent.InitViewPlayed ) );
		}
		
		override public function dispose():void
		{
			
			super.dispose();
		}
	}
}