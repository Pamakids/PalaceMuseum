package views.global.books.userCenter.screen
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import views.global.books.BooksManager;
	
	public class BaseScreen extends Screen
	{
		public function BaseScreen()
		{
		}
		
		override protected function initialize():void
		{
			initPages();
		}
		
		protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_0");
			this.addChild( image );
			image.height += 6;
		}
		
		public var viewHeight:Number;
		public var viewWidth:Number;
	}
}