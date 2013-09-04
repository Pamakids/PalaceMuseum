package views.global.userCenter.handbook
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.components.SoftPageAnimation;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 * 
	 */	
	public class HandbookScreen extends Screen
	{
		public function HandbookScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initUserInfo();
			initAnimation();
		}
		
		/**
		 * 获取用户数据
		 */		
		private function initUserInfo():void
		{
		}
		private var userinfo:Object;
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		
//Animation--------------------------------------------------------------------------------
		private var container:Sprite;
		private var vecTexture:Vector.<Texture>;
		private var animation:SoftPageAnimation;
		private function initAnimation():void
		{
			initTextures();
			animation = new SoftPageAnimation(width, height, vecTexture, 0, true, 0.5);
			this.addChild(animation);
		}
		
		private function initTextures():void
		{
			var leftBack:Image = new Image(UserCenterManager.assetsManager.getTexture("page_left"));
			var rightBack:Image = new Image(UserCenterManager.assetsManager.getTexture("page_right"));
			var leftImage:Image = new Image(UserCenterManager.assetsManager.getTexture("content_left"));
			var rightImage:Image = new Image(UserCenterManager.assetsManager.getTexture("content_right"));
			vecTexture = new Vector.<Texture>();
			
			for(var i:int = 0;i<6;i++)
			{
				vecTexture.push( UserCenterManager.assetsManager.getTexture("page_"+(i+1).toString()) );
//				switch(i%2)
//				{
//					case 0:
//						vecTexture.push( UserCenterManager.assetsManager.getTexture("page_left") );
//						break;
//					case 1:
//						vecTexture.push( UserCenterManager.assetsManager.getTexture("page_right") );
//						break;
//				}
			}
//			for(var i:int = 0;i<4;i++)
//			{
//				var render:RenderTexture = new RenderTexture(width/2, height, true);
//				if(i%2 == 0)		//左
//				{
//					render.draw(leftBack);
//					render.draw(leftImage);
//				}
//				else		//右
//				{
//					render.draw(rightBack);
//					render.draw(rightImage);
//				}
//				vecTexture.push( render );
//			}
			
		}
	}
}