package views.module3.scene31
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class FindGame extends PalaceGame
	{
		public function FindGame(am:AssetManager=null)
		{
			super(am);

			drum=getImage("drum");
			drum.x=0;
			drum.y=0;
			drum.scaleX=drum.scaleY=1;
			drum.visible=false;
			addChild(drum);

			flute=getImage("flute");
			flute.x=0;
			flute.y=0;
			flute.scaleX=flute.scaleY=1;
			flute.visible=false;
			addChild(flute);

			bug=getImage("bug");
			bug.x=0;
			bug.y=0;
			addChild(bug);
			bug.addEventListener(TouchEvent.TOUCH, onBugTouch);

			addEventListener(TouchEvent.TOUCH, onTouch);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.visible=closeBtn.touchable=false;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
		}

		private function onBugTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bug, TouchPhase.ENDED);
			if (tc)
			{
				bug.removeEventListener(TouchEvent.TOUCH, onBugTouch);
				playBug(new Point());
			}
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			dispatchEvent(new Event("gameOver"));
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			if (rattleDrumArea.containsPoint(pt))
			{
				playEff(drum, new Point(), .5);
				rattleDrumArea=new Rectangle(-1000, -1000, 0, 0)
			}
			else if (fluteArea.containsPoint(pt))
			{
				playEff(flute, new Point(), .5);
				fluteArea=new Rectangle(-1000, -1000, 0, 0);
			}
		}

		private var rattleDrumArea:Rectangle=new Rectangle();
		private var fluteArea:Rectangle=new Rectangle();

		private function playEff(img:Image, destPos:Point, destScale:Number):void
		{
			img.visible=true;
			TweenLite.to(img, .5, {scaleX: 1, scaleY: 1});
			TweenLite.delayedCall(1, function():void {
				TweenLite.to(img, .5, {scaleX: destScale, scaleY: destScale,
						x: destPos.x, y: destPos.y, onComplete: checkResult});
			});
		}

		private function playBug(destPos:Point):void
		{
			TweenLite.to(bug, .5, {x: 1024, y: 1, ease: Elastic.easeOut});
			TweenLite.delayedCall(1, function():void {
				bug.x=-100;
				bug.y=-100;
				TweenLite.to(bug, .5, {x: destPos.x, y: destPos.y, onComplete: checkResult});
			});
		}

		private var drum:Image;
		private var flute:Image;
		private var bug:Image;

		private function checkResult():void
		{
			checkCount++;
			if (checkCount >= 3)
				closeBtn.visible=closeBtn.touchable=false;
		}

		private var checkCount:int=0;
		private var closeBtn:ElasticButton;
	}
}
