package views.global.userCenter
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	
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
			var image:Image = new Image(UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		public var viewHeight:Number;
		public var viewWidth:Number;
		
		/**
		 * 获取场景纹理
		 */		
		public function getScreenTexture(render:RenderTexture):RenderTexture
		{
			render.draw(this);
			return render;
		}
	}
}