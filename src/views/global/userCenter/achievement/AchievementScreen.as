package views.global.userCenter.achievement
{
	import flash.geom.Point;
	
	import controllers.DC;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import views.global.userCenter.BaseScreen;
	
	public class AchievementScreen extends BaseScreen
	{
		public function AchievementScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			initDatas();
			initContainer();
			initIcons();
		}
		
		private function initIcons():void
		{
			for(var i:int = 0;i<maxNum;i++)
			{
				var iconL:AchieveIcon = iconFactory(i)
				var iconR:AchieveIcon = iconFactory(i, false)
			}
		}
		private function iconFactory(index:int, left:Boolean=true):AchieveIcon
		{
			var icon:AchieveIcon = new AchieveIcon();
			icon.data = left?datas[0][index]:((datas[1])?datas[1][index]:null);
			left?containerL.addChild(icon):containerR.addChild( icon );
			icon.x = 20 + (icon.width + 10)*(index%3);
			icon.y = 90 + (icon.height + 60) * Math.floor( index/3 );
			icon.addEventListener(Event.TRIGGERED, onTriggered);
			return icon;
		}
		
		private function onTriggered(e:Event):void
		{
			showImage((e.currentTarget as AchieveIcon).data);
		}
		
		private function initContainer():void
		{
			containerL = new Sprite();
			this.addChild( containerL );
			
			containerR = new Sprite();
			containerR.x = viewWidth / 2;
			this.addChild( containerR );
		}
		
		private var containerL:Sprite;
		private var containerR:Sprite;
		
		private var image:AchieveIcon;
		private var container:Sprite;
		private var quad:Quad;
		private function showImage(data:Object):void
		{
			if(!image)
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
				
				image = new AchieveIcon(1);
				container.addChild( image );
				image.x = 1024 - image.width  >> 1;
				image.y = 768 - image.height >> 1;
			}
			image.data = data;
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
		
		/**单页显示数量*/		
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
			
			this.maxPage = Math.ceil( datas.length/2 );
		}
		
		override public function dispose():void
		{
			if(containerL)
				containerL.removeFromParent(true);
			if(containerR)
				containerR.removeFromParent(true);
			if(image)
				image.dispose();
			if(quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if(container)
				container.removeFromParent(true);
			super.dispose();
		}
		
		public var maxPage:int;
		public function updateView(pageIndex:int):void
		{
			var arr:Array;
			for(var i:int = 0;i<maxNum;i++)
			{
				arr = datas[pageIndex*2];
				(containerL.getChildAt(i) as AchieveIcon).data = arr[i];
				
				arr = datas[pageIndex*2+1];
				(containerR.getChildAt(i) as AchieveIcon).data = (arr)?arr[i]:null;
			}
			this.validate();
		}
	}
}

