package views.global.books.handbook.screen
{
	import flash.utils.Dictionary;
	
	import assets.global.handbook.BirdAssets;
	
	import feathers.core.PopUpManager;
	
	import models.FontVo;
	import models.SOService;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.components.base.PalaceModule;
	import views.global.books.events.BookEvent;
	import views.global.books.userCenter.screen.BaseScreen;

	/**
	 * 典故
	 * @author Administrator
	 */	
	public class BirdsScreen extends BaseScreen
	{
		public static const MAX_NUM:int=8;

		public function BirdsScreen()
		{
			_assetsManager = new Dictionary();
		}

		private var _assetsManager:Dictionary;
		private var crtPage:int;

		override protected function initialize():void
		{
			initPages()
//			initLoad();
			dispatchEventWith(BookEvent.Initialized);
		}
//		
//		private var load:Image;
//		
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

		/**
		 * 初始化显示，需手动调用
		 */
		public function initView(pageIndex:int):void
		{
			crtPage=pageIndex;
			initTextures();
			initImages();
			initPageNums();
//			removeLoad();
			dispatchEventWith(BookEvent.InitViewPlayed);
		}
		
		
		
		private function initTextures():void
		{
			_assetsManager["bird_uncollection"] = getTexture("birdUn");
			if(ifCollected(crtPage))
				_assetsManager["bird_collection_"+crtPage] = getTexture("bird" + crtPage);
			if(crtPage>0 && ifCollected(crtPage-1))
				_assetsManager["bird_collection_"+(crtPage-1)] = getTexture("bird" + (crtPage-1));
			if(crtPage < MAX_NUM-1 && ifCollected(crtPage+1))
				_assetsManager["bird_collection_"+(crtPage+1)] = getTexture("bird" + (crtPage+1));
		}

		private var cache:Image;

		private function initImages():void
		{
			cache=new Image(ifCollected(crtPage) ? _assetsManager["bird_collection_"+crtPage] : _assetsManager["bird_uncollection"]);
			this.addChild(cache);
			cache.touchable=false;
		}

		private function ifCollected(page:uint):Boolean
		{
			return true;
			return SOService.instance.getSO("birdCatched" + page);
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
		
		private function loadByPageIndex(page:int):void
		{
			if (page < 0 || page > MAX_NUM - 1 || !ifCollected(page))
				return;
			_assetsManager["bird_collection_"+page] = getTexture("bird"+page);
		}
		
		private function clearByPageIndex(page:int):void
		{
			var texture:Texture = _assetsManager["bird_collection_"+page];
			if(texture)
			{
				texture.dispose();
				delete _assetsManager["bird_collection_"+page];
			}
		}

		/**
		 * 更新至指定页
		 * @param page
		 */		
		public function updateByPage(page:int):void
		{
			if (crtPage == page || page > MAX_NUM-1 || page < 0)
			{
				dispatchEventWith(BookEvent.ViewUpdateFail);
				return;
			}
			crtPage = page;
			updateView();
		}
		
		/**
		 * 更新显示内容
		 */
		private function updateView():void
		{
			cache.texture=ifCollected(crtPage) ? _assetsManager["bird_collection_"+crtPage] : _assetsManager["bird_uncollection"];
			page_0.text = String(crtPage*2+1)+" / "+String(MAX_NUM*2);
			page_1.text = String(crtPage*2+2)+" / "+String(MAX_NUM*2);
			dispatchEventWith(BookEvent.ViewUpdated, false, crtPage);
		}

		override public function dispose():void
		{
			if (cache)
				cache.removeFromParent(true);
			if(page_0)
				page_0.removeFromParent(true);
			if(page_1)
				page_1.removeFromParent(true);
			for each(var text:Texture in _assetsManager)
			{
				text.dispose();
			}
			_assetsManager=null;
			super.dispose();
		}

		private function getTexture(name:String):Texture
		{
			return Texture.fromBitmap(new BirdAssets[name]());
		}
	}
}
