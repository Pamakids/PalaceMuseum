package views.global.userCenter.collection
{
	import flash.geom.Rectangle;
	
	import controllers.DC;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.PopUpManager;
	import feathers.data.ListCollection;
	import feathers.layout.ILayout;
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
			initList();
		}
		
		private var crtPage:int = 0;
		private var maxNum:int = 9;
		
		private function initPages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		private var listLeft:List;
		private var listRight:List;
		private function listFactory():List
		{
			var list:List = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.iconSourceField = "thumbnail";
				renderer.name = "id";
				renderer.width = 147;
				renderer.height = 155;
				renderer.scaleX = renderer.scaleY = 0.8;
				renderer.addEventListener(Event.TRIGGERED, onTriggered);
				return renderer;
			};
			list.layout = layoutFactory();
			return list;
		}
		
		private function onTriggered(e:Event):void
		{
			trace(e.currentTarget);
			var data:Object = (e.currentTarget as DefaultListItemRenderer).data;
			if(data.finished == 0)		//未收集到
				return;
			cache = UserCenterManager.getTexture(data.id + "_big");
			showImage();
		}
		private function layoutFactory():ILayout
		{
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 90;
			layout.paddingLeft = 10;
			layout.horizontalGap = 15;
			layout.verticalGap = 55;
			layout.useVirtualLayout = true;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			return layout;
		}
		private function initList():void
		{
			listLeft = listFactory();
			listLeft.dataProvider = new ListCollection( datas[0] );
			this.addChild( listLeft );
			listLeft.width = width / 2;
			listLeft.height = height;
			
			listRight = listFactory();
			this.addChild(listRight);
			listRight.width = width / 2;
			listRight.height = height;
			listRight.x = width / 2;
			if(datas.length > 1)
				listRight.dataProvider = new ListCollection( datas[1] );
		}
		
		private var cache:Texture;
		
		private var image:Image;
		private function showImage():void
		{
			(!image)?image = new Image( cache ):image.texture = cache;
			image.x = 1024 - image.width >> 1;
			image.y = 768 - image.height >> 1;
			PopUpManager.addPopUp( image, true, false);
			if( !image.hasEventListener(TouchEvent.TOUCH) )
				image.addEventListener(TouchEvent.TOUCH, hideImage);
		}
		
		private function hideImage(e:TouchEvent):void
		{
			if(e.currentTarget == image)
			{
				var touch:Touch = e.getTouch(stage);
				if(touch && touch.phase == TouchPhase.ENDED && PopUpManager.isPopUp(image))
					PopUpManager.removePopUp( image );
			}
		}
		
		
		private var finishCount:uint = 10;
		private var unfinishCount:uint = 5;
		private var datas:Array;
		private function initDatas():void
		{
			datas = [];
			var arr:Array = DC.instance.getCollectionData();
			const max:int = arr.length;
			var tempdatas:Array = [];
			var obj:Object;
			for(var i:int = 0;i<max;i++)
			{
				obj = { id: arr[i][0], finished: arr[i][1] };
				if(obj.finished == 0)
					obj.thumbnail = UserCenterManager.getTexture("collection_card_unfinish");
				else
					obj.thumbnail = UserCenterManager.getTexture(obj.id);
				tempdatas.push( obj );
			}
			
			//分页处理，每页显示9个数据
			const pageNum:int = Math.ceil( tempdatas.length / maxNum );
			for(i = 0;i<pageNum;i++)
			{
				datas.push( tempdatas.splice(0, maxNum) );
			}
		}
		
		override public function dispose():void
		{
			if(cache)
				cache = null;
			if(image)
				image.removeFromParent(true);
			if(listLeft)
				listLeft.removeFromParent(true);
			if(listRight)
				listRight.removeFromParent(true);
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

