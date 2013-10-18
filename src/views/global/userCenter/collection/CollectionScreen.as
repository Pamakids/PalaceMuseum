package views.global.userCenter.collection
{
	import flash.geom.Point;
	
	import controllers.DC;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.ILayout;
	import feathers.layout.TiledRowsLayout;
	
	import models.CollectionVO;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class CollectionScreen extends BaseScreen
	{
		public function CollectionScreen()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			initDatas();
			initList();
		}
		
		private var crtPage:int = 0;
		private var maxNum:int = 6;
		
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
			var i:int = int((e.currentTarget as DefaultListItemRenderer).data.id);
			selectedVo = source[i];
			showImage();
		}
		private function layoutFactory():ILayout
		{
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 150;
			layout.paddingLeft = 10;
			layout.horizontalGap = 15;
			layout.verticalGap = 90;
			layout.useVirtualLayout = true;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			return layout;
		}
		private function initList():void
		{
			listLeft = listFactory();
			listLeft.dataProvider = new ListCollection( pageDatas[0] );
			this.addChild( listLeft );
			listLeft.width = width / 2;
			listLeft.height = height;
			
			listRight = listFactory();
			this.addChild(listRight);
			listRight.width = width / 2;
			listRight.height = height;
			listRight.x = width / 2;
			listRight.dataProvider = new ListCollection( pageDatas[1] );
		}
		
		private var card:CollectionShow;
		private var container:Sprite;
		private var quad:Quad;
		private var selectedVo:CollectionVO;
		private function showImage():void
		{
			if(!card)
			{
				var point:Point = globalToLocal(new Point());
				container = new Sprite();
				this.addChild( container );
				container.x = point.x;
				container.y = point.y;
				
				quad = new Quad(1024, 768, 0x000000);
				quad.alpha = .4;
				container.addChild( quad );
				quad.addEventListener(TouchEvent.TOUCH, onTouchPop);
				
				card = new CollectionShow();
				card.x = 1024  >> 1;
				card.y = 768 - card.height >> 1;
				container.addChild( card );
			}
			card.resetData(selectedVo);
			container.visible = true;
		}
		
		private function onTouchPop(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				container.visible = false;
			}
		}
		
		private var finishCount:uint = 10;
		private var unfinishCount:uint = 5;
		private var source:Vector.<CollectionVO>;
		private function initDatas():void
		{
			var arr:Array = UserCenterManager.getAssetsManager().getObject("collection").source;
			const max:int = arr.length;
			source = new Vector.<CollectionVO>(max);
			var vo:CollectionVO;
			for(var i:int = 0;i<max;i ++)
			{
				vo = new CollectionVO();
				vo.id = i.toString();
				vo.name = arr[i].name;
				vo.content = arr[i].content;
				vo.explain = arr[i].explain;
				vo.isCollected = DC.instance.testCollectionIsOpend(vo.id);
				source[i] = vo;
			}
			
			//list数据源
			var tempdatas:Array = [];
			var obj:Object;
			for(i = 0;i<max;i++)
			{
				obj = { id: source[i].id, finished: source[i].isCollected };
				if(!obj.finished)
					obj.thumbnail = UserCenterManager.getTexture("card_collection_unfinish");
				else
					obj.thumbnail = UserCenterManager.getTexture("card_collection_" + obj.id);
				tempdatas.push( obj );
			}
			
			//分页处理
			pageDatas = [];
			const pageNum:int = Math.ceil(max / maxNum );
			for(i = 0;i<pageNum;i++)
			{
				pageDatas.push( tempdatas.splice(0, maxNum) );
			}
		}
		private var pageDatas:Array;
		
		override public function dispose():void
		{
			if(card)
				card.removeFromParent(true);
			if(quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if(container)
				container.removeFromParent(true);
			if(listLeft)
				listLeft.removeFromParent(true);
			if(listRight)
				listRight.removeFromParent(true);
			super.dispose();
		}
		
	}
}

