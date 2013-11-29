package views.global.userCenter.screen
{
	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.global.userCenter.UserCenter;

	/**
	 * 用户中心速成手册场景<p>
	 * 只在最初初始化时可以为handbook指定一个页面索引，其他时间使用pageUp与pageDown方法改变内容
	 * @author Administrator
	 */
	public class HandbookScreen extends BaseScreen
	{
		/**
		 * 手册总页数（左右为1页）
		 */
		public static const MAX_NUM:int=13;

		public function HandbookScreen()
		{
			_assetsManager=new AssetManager();
		}

		private var _assetsManager:AssetManager;
		private var crtPage:int;

		override protected function initialize():void
		{
			super.initialize();
			initLoad();
			dispatchEventWith(UserCenter.Initialized);
		}

		private var load:Image;

		private function initLoad():void
		{
			load=new Image(Texture.fromBitmap(new PalaceModule.loading()));
			load.pivotX=load.width >> 1;
			load.pivotY=load.height >> 1;
			load.x=1024 - 100;
			load.y=768 - 100;
			load.scaleX=load.scaleY=.5;
			PopUpManager.addPopUp(load);
			load.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				load.rotation+=0.2;
			});
		}

		private function removeLoad():void
		{
			if (PopUpManager.isPopUp(load))
				PopUpManager.removePopUp(load, true);
		}

		/**
		 * 初始化显示，需手动调用
		 */
		public function initView(pageIndex:int):void
		{
			crtPage=pageIndex;
			_assetsManager.enqueue(
				"assets/global/userCenter/content_page_" + (crtPage * 2 + 1) + ".png",
				"assets/global/userCenter/content_page_" + (crtPage * 2 + 2) + ".png"
				);
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
				{
					if (crtPage > 0)
					{
						_assetsManager.enqueue(
							"assets/global/userCenter/content_page_" + String((pageIndex - 1) * 2 + 1) + ".png",
							"assets/global/userCenter/content_page_" + String((pageIndex - 1) * 2 + 2) + ".png"
							);
					}
					if (crtPage < HandbookScreen.MAX_NUM - 1)
					{
						_assetsManager.enqueue(
							"assets/global/userCenter/content_page_" + String((pageIndex + 1) * 2 + 1) + ".png",
							"assets/global/userCenter/content_page_" + String((pageIndex + 1) * 2 + 2) + ".png"
							);
					}
					_assetsManager.loadQueue(function(r:Number):void {});
					initImages();
					removeLoad();
					dispatchEventWith(UserCenter.InitViewPlayed);

				}
			});
		}

		private var cacheL:Image;
		private var cacheR:Image;

		private function initImages():void
		{
			cacheL=new Image(_assetsManager.getTexture("content_page_" + (crtPage * 2 + 1)));
			this.addChild(cacheL);
			cacheR=new Image(_assetsManager.getTexture("content_page_" + (crtPage * 2 + 2)));
			this.addChild(cacheR);
			cacheR.x=viewWidth / 2;
			cacheL.touchable=cacheR.touchable=false;
		}

		/**
		 * 上翻一页，翻页失败会派发UserCenter.ViewUpdateFail事件
		 */
		public function pageUp():void
		{
			if (crtPage <= 0)
			{
				dispatchEventWith(UserCenter.ViewUpdateFail);
				return;
			}
			loadByPageIndex(crtPage - 2);
			clearByPageIndex(crtPage + 1);
			this.crtPage-=1;
			updateView();
		}

		/**
		 * 下翻一页，翻页失败会派发UserCenter.ViewUpdateFail事件
		 */
		public function pageDown():void
		{
			if (crtPage >= MAX_NUM - 1)
			{
				dispatchEventWith(UserCenter.ViewUpdateFail);
				return;
			}
			clearByPageIndex(crtPage - 1);
			loadByPageIndex(crtPage + 2);
			this.crtPage+=1;
			updateView();
		}

		/**
		 * 清除纹理以释放资源
		 * @param pageIndex
		 */
		private function clearByPageIndex(pageIndex:int):void
		{
			var name:String="content_page_" + String(pageIndex * 2 + 1);
			var texture:Texture=_assetsManager.getTexture(name);
			if (texture)
				_assetsManager.removeTexture(name, true);
			name="content_page_" + String(pageIndex * 2 + 2);
			texture=_assetsManager.getTexture(name);
			if (texture)
				_assetsManager.removeTexture(name, true);
		}

		/**
		 * 动态加载纹理
		 * @param pageIndex
		 */
		private function loadByPageIndex(pageIndex:int):void
		{
			if (pageIndex < 0 || pageIndex > HandbookScreen.MAX_NUM - 1)
				return;
			_assetsManager.enqueue(
				"assets/global/userCenter/content_page_" + String(pageIndex * 2 + 1) + ".png",
				"assets/global/userCenter/content_page_" + String(pageIndex * 2 + 2) + ".png"
				);
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
					trace("资源加载完成");
			});
		}

		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cacheL.texture=_assetsManager.getTexture("content_page_" + String(crtPage * 2 + 1));
			cacheR.texture=_assetsManager.getTexture("content_page_" + String(crtPage * 2 + 2));
			dispatchEventWith(UserCenter.ViewUpdated);
		}

		override public function dispose():void
		{
			if (cacheL)
				cacheL.removeFromParent(true);
			if (cacheR)
				cacheR.removeFromParent(true);
			_assetsManager.dispose();
		}
	}
}
