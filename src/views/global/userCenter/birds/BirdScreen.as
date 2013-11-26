package views.global.userCenter.birds
{
	import assets.global.userCenter.BirdAssets;
	
	import models.FontVo;
	import models.SOService;
	
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenter;

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
//			initLoad();
			dispatchEventWith(UserCenter.Initialized);
		}
		
		private var page_0:TextField;
		private var page_1:TextField;
		private function initPageNums():void
		{
			var n:int = MAX_NUM * 2;
			page_0 = new TextField(100, 40, String(crtPage*2+1)+" / "+n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_1 = new TextField(100, 40, String(crtPage*2+2)+" / "+n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_0.touchable = page_1.touchable = false;
			page_0.x = 196;
			page_1.x = 680;
			page_0.y = page_1.y = 590;
			this.addChild( page_0 );
			this.addChild( page_1 );
		}

//		private var load:Image;

//		private function initLoad():void
//		{
//			load=new Image(Texture.fromBitmap(new PalaceModule.loading()));
//			load.pivotX=load.width >> 1;
//			load.pivotY=load.height >> 1;
//			load.x=1024 - 100;
//			load.y=768 - 100;
//			load.scaleX=load.scaleY=.5;
//			PopUpManager.addPopUp(load);
//			load.addEventListener(Event.ENTER_FRAME, function(e:Event):void
//			{
//				load.rotation+=0.2;
//			});
//		}

//		private function removeLoad():void
//		{
//			if (PopUpManager.isPopUp(load))
//				PopUpManager.removePopUp(load, true);
//		}

		/**
		 * 初始化显示，需手动调用
		 */
		public function initView(pageIndex:int):void
		{
			crtPage=pageIndex;
			initImages();
			initPageNums();
			dispatchEventWith(UserCenter.InitViewPlayed);
//			_assetsManager.enqueue( 
//				"assets/global/userCenter/bird_collection_" + crtPage + ".png",
//				"assets/global/userCenter/bird_uncollection.png");
//			_assetsManager.loadQueue(function(ratio:Number):void {
//				if (ratio == 1)
//				{
//					if (crtPage > 0)
//						_assetsManager.enqueue(	"assets/global/userCenter/bird_collection_" + String(crtPage - 1) + ".png");
//					if (crtPage < BirdScreen.MAX_NUM - 1)
//						_assetsManager.enqueue(	"assets/global/userCenter/bird_collection_" + String(crtPage + 1) + ".png");
//					_assetsManager.loadQueue(function(r:Number):void {});
//					initImages();
//					removeLoad();
//					dispatchEventWith(UserCenter.InitViewPlayed);
//					
//				}
//			});
		}


		private var cache:Image;

		private function initImages():void
		{
			cache=new Image(ifCollected(crtPage) ? getTexture("bird" + crtPage) : getTexture("birdUn"));
			this.addChild(cache);
			cache.touchable=false;
		}

		private function ifCollected(page:uint):Boolean
		{
			return SOService.instance.getSO("birdCatched" + page);
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
//			loadByPageIndex(crtPage - 2);
//			clearByPageIndex(crtPage + 1);
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
//			clearByPageIndex(crtPage - 1);
//			loadByPageIndex(crtPage + 2);
			this.crtPage+=1;
			updateView();
		}

		/**
		 * 清除纹理以释放资源
		 * @param pageIndex
		 */
//		private function clearByPageIndex(pageIndex:int):void
//		{
//			var texture:Texture=_assetsManager.getTexture("content_page_" + pageIndex);
//			if (texture)
//				_assetsManager.removeTexture(name, true);
//		}

		/**
		 * 动态加载纹理
		 * @param pageIndex
		 */
//		private function loadByPageIndex(pageIndex:int):void
//		{
//			if (pageIndex < 0 || pageIndex > HandbookScreen.MAX_NUM - 1)
//				return;
//			_assetsManager.enqueue( "assets/global/userCenter/bird_collection_" + pageIndex + ".png");
//			_assetsManager.loadQueue(function(ratio:Number):void{});
//		}

		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cache.texture=ifCollected(crtPage) ? getTexture("bird" + crtPage) : getTexture("birdUn");
			page_0.text = String(crtPage*2+1)+" / "+String(MAX_NUM*2);
			page_1.text = String(crtPage*2+2)+" / "+String(MAX_NUM*2);
			dispatchEventWith(UserCenter.ViewUpdated);
		}

		override public function dispose():void
		{
			if (cache)
				cache.removeFromParent(true);
			if(page_0)
				page_0.removeFromParent(true);
			if(page_1)
				page_1.removeFromParent(true);
			_assetsManager.dispose();
			super.dispose();
		}

		private function getTexture(name:String):Texture
		{
			return Texture.fromBitmap(new BirdAssets[name]());
		}
	}
}
