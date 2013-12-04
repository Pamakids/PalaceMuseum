package views.global.books.userCenter.screen
{
	import starling.display.Image;
	import starling.events.Event;
	
	import views.global.books.BooksManager;
	import views.global.books.events.BookEvent;

	public class DeveloperScreen extends BaseScreen
	{
		public function DeveloperScreen()
		{
		}
		
		override protected function initialize():void
		{
			initPages();
			dispatchEvent( new Event( BookEvent.InitViewPlayed ) );
		}
		
		override protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_2");
			this.addChild( image );
		}
		
		override public function dispose():void
		{
			
			super.dispose();
		}
	}
}