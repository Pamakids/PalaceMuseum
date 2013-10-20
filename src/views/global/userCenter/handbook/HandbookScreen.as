package views.global.userCenter.handbook
{
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 */
	public class HandbookScreen extends BaseScreen
	{
		/**
		 * 手册总页数（左右为1页）
		 */		
		public static const MAX_NUM:int = 13;
		
		public function HandbookScreen()
		{
		}

		private var _assetsManager:AssetManager;
		
		public var crtPage:int = 0;
		private var isNew:Boolean = false;
		
		override protected function initialize():void
		{
			super.initialize();
			_assetsManager=new AssetManager();
			isNew = UserCenterManager.getCrtUserCenter().aniable;	//用以区分是否是第几次打开手册
			if(isNew)		
			{
				initImages();
				loadPrevAndNext(crtPage);
				_assetsManager.loadQueue(function(r:Number):void{});
			}
			else
			{
				_assetsManager.enqueue(
					"assets/global/userCenter/content_page_"+(crtPage*2+1)+".png",
					"assets/global/userCenter/content_page_"+(crtPage*2+2)+".png"
				);
				_assetsManager.loadQueue(function(ratio:Number):void{
					if(ratio == 1)
					{
						initImages();
						loadPrevAndNext(crtPage);
						_assetsManager.loadQueue(function(r:Number):void{});
					}
				});
			}
		}
		
		private var cacheL:Image;
		private var cacheR:Image;
		private function initImages():void
		{
			cacheL = new Image((isNew)?UserCenterManager.getTexture("content_page_1"):_assetsManager.getTexture("content_page_"+(crtPage*2+1)));
			this.addChild(cacheL);
			cacheR = new Image((isNew)?UserCenterManager.getTexture("content_page_2"):_assetsManager.getTexture("content_page_"+(crtPage*2+2)));
			this.addChild( cacheR );
			cacheR.x = viewWidth / 2;
			cacheL.touchable = cacheR.touchable = false;
			UserCenterManager.getCrtUserCenter().initialized = true;
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
		 * 检测是否拥有某一页纹理资源
		 * @param pageIndex
		 * @return 
		 * 
		 */		
		private function testHasAssets(pageIndex:int):Boolean
		{
			if( _assetsManager.getTexture("content_page_" + String(pageIndex*2+1)) )
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 检测是否有某页纹理
		 * @return 
		 */		
		public function hasAssets(pageIndex:int):Boolean
		{
			if( testHasAssets(pageIndex) )
			{
				//加载前后页纹理
				loadPrevAndNext(pageIndex);
				_assetsManager.loadQueue(function(ratio:Number):void{});
				return true;
			}
			else
			{
				//加载当前页及其前后页纹理
				loadPrevAndNext(pageIndex);
				_assetsManager.enqueue(
					"assets/global/userCenter/content_page_" + String(pageIndex*2+1) + ".png", 
					"assets/global/userCenter/content_page_" + String(pageIndex*2+2) + ".png"
				);
				_assetsManager.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1.0)
						loadAssetsComplete();
				});
				return false;
			}
		}
		/**加载当前页前后页纹理*/		
		private function loadPrevAndNext(pageIndex:int):void
		{
			if(pageIndex > 0)
				if(!testHasAssets(pageIndex-1))
					_assetsManager.enqueue(
						"assets/global/userCenter/content_page_" + String((pageIndex-1)*2+1) + ".png", 
						"assets/global/userCenter/content_page_" + String((pageIndex-1)*2+2) + ".png"
					);
			if(pageIndex < MAX_NUM-1)
				if(!testHasAssets(pageIndex+1))
					_assetsManager.enqueue(
						"assets/global/userCenter/content_page_" + String((pageIndex+1)*2+1) + ".png", 
						"assets/global/userCenter/content_page_" + String((pageIndex+1)*2+2) + ".png"
					);
		}
		
		public var loadAssetsComplete:Function;
		public function clearByPageIndex(pageIndex:int):void
		{
			var name:String = "content_page_"+String(pageIndex*2+1);
			var texture:Texture = _assetsManager.getTexture(name);
			if(texture)
				_assetsManager.removeTexture(name, true);
			name = "content_page_"+String(pageIndex*2+2);
			texture = _assetsManager.getTexture(name);
			if(texture)
				_assetsManager.removeTexture(name, true);
		}
		
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
