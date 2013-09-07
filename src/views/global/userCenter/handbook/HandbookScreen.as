package views.global.userCenter.handbook
{
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.components.SoftPageAnimation;
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 */	
	public class HandbookScreen extends Screen implements IUserCenterScreen
	{
		public function HandbookScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			leftContainer = new Sprite();
			rightContainer = new Sprite();
			leftBack = new Image(UserCenterManager.assetsManager.getTexture("page_left"));
			rightBack = new Image(UserCenterManager.assetsManager.getTexture("page_right"));
			leftContainer.width = rightContainer.width = rightContainer.x = leftBack.width = rightBack.width = width/2;
			leftContainer.addChild( leftBack );
			rightContainer.addChild( rightBack );
			initUserInfo();
			initAnimation();
			initScreenTexture();
		}
		
		/**
		 * 获取用户数据
		 */		
		private function initUserInfo():void
		{
		}
		private var userinfo:Object;
		private var leftContainer:Sprite;
		private var rightContainer:Sprite;
		private var leftBack:Image;
		private var rightBack:Image;
		
		override public function dispose():void
		{
			animation.removeEventListener(SoftPageAnimation.PAGE_UP, turnPage);
			animation.removeEventListener(SoftPageAnimation.PAGE_DOWN, turnPage);
			
			if(animation)
				animation.dispose();
			if(vecTexture)
				vecTexture = null;
			super.dispose();
		}
		
		
		private var vecTexture:Vector.<Texture>;
		private var animation:SoftPageAnimation;
		private function initAnimation():void
		{
			initTextures();
			animation = new SoftPageAnimation(width, height, vecTexture, 0, false, 0.5);
			this.addChild(animation);
			
			animation.addEventListener(SoftPageAnimation.PAGE_UP, turnPage);
			animation.addEventListener(SoftPageAnimation.PAGE_DOWN, turnPage);
		}
		
		
		private function turnPage(e:Event):void
		{
			trace(e.type);
		}
		
		
		private function initTextures():void
		{
			var leftImage:Image = new Image(UserCenterManager.assetsManager.getTexture("content_left"));
			var rightImage:Image = new Image(UserCenterManager.assetsManager.getTexture("content_right"));
			leftImage.width = rightImage.width = width/2;
			
			vecTexture = new Vector.<Texture>();
			for(var i:int = 0;i<6;i++)
			{
//				vecTexture.push( UserCenterManager.assetsManager.getTexture("page_"+(i+1).toString()) );
//				continue;
				var render:RenderTexture = new RenderTexture(width/2, height, true);
				if(i%2 == 0)		//左
				{
					render.draw(leftBack);
					render.draw(leftImage);
				}
				else		//右
				{
					render.draw(rightBack);
					render.draw(rightImage);
				}
				vecTexture.push( render );
			}
			
		}
		
		/**
		 * 获取该场景纹理
		 */		
		public function getScreenTexture():Vector.<Texture>
		{
			if(!texturesInitialized)
				initScreenTexture();
			return screenTextures;
		}
		private var screenTextures:Vector.<Texture>;
		private var texturesInitialized:Boolean = false;
		public function testTextureInitialized():Boolean
		{
			return texturesInitialized;
		}
		
		private function initScreenTexture():void
		{
			if(texturesInitialized)
				return;
			screenTextures = new Vector.<Texture>(2);
			screenTextures[0] = vecTexture[0];
			screenTextures[1] = vecTexture[1];
			texturesInitialized = true;
		}

	}
}