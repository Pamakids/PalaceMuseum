package views.global.books.userCenter.screen
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;

	import controllers.DC;

	import models.FontVo;
	import models.PosVO;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	import views.global.books.BooksManager;
	import views.global.books.components.AchieveIcon;
	import views.global.books.events.BookEvent;

	public class AchievementScreen extends BaseScreen
	{
		public function AchievementScreen()
		{
		}

		override protected function initialize():void
		{
			initPages();
			initDatas();
			initIcons();
			initPageNums();

			TweenLite.delayedCall(0.1, dispatchEventWith, [BookEvent.InitViewPlayed]);
		}

		override protected function initPages():void
		{
			var image:Image=BooksManager.getImage("background_2");
			this.addChild(image);
		}

		/**单页显示数量*/
		private var maxNum:int=18;
		private var datas:Array;

		private function initDatas():void
		{
			datas=[];
			var arr:Array=DC.instance.getAchievementData();
			const max:int=arr.length;
			var tempdatas:Array=[];
			var obj:Object;
			for (var i:int=0; i < max; i++)
			{
				obj={id: arr[i][0], achidata: arr[i]};
				tempdatas.push(obj);
			}

			//分页处理，每页显示9个数据
			const pageNum:int=Math.ceil(tempdatas.length / maxNum);
			for (i=0; i < pageNum; i++)
			{
				datas.push(tempdatas.splice(0, maxNum));
			}
			pageCount=pageNum;
		}
		private var page_0:TextField;
		private var page_1:TextField;

		private function initPageNums():void
		{
			var n:int=pageCount * 2;
			page_0=new TextField(100, 40, "1 / " + n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_1=new TextField(100, 40, "2 / " + n.toString(), FontVo.PALACE_FONT, 22, 0x932720);
			page_0.touchable=page_1.touchable=false;
			page_0.x=196;
			page_1.x=680;
			page_0.y=page_1.y=590;
			this.addChild(page_0);
			this.addChild(page_1);
		}

		private var vecIcon:Vector.<AchieveIcon>;

		private function initIcons():void
		{
			var icon:AchieveIcon;
			vecIcon=new Vector.<AchieveIcon>(maxNum);
			for (var i:int=0; i < maxNum; i++)
			{
				icon=new AchieveIcon();
				icon.data=datas[0][i];
				this.addChild(icon);
				icon.x=int(paddingLeft + Math.floor(i / 9) * this.viewWidth / 2 + (i % 3) * (horizontalGap + icon.width));
				icon.y=int(paddingTop + Math.floor((i % 9) / 3) * (verticalGap + icon.height));
				icon.addEventListener(Event.TRIGGERED, onTriggered);
				vecIcon[i]=icon;
			}
		}

		private var paddingLeft:int=20;
		private var paddingTop:int=90;
		private var horizontalGap:int=10;
		private var verticalGap:int=60;

		private var selectIcon:AchieveIcon;

		private function onTriggered(e:Event):void
		{
			selectIcon=e.currentTarget as AchieveIcon;
			showImage();
		}

		private var image:AchieveIcon;
		private var container:Sprite;
		private var quad:Quad;
		private var scale:Number=.3;
		private var alpha:Number=0;
		private var imageHeight:int=386;
		private var imageWidth:int=500;
		private var beginX:int;
		private var beginY:int;
		private var targetX:int;
		private var targetY:int;

		private function showImage():void
		{
			if (!image)
			{
				var point:Point=globalToLocal(new Point());
				container=new Sprite();
				this.addChild(container);
				container.x=point.x;
				container.y=point.y;

				quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				container.addChild(quad);
				quad.addEventListener(TouchEvent.TOUCH, onTouchPop);

				image=new AchieveIcon(1);
				container.addChild(image);
			}
			image.data=selectIcon.data;
			container.visible=true;

			move=true;
			beginX=selectIcon.x + 28;
			beginY=selectIcon.y + 89;
			targetX=1024 - imageWidth >> 1;
			targetY=768 - imageHeight >> 1;

			image.scaleX=image.scaleY=scale;
			image.alpha=alpha;
			image.x=beginX;
			image.y=beginY;

			TweenLite.to(image, 0.3, {x: targetX, y: targetY, scaleX: 1, scaleY: 1, alpha: 1, ease: Cubic.easeInOut, onComplete: function():void {
				move=false;
			}});
		}

		private var move:Boolean=false;

		private function onTouchPop(e:TouchEvent):void
		{
			if (move)
				return;
			var touch:Touch;
			touch=e.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				TweenLite.to(image, 0.3, {x: beginX, y: beginY, scaleX: scale, scaleY: scale, alpha: alpha, ease: Cubic.easeOut, onComplete: function():void {
					container.visible=false;
				}});
			}
		}

		//页数
		private var pageCount:int;

		override public function dispose():void
		{
			if (image)
				image.dispose();
			if (quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if (page_0)
				page_0.removeFromParent(true);
			if (page_1)
				page_1.removeFromParent(true);
			if (container)
				container.removeFromParent(true);
			for each (var icon:AchieveIcon in vecIcon)
			{
				icon.removeEventListener(Event.TRIGGERED, onTriggered);
				icon.removeFromParent(true);
			}
			super.dispose();
		}
		private var crtPage:int=0;

		/**
		 * 上翻一页，翻页失败会派发UserCenter.ViewUpdateFail事件
		 */
		public function pageUp():void
		{
			if (crtPage <= 0)
			{
				dispatchEventWith(BookEvent.ViewUpdateFail);
				trace("更新失败");
				return;
			}
			crtPage-=1;
			updateView();
		}

		/**
		 * 下翻一页，翻页失败会派发UserCenter.ViewUpdateFail事件
		 */
		public function pageDown():void
		{
			if (crtPage >= pageCount - 1)
			{
				dispatchEventWith(BookEvent.ViewUpdateFail, true);
				return;
			}
			crtPage+=1;
			updateView();
		}

		private function updateView():void
		{
			var arr:Array=datas[crtPage];
			for (var i:int=0; i < maxNum; i++)
			{
				vecIcon[i].data=arr[i];
			}
			page_0.text=(crtPage * 2 + 1).toString() + " / " + String(pageCount * 2);
			page_1.text=(crtPage * 2 + 2).toString() + " / " + String(pageCount * 2);
			this.validate();
			TweenLite.delayedCall(0.1, dispatchEventWith, [BookEvent.ViewUpdated]);
		}
	}
}

