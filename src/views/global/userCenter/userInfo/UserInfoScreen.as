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
	/**
	 * 用户信息
	 * @author Administrator
	 */	
	public class UserInfoScreen extends Screen implements IUserCenterScreen
	{
		public function UserInfoScreen()
		{
			super();
		}
		
		/*
		 * 1. 主界面
		 * 		点击切换用户按钮 → 进入用户选择界面
		 * 		点击游戏列表图标 → 打开游戏信息界面
		 * 2. 用户选择界面 
		 * 		选择编辑指定角色，进入角色编辑界面
		 * 3. 角色编辑界面
		 * 		变更用户头像
		 * 		更改用户名称
		 * 		修改出生日期
		 * 		删除用户 → 弹出确认窗口
		 * 		确定切换至指定用户
		 * 4. 游戏信息界面、
		 * 		进入游戏
		 * 5. Alert界面
		 * 		确定或取消删除角色的操作
		 */		
		
		
		override protected function initialize():void
		{
			initBackgroundImage();
		}
		
		
		private function initBackgroundImage():void
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