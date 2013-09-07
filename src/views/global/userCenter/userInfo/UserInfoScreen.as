package views.global.userCenter.userInfo
{
	import flash.geom.Rectangle;
	
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class UserInfoScreen extends Screen implements IUserCenterScreen
	{
		public function UserInfoScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initPages();
			initScreenTextures();
		}
		
		private function initPages():void
		{
			var image:Image = new Image( UserCenterManager.assetsManager.getTexture("page_left"));
			this.addChild( image );
			image.touchable = false;
			
			image = new Image( UserCenterManager.assetsManager.getTexture("page_right"));
			this.addChild( image );
			image.x = width/2;
			image.touchable = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		private var screenTexture:Vector.<Texture>;
		public function getScreenTexture():Vector.<Texture>
		{
			return screenTexture;
		}
		private var texturesInitialized:Boolean = false;
		public function testTextureInitialized():Boolean
		{
			return texturesInitialized;
		}
		
		private function initScreenTextures():void
		{
			if(texturesInitialized)
				return;
			screenTexture = new Vector.<Texture>(2);
			var render:RenderTexture = new RenderTexture(width, height, true);
			render.draw( this );
			screenTexture[0] = Texture.fromTexture( render, new Rectangle( 0, 0, width/2, height) );
			screenTexture[1] = Texture.fromTexture( render, new Rectangle( width/2, 0, width/2, height) );
			texturesInitialized = true;
		}
	}
}