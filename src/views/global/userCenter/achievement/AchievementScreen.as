package views.global.userCenter.achievement
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class AchievementScreen extends Screen implements IUserCenterScreen
	{
		public function AchievementScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initPages();
			initDatas();
			initLayout();
			initList();
			TweenLite.delayedCall(1, initScreenTextures);
//			initScreenTextures();
		}
		
		private function initPages():void
		{
			var image:Image = new Image(UserCenterManager.assetsManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.assetsManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		private var layout:TiledRowsLayout;
		private function initLayout():void
		{
			layout = new TiledRowsLayout();
			layout.paddingTop = 80;
			layout.paddingLeft = 5;
			layout.horizontalGap = 10;
			layout.verticalGap = 50;
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
			cache = UserCenterManager.assetsManager.getTexture("achievement_card_big");
			showImage();
		}
		
		private function showImage():void
		{
			(!image)?initImage():image.texture = cache;
			image.readjustSize();
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
//					obj.thumbnail = UserCenterManager.assetsManager.getTexture("achievement_card_"+obj.id+"_unfinish");
					obj.thumbnail = UserCenterManager.assetsManager.getTexture("achievement_card_unfinish");
				else
//					obj.thumbnail = UserCenterManager.assetsManager.getTexture("achievement_card_"+obj.id+"_finish");
					obj.thumbnail = UserCenterManager.assetsManager.getTexture("achievement_card_finish");
				datas.unshift( obj );
			}
		}
		
		override public function dispose():void
		{
			if(cache)
				cache.dispose();
			if(container)
				container.dispose();
			container = null;
			datas = null;
			if(image)
				image.dispose();
			image = null;
			if(layout)
				layout = null;
			if(list)
				list.removeFromParent(true)
			list = null;
			if(quad)
				quad.dispose();
			quad = null;
			//			if(screenTexture)
			//				screenTexture = null;
			super.dispose();
		}
		
		private var screenTexture:Vector.<Texture>;
		public function getScreenTexture():Vector.<Texture>
		{
			return screenTexture;
		}
		private var texturesInitialized:Boolean = false;
		public function testTextureInitialized():Boolean
		{
			return texturesInitialized;
		}
		
		public var viewWidth:Number;
		public var viewHeight:Number;
		
		private function initScreenTextures():void
		{
			if(texturesInitialized)
				return;
			screenTexture = new Vector.<Texture>(2);
			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			render.draw( this );
			screenTexture[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			screenTexture[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			texturesInitialized = true;
		}
	}
}

