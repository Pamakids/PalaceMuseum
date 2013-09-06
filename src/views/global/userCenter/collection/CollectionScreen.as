package views.global.userCenter.collection
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class CollectionScreen extends Screen implements IUserCenterScreen
	{
		public function CollectionScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initDatas();
			initLayout();
			initList();
		}
		
		private var layout:TiledRowsLayout;
		private function initLayout():void
		{
			layout = new TiledRowsLayout();
			layout.paddingTop = 65;
			layout.paddingLeft = 20;
			layout.horizontalGap = 10;
			layout.verticalGap = 40;
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
				renderer.scaleX = renderer.scaleY = 0.35;
				return renderer;
			};
			list.layout = layout;
			this.addChild( list );
			list.width = 940;
			list.height = 696;
			list.addEventListener(Event.CHANGE, onChange);
		}
		
		private var cache:Texture;
		private function onChange():void
		{
			cache = datas[list.selectedIndex].thumbnail;
			showImage();
		}
		
		private function showImage():void
		{
			(!image)?initImage():image.texture = cache;
			image.width = cache.width;
			image.height = cache.height;
			image.x = this.container.width - image.width >> 1;
			image.y = this.container.height - image.height >> 1;
			this.container.visible =true;
		}
		
		private var image:Image;
		private function initImage():void
		{
			initContainer();
			initMask();
			image = new Image( cache );
			this.container.addChild( image );
		}
		
		private var container:Sprite;
		private function initContainer():void
		{
			container = new Sprite();
			this.addChild(container);

			var point:Point = globalToLocal(new Point());
			container.x = point.x;
			container.y = point.y;
			
			container.addEventListener(TouchEvent.TOUCH, hideContainer);
		}
		
		private function hideContainer(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(container);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
					container.visible =false;
			}
		}
		
		private var quad:Quad;
		private function initMask():void
		{
			quad = new Quad(stage.stageWidth, stage.stageHeight, 0x000000, true);
			quad.alpha = .4;
			this.container.addChild( quad );
		}
		
		private var finishCount:uint = 10;
		private var unfinishCount:uint = 5;
		private var datas:Array;
		private function initDatas():void
		{
			datas = [];
			for(var i:int = 0; i<finishCount; i++)
			{
				datas.push( {thumbnail: UserCenterManager.assetsManager.getTexture("collection_card_finish")} );
			};
			for(i=0;i<unfinishCount;i++)
			{
				datas.push( {thumbnail: UserCenterManager.assetsManager.getTexture("collection_card_unfinish")} );
			};
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		private var screenTexture:Vector.<Texture>;
		public function getScreenTexture():Vector.<Texture>
		{
			if(!screenTexture)
			{
				screenTexture = new Vector.<Texture>(2);
			}
			return screenTexture;
		}
		private var texturesInitialized:Boolean = false;
		public function testTextureInitialized():Boolean
		{
			return texturesInitialized;
		}
	}
}