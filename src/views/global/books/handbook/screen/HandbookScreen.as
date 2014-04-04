package views.global.books.handbook.screen
{
	import feathers.core.PopUpManager;

	import models.FontVo;
	import models.SOService;

	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.global.books.BooksManager;
	import views.global.books.events.BookEvent;
	import views.global.books.userCenter.screen.BaseScreen;

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
		public static const MAX_NUM:int=11;

		public function HandbookScreen()
		{
			_assetsManager=new AssetManager();
		}

		/**
		 * 获取页面内容所指向的模块索引
		 */		
		public function get mapCrtPageToModule():int
		{
			//各模块内最后一个典故的页码
			const maxPageOfModules:Array = [2,4,6,8,10];
			for(var i:int = 0;i<maxPageOfModules.length;i++)
			{
				if(crtPage <= maxPageOfModules[i])
					return i;
			}
			return 0;
		}

		private var _assetsManager:AssetManager;
		private var crtPage:int;

		override protected function initialize():void
		{
			initPages()
			initLoad();
			dispatchEventWith(BookEvent.Initialized);
		}

		override protected function initPages():void
		{
			var image:Image=BooksManager.getImage("background_0");
			image.scaleX=image.scaleY=2;
			this.addChild(image);
			image.height+=6;
		}

		private var load:Image;

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
			_assetsManager.enqueue("assets/global/handbook/content_page_" + crtPage + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
				{
					if (crtPage > 0)
						_assetsManager.enqueue("assets/global/handbook/content_page_" + String(crtPage - 1) + ".png");
					if (crtPage < HandbookScreen.MAX_NUM - 1)
						_assetsManager.enqueue("assets/global/handbook/content_page_" + String(crtPage + 1) + ".png");
					_assetsManager.loadQueue(function(r:Number):void {});
					initImages();
					initPageNums();
					removeLoad();
					dispatchEventWith(BookEvent.InitViewPlayed);
				}
			});
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

		private var cache:Image;

		private function initImages():void
		{
			cache=new Image(_assetsManager.getTexture("content_page_" + crtPage));
			this.addChild(cache);
			cache.touchable=false;
			setSo();
		}

		private function setSo():void
		{
			var arr:Array=SOService.instance.getSO("progress_handbook") as Array;
			if (!arr)
				arr=new Array(MAX_NUM);
			arr[crtPage]=true;
			SOService.instance.setSO("progress_handbook", arr);
			if (checkSO())
				BooksManager.getCrtHandbook().showAchieve(31);
		}

		/**
		 * 检测是否已完成成就
		 * @return
		 */
		private function checkSO():Boolean
		{
			var arr:Array=SOService.instance.getSO("progress_handbook") as Array;
			if (!arr)
				return false;
			for (var i:int=0; i < arr.length; i++)
			{
				if (!arr[i])
					return false;
			}
			return true;
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
		 * 清除纹理以释放资源
		 * @param pageIndex
		 */
		private function clearByPageIndex(pageIndex:int):void
		{
			var texture:Texture=_assetsManager.getTexture("content_page_" + pageIndex);
			if (texture)
				_assetsManager.removeTexture("content_page_" + pageIndex, true);
		}

		/**
		 * 动态加载纹理
		 * @param pageIndex
		 */
		private function loadByPageIndex(pageIndex:int):void
		{
			if (pageIndex < 0 || pageIndex > HandbookScreen.MAX_NUM - 1)
				return;
			_assetsManager.enqueue("assets/global/handbook/content_page_" + pageIndex + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void {
//				if (ratio == 1)
//					trace("资源加载完成");
			});
		}

		public function updateByPage(page:int):void
		{
			if (crtPage == page || page > MAX_NUM - 1 || page < 0)
			{
				dispatchEventWith(BookEvent.ViewUpdateFail);
				return;
			}
			//清除缓存纹理
			_assetsManager.dispose();
			initLoad();
			this.crtPage=page;
			_assetsManager.enqueue("assets/global/handbook/content_page_" + page + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
				{
					if (crtPage > 0)
						_assetsManager.enqueue("assets/global/handbook/content_page_" + String(crtPage - 1) + ".png");
					if (crtPage < HandbookScreen.MAX_NUM - 1)
						_assetsManager.enqueue("assets/global/handbook/content_page_" + String(crtPage + 1) + ".png");
					_assetsManager.loadQueue(function(r:Number):void {});
					updateView();
					removeLoad();
				}
			});
		}

		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cache.texture=_assetsManager.getTexture("content_page_" + crtPage);
			page_0.text=String(crtPage * 2 + 1) + " / " + String(MAX_NUM * 2);
			page_1.text=String(crtPage * 2 + 2) + " / " + String(MAX_NUM * 2);
			dispatchEventWith(BookEvent.ViewUpdated, false, crtPage);

			setSo();
		}

		override public function dispose():void
		{
			if (cache)
				cache.removeFromParent(true);
			if (page_0)
				page_0.removeFromParent(true);
			if (page_1)
				page_1.removeFromParent(true);
			_assetsManager.dispose();
			super.dispose();
		}
	}
}


