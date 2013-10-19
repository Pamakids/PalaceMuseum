package views.global.userCenter
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	
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
			var image:Image = new Image(UserCenterManager.getTexture("background_0"));
			this.addChild( image );
		}
		
		public var viewHeight:Number;
		public var viewWidth:Number;
	}
}