package views.global.books.userCenter.screen
{
	import feathers.core.PopUpManager;

	import models.FontVo;

	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.global.books.BooksManager;
	import views.global.books.events.BookEvent;
	import views.global.books.handbook.screen.HandbookScreen;

	public class DeveloperScreen extends BaseScreen
	{
		public static const MAX_NUM:int=5;

		private var _assetsManager:AssetManager;
		private var crtPage:int;

		public function DeveloperScreen()
		{
			_assetsManager = new AssetManager();
		}

		override protected function initialize():void
		{
			initPages();
			initLoad();
//			dispatchEvent( new Event( BookEvent.InitViewPlayed ) );
			dispatchEvent( new Event( BookEvent.Initialized ) );
		}

		override protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_2");
			image.scaleX=image.scaleY=2;
			this.addChild( image );
		}

		private function initLoad():void
		{
			load=new Image(Texture.fromBitmap(new PalaceModule.loading()));
			load.pivotX=load.width >> 1;
			load.pivotY=load.height >> 1;
			load.x=1024/2;
			load.y=768/2;
			load.scaleX=load.scaleY=.5;
			PopUpManager.addPopUp(load, true, false);
			load.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				load.rotation+=0.2;
			});
		}

		/**
		 * 初始化显示，需手动调用
		 */
		public function initView(pageIndex:int):void
		{
			crtPage=pageIndex;
			_assetsManager.enqueue("assets/global/handbook/developer_" + crtPage + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
				{
					if (crtPage > 0)
						_assetsManager.enqueue("assets/global/handbook/developer_" + String(crtPage - 1) + ".png");
					if (crtPage < MAX_NUM - 1)
						_assetsManager.enqueue("assets/global/handbook/developer_" + String(crtPage + 1) + ".png");
					_assetsManager.loadQueue(function(r:Number):void {});
					initImages();
					initPageNums();
					removeLoad();
					dispatchEventWith(BookEvent.InitViewPlayed);
				}
			});
		}

		private var cache:Image;

		private function initImages():void
		{
			cache=new Image(_assetsManager.getTexture("developer_" + crtPage));
			this.addChild(cache);
			cache.touchable=false;
		}

		private var page_0:TextField;
		private var page_1:TextField;

		private function initPageNums():void
		{
			var n:int=MAX_NUM * 2;
			page_0=new TextField(100, 40, String(crtPage * 2 + 1) + " / " + n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_1=new TextField(100, 40, String(crtPage * 2 + 2) + " / " + n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_0.touchable=page_1.touchable=false;
			page_0.x=196;
			page_1.x=680;
			page_0.y=page_1.y=590;
			this.addChild(page_0);
			this.addChild(page_1);
		}

		private var load:Image;

		private function removeLoad():void
		{
			if (PopUpManager.isPopUp(load))
				PopUpManager.removePopUp(load, true);
		}


		/**
		 * 上翻一页，翻页失败会派发UserCenter.ViewUpdateFail事件
		 */
		public function pageUp():void
		{
			if (crtPage <= 0)
			{
				dispatchEventWith(BookEvent.ViewUpdateFail);
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
				dispatchEventWith(BookEvent.ViewUpdateFail);
				return;
			}
			clearByPageIndex(crtPage - 1);
			loadByPageIndex(crtPage + 2);
			this.crtPage+=1;
			updateView();
		}

		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cache.texture=_assetsManager.getTexture("developer_" + crtPage);
			page_0.text=String(crtPage * 2 + 1) + " / " + String(MAX_NUM * 2);
			page_1.text=String(crtPage * 2 + 2) + " / " + String(MAX_NUM * 2);
			dispatchEventWith(BookEvent.ViewUpdated, false, crtPage);
		}

		/**
		 * 动态加载纹理
		 * @param pageIndex
		 */
		private function loadByPageIndex(pageIndex:int):void
		{
			if (pageIndex < 0 || pageIndex > HandbookScreen.MAX_NUM - 1)
				return;
			_assetsManager.enqueue("assets/global/handbook/developer_" + pageIndex + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void {
				//				if (ratio == 1)
				//					trace("资源加载完成");
			});
		}

		/**
		 * 清除纹理以释放资源
		 * @param pageIndex
		 */
		private function clearByPageIndex(pageIndex:int):void
		{
			var texture:Texture=_assetsManager.getTexture("developer_" + pageIndex);
			if (texture)
				_assetsManager.removeTexture("developer_" + pageIndex, true);
		}

		override public function dispose():void
		{
			if (cache)
				cache.removeFromParent(true);
			if (page_0)
				page_0.removeFromParent(true);
			if (page_1)
				page_1.removeFromParent(true);
			_assetsManager.purge();
			super.dispose();
		}
	}
}

