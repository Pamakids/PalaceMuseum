package views.global.userCenter.achievement
{
	import flash.geom.Rectangle;
	
	import controllers.DC;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
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
			initList();
		}
		
		private function initPages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		private function layoutFactory():ILayout
		{
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paddingTop = 90;
			layout.paddingLeft = 5;
			layout.horizontalGap = 10;
			layout.verticalGap = 50;
			layout.useVirtualLayout = true;
			layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			return layout;
		}
		
		private var listLeft:List;
		private var listRight:List;
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
			{
				listRight.dataProvider = new ListCollection( datas[1] );
			}
		}
		private function listFactory():List
		{
			var list:List = new List();
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:AchieveRenderer = new AchieveRenderer();
				renderer.data = "achidata";
				renderer.width = 137;
				renderer.height = 106;
				renderer.addEventListener(Event.TRIGGERED, onTriggered);
				return renderer;
			};
			list.layout = layoutFactory();
			return list;
		}
		
		private function onTriggered(e:Event):void
		{
			var data:Object = (e.currentTarget as AchieveRenderer).data;
			showImage(data);
		}
		
		private var image:AchieveIcon;
		private function showImage(data:Object):void
		{
			if(!image)
				image = new AchieveIcon(1);
			image.data = data;
			image.x = 262;
			image.y = 191;
			PopUpManager.addPopUp(image, true, false);
			if( !this.hasEventListener(TouchEvent.TOUCH) )
				image.addEventListener(TouchEvent.TOUCH, hideImage);
		}
		
		private function hideImage(e:TouchEvent):void
		{
			if(e.currentTarget == image)
			{
				var touch:Touch = e.getTouch(stage);
				if(touch && touch.phase == TouchPhase.ENDED && PopUpManager.isPopUp(image) )
						PopUpManager.removePopUp(image);
			}
		}
		
		private var maxNum:int = 9;
		private var datas:Array;
		private function initDatas():void
		{
			datas = [];
			var arr:Array = DC.instance.getAchievementData();
			const max:int = arr.length;
			var tempdatas:Array = [];
			var obj:Object;
			for(var i:int = 0;i<max;i++)
			{
				obj = { id: arr[i][0], achidata: arr[i] };
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
			if(image)
				image.dispose();
			if(listLeft)
				listLeft.removeFromParent(true);
			if(listRight)
				listRight.removeFromParent(true);
			super.dispose();
		}
		
		public function getScreenTexture():Vector.<Texture>
		{
			if(!UserCenterManager.getScreenTexture(UserCenter.ACHIEVEMENT))
				initScreenTextures();
			return UserCenterManager.getScreenTexture(UserCenter.ACHIEVEMENT);
		}
		
		public var viewWidth:Number;
		public var viewHeight:Number;
		
		private function initScreenTextures():void
		{
			if(UserCenterManager.getScreenTexture(UserCenter.ACHIEVEMENT))
				return;
			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			render.draw( this );
			var ts:Vector.<Texture> = new Vector.<Texture>(2);
			ts[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			ts[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			UserCenterManager.setScreenTextures(UserCenter.ACHIEVEMENT, ts);
		}
	}
}

