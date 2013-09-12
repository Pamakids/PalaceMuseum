package views.global.userCenter.userInfo
{
	import flash.geom.Rectangle;
	
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenter;
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
			var image:Image = new Image( UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image.touchable = false;
			
			image = new Image( UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = width/2;
			image.touchable = false;
		}
		
		override public function dispose():void
		{
//			if(screenTexture)
//				screenTexture = null;
			super.dispose();
		}
		
		public function getScreenTexture():Vector.<Texture>
		{
			if(!UserCenterManager.getScreenTexture(UserCenter.USERINFO))
				initScreenTextures();
			return UserCenterManager.getScreenTexture(UserCenter.USERINFO);
		}
		
		private function initScreenTextures():void
		{
			if(UserCenterManager.getScreenTexture(UserCenter.USERINFO))
				return;
			var render:RenderTexture = new RenderTexture(width, height, true);
			render.draw( this );
			var ts:Vector.<Texture> = new Vector.<Texture>(2);
			ts[0] = Texture.fromTexture( render, new Rectangle( 0, 0, width/2, height) );
			ts[1] = Texture.fromTexture( render, new Rectangle( width/2, 0, width/2, height) );
			UserCenterManager.setScreenTextures(UserCenter.USERINFO, ts);
		}
	}
}