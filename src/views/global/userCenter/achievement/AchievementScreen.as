package views.global.userCenter.achievement
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
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
			initIcons();
		}
		
		private var vecIcon:Vector.<AchieveIcon>;
		private function initIcons():void
		{
			var icon:AchieveIcon;
			vecIcon = new Vector.<AchieveIcon>(maxNum);
			for(var i:int = 0;i<maxNum;i++)
			{
				icon = new AchieveIcon();
				icon.data = datas[0][i];
				this.addChild( icon );
				icon.x = int( paddingLeft + Math.floor(i/9) * this.viewWidth/2 + (i%3) * (horizontalGap + icon.width) );
				icon.y = int( paddingTop + Math.floor( (i%9)/3 ) * (verticalGap + icon.height) );
				icon.addEventListener(Event.TRIGGERED, onTriggered);
				vecIcon[i] = icon;
			}
		}
		
		private var paddingLeft:int = 20;
		private var paddingTop:int = 90;
		private var horizontalGap:int = 10;
		private var verticalGap:int = 60;
		
		private var selectIcon:AchieveIcon;
		private function onTriggered(e:Event):void
		{
			selectIcon = e.currentTarget as AchieveIcon;
			showImage();
		}
		
		private var image:AchieveIcon;
		private var container:Sprite;
		private var quad:Quad;
		private var scale:Number = .3;
		private var alpha:Number = 0;
		private var imageHeight:int;
		private var imageWidth:int;
		private var point:Point;
		
		private function showImage():void
		{
			if(!image)
			{
				point = globalToLocal(new Point());
				
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
				imageWidth = image.width;
				imageHeight = image.height;
				
			}
			image.data = selectIcon.data;
			container.visible = true;
			
			move = true;
			selectIcon.localToGlobal(new Point(), point);
			const X:int = 1024-imageWidth >> 1;
			const Y:int = 768-imageHeight >> 1;
			
			image.scaleX = image.scaleY = scale;
			image.alpha = alpha;
			image.x = point.x;
			image.y = point.y;
			
			TweenLite.to(image, 0.3, {x: X, y: Y, scaleX: 1, scaleY: 1, alpha: 1, ease:Cubic.easeInOut, onComplete: function():void{ 
				move=false;
			}});
		}
		
		private var move:Boolean =false;
		private function onTouchPop(e:TouchEvent):void
		{
			if(move)
				return;
			var touch:Touch;
			touch = e.getTouch(stage);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				TweenLite.to(image, 0.3, {x: point.x, y:point.y, scaleX: scale, scaleY: scale, alpha: alpha, ease:Cubic.easeOut, onComplete:function():void{
					container.visible = false;
				}});
			}
		}
		
		/**单页显示数量*/		
		private var maxNum:int = 18;
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
			maxPage = pageNum;
		}
		
		public var maxPage:int;
		
		override public function dispose():void
		{
			if(image)
				image.dispose();
			if(quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if(container)
				container.removeFromParent(true);
			for each(var icon:AchieveIcon in vecIcon)
			{
				icon.removeEventListener(Event.TRIGGERED, onTriggered);
				icon.removeFromParent(true);
			}
			super.dispose();
		}
		
		public function updateView(pageIndex:int):void
		{
			var arr:Array;
			for(var i:int = 0;i<maxNum;i++)
			{
				arr = datas[pageIndex];
				vecIcon[i].data = arr[i];
			}
			this.validate();
		}
	}
}

