package views.global.userCenter.achievement
{
	import controllers.DC;
	
	import feathers.core.PopUpManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class AchievementScreen extends BaseScreen
	{
		public function AchievementScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			initPages();
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
		
		private function initPages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
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
			containerL.removeFromParent(true);
			containerR.removeFromParent(true);
			if(image)
				image.dispose();
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

