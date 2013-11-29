package views.global.userCenter.screen
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import views.global.userCenter.UserCenterManager;
	
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
			var image:Image = UserCenterManager.getImage("background_0");
			this.addChild( image );
		}
		
		public var viewHeight:Number;
		public var viewWidth:Number;
	}
}