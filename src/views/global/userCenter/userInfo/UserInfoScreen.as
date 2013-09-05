package views.global.userCenter.userInfo
{
	import feathers.controls.Screen;
	
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	
	public class UserInfoScreen extends Screen implements IUserCenterScreen
	{
		public function UserInfoScreen()
		{
			super();
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override protected function initialize():void
		{
			super.initialize();
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		private var screenTexture:Vector.<Texture>;
		public function getScreenTexture():Vector.<Texture>
		{
			if(!screenTexture)
			{
				screenTexture = new Vector.<Texture>(2);
			}
			return screenTexture;
		}
	}
}