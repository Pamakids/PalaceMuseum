package views.global.userCenter.collection
{
	import flash.geom.Rectangle;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenter;
	import views.global.userCenter.UserCenterManager;
	
	public class CollectionScreen extends Screen implements IUserCenterScreen
	{
		public function CollectionScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initPages();
			initDatas();
			initLayout();
			initList();
//			TweenLite.delayedCall(1, initScreenTextures);
		}
		
		private function initPages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		private var layout:TiledRowsLayout;
		private function initLayout():void
		{
			layout = new TiledRowsLayout();
			layout.paddingTop = 90;
			layout.paddingLeft = 10;
			layout.horizontalGap = 25;
			layout.verticalGap = 55;
			layout.useVirtualLayout = true;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
		}
		
		private var list:List;
		private function initList():void
		{
			list = new List();
			list.dataProvider = new ListCollection( datas );
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.iconSourceField = "thumbnail";
				renderer.name = "id";
				renderer.scaleX = renderer.scaleY = 0.8;
				return renderer;
			};
			list.layout = layout;
			this.addChild( list );
			list.width = width;
			list.height = height;
			list.addEventListener(Event.CHANGE, onChange);
		}
		
		private var cache:Texture;
		private function onChange():void
		{
			var data:Object = datas[list.selectedIndex];
			if(data.finished == 0)		//未收集到
				return;
			cache = UserCenterManager.getTexture("collection_card_big");
			showImage();
		}
		
		private var image:Image;
		private function showImage():void
		{
			(!image)?image = new Image( cache ):image.texture = cache;
			image.readjustSize();
			image.x = 1024 - image.width >> 1;
			image.y = 768 - image.height >> 1;
			if( !this.hasEventListener(TouchEvent.TOUCH) )
				this.addEventListener(TouchEvent.TOUCH, hideImage);
			PopUpManager.addPopUp( image, true, false);
		}
		
		private function hideImage(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED && PopUpManager.isPopUp(image) )
					PopUpManager.removePopUp( image );
			}
		}
		
		
		private var finishCount:uint = 10;
		private var unfinishCount:uint = 5;
		private var datas:Array;
		private function initDatas():void
		{
			/*	数据格式
			[
			[成就id， 是否开启(0 未达成，1达成)],
			[成就id， 是否开启],
			[成就id， 是否开启],
			[成就id， 是否开启],
			[成就id， 是否达成],
			...
			]
			*/
			datas = [];
			//			var arr:Array = UserCenterManager.getDatas(UserCenter.ACHIEVEMENT);
			//test
			var arr:Array = [
				[0, 0],
				[1, 1],
				[2, 1],
				[3, 1],
				[4, 1],
				[5, 0],
				[6, 1],
				[7, 0],
				[8, 0],
				[9, 1],
				[10, 1],
				[11, 1],
				[12, 0],
				[13, 0],
				[14, 0]
			];
			var obj:Object;
			for(var i:int = arr.length-1;i>=0;i--)
			{
				obj = {};
				obj.id = arr[i][0];
				obj.finished = arr[i][1];
				if(obj.finished == 0)
					//					obj.thumbnail = UserCenterManager.getTexture("achievement_card_"+obj.id+"_unfinish");
					obj.thumbnail = UserCenterManager.getTexture("collection_card_unfinish");
				else
					//					obj.thumbnail = UserCenterManager.getTexture("achievement_card_"+obj.id+"_finish");
					obj.thumbnail = UserCenterManager.getTexture("collection_card_finish");
				datas.unshift( obj );
			}
		}
		
		override public function dispose():void
		{
			if(cache)
				cache.dispose();
			datas = null;
			if(image)
				image.dispose();
			image = null;
			if(layout)
				layout = null;
			if(list)
				list.removeFromParent(true)
			list = null;
//			if(screenTexture)
//				screenTexture = null;
			super.dispose();
		}
		
		public function getScreenTexture():Vector.<Texture>
		{
			if(!UserCenterManager.getScreenTexture(UserCenter.COLLECTION))
				initScreenTextures();
			return UserCenterManager.getScreenTexture(UserCenter.COLLECTION);
		}
		
		public var viewWidth:Number;
		public var viewHeight:Number;
		
		private function initScreenTextures():void
		{
			if(UserCenterManager.getScreenTexture(UserCenter.COLLECTION))
				return;
			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			render.draw( this );
			var ts:Vector.<Texture> = new Vector.<Texture>(2);
			ts[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			ts[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			UserCenterManager.setScreenTextures(UserCenter.COLLECTION, ts);
		}
	}
}

