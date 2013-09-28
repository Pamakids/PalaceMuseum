package views.global.userCenter.handbook
{
	import starling.display.Image;
	import starling.utils.AssetManager;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 */
	public class HandbookScreen extends BaseScreen
	{
		public function HandbookScreen()
		{
		}

		private var _assetsManager:AssetManager;
		
		private var crtPage:int = 0;
		override protected function initialize():void
		{
			super.initialize();
			_assetsManager=new AssetManager();
			_assetsManager.enqueue("assets/global/userCenter/content_page_1.png", "assets/global/userCenter/content_page_2.png");
			initImages();
		}
		
		private var cacheL:Image;
		private var cacheR:Image;
		private function initImages():void
		{
			cacheL = new Image(UserCenterManager.getTexture("content_page_1"));
			this.addChild(cacheL);
			cacheR = new Image(UserCenterManager.getTexture("content_page_2"));
			this.addChild( cacheR );
			cacheR.x = viewWidth / 2;
			cacheL.touchable = cacheR.touchable = false;
		}
		
		override public function dispose():void
		{
			if(cacheL)
				cacheL.removeFromParent(true);
			if(cacheR)
				cacheR.removeFromParent(true);
			_assetsManager.dispose();
		}
		
		/**
		 * 检测是否有某页纹理
		 * @return 
		 * 
		 */		
		public function hasAssets(pageIndex:int):Boolean
		{
			if( _assetsManager.getTexture("content_page_" + String(pageIndex*2+1)) )
			{
				return true;
			}
			else
			{
				_assetsManager.enqueue(
					"assets/global/userCenter/content_page_" + String(pageIndex*2+1) + ".png", 
					"assets/global/userCenter/content_page_" + String(pageIndex*2+2) + ".png");
				_assetsManager.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1.0)
					{
						loadAssetsComplete();
					}
				});
				return false;
			}
		}
		
		public var loadAssetsComplete:Function;
		
		/**
		 * 更新页面
		 * @param pageIndex
		 * @return 
		 */		
		public function updateView(pageIndex:int):void
		{
			cacheL.texture = _assetsManager.getTexture("content_page_" + String(pageIndex*2+1));
			cacheR.texture = _assetsManager.getTexture("content_page_" + String(pageIndex*2+2));
		}
	}
}
