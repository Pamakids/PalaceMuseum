package views.global.userCenter.birds
{
	import feathers.core.PopUpManager;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.components.base.PalaceModule;
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenter;
	import views.global.userCenter.handbook.HandbookScreen;
	
	public class BirdScreen extends BaseScreen
	{
		public static const MAX_NUM:int=8;
		
		public function BirdScreen()
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
				"assets/global/userCenter/bird_collection_" + crtPage + ".png",
				"assets/global/userCenter/bird_uncollection.png");
			_assetsManager.loadQueue(function(ratio:Number):void {
				if (ratio == 1)
				{
					if (crtPage > 0)
						_assetsManager.enqueue(	"assets/global/userCenter/bird_collection_" + String(crtPage - 1) + ".png");
					if (crtPage < BirdScreen.MAX_NUM - 1)
						_assetsManager.enqueue(	"assets/global/userCenter/bird_collection_" + String(crtPage + 1) + ".png");
					_assetsManager.loadQueue(function(r:Number):void {});
					initImages();
					removeLoad();
					dispatchEventWith(UserCenter.InitViewPlayed);
					
				}
			});
		}
		
		
		private var cache:Image;
		
		private function initImages():void
		{
			cache = new Image( ifCollected(crtPage) ? 
				_assetsManager.getTexture("bird_collection_" + crtPage) : 
				_assetsManager.getTexture("bird_uncollection") );
			this.addChild(cache);
			cache.touchable=false;
		}
		
		private function ifCollected(page:uint):Boolean
		{
			return true;
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
			var texture:Texture=_assetsManager.getTexture("content_page_" + pageIndex);
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
			_assetsManager.enqueue( "assets/global/userCenter/bird_collection_" + pageIndex + ".png");
			_assetsManager.loadQueue(function(ratio:Number):void{});
		}
		
		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cache.texture = _assetsManager.getTexture( (ifCollected(crtPage) ? "bird_collection_" + crtPage : "bird_uncollection"));
			dispatchEventWith(UserCenter.ViewUpdated);
		}
		
		override public function dispose():void
		{
			if (cache)
				cache.removeFromParent(true);
			_assetsManager.dispose();
		}
	}
}