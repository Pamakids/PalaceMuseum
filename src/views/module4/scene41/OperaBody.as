package views.module4.scene41
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class OperaBody extends Sprite
	{
		public var index:int;
		public var type:String;

		public var enterPt:Point;
		public var stagePt:Point;
		public var offsetsXY:Point;
		public var maskPos:Point;

		public function OperaBody()
		{
			super();
		}

		private var headHolder:Sprite=new Sprite();
		public var head:Image;
		public var body:Image;
		public var countBG:Image;

		public function reset():void
		{
			headHolder.pivotX=head.width >> 1;
			headHolder.pivotY=head.height;

			body.pivotX=headHolder.pivotX - offsetsXY.x;
			body.pivotY=headHolder.pivotY - offsetsXY.y;

			addChild(body);
			addChild(headHolder);
			headHolder.addChild(head);

			startShakeHead(Math.PI / 20, 5);
			startShakeBody(Math.PI / 30, 5);

			enterPt=new Point(stagePt.x, -300);
			this.x=enterPt.x;
			this.y=enterPt.y;

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function addCountDown():void
		{
			countBG.x=25;
			countBG.y=8;
			addChild(countBG);
			countBG.touchable=false;

			countDownTxt=new TextField(countBG.width, countBG.height, "8", FontVo.PALACE_FONT, 24, 0x5d2025);
			countDownTxt.x=countBG.x;
			countDownTxt.y=countBG.y;
			addChild(countDownTxt);
			countBG.touchable=false;
		}

		private var count:int=0;
		private var reverse:Boolean;
		private var headAngle:Number=0;
		private var bodyAngle:Number=0;
		private var dh:Number=0;
		private var db:Number=0;

		public function shake():void
		{
			if (count <= 0)
				reverse=false;
			else if (count >= 9)
				reverse=true;

			count+=reverse ? -1 : 1;

			if (headAngle == bodyAngle == 0)
				count == 5

			headHolder.rotation=headAngle * (count - 5) / 5;
			body.rotation=bodyAngle * (5 - count) / 5;

			headAngle=Math.max(0, headAngle - dh);
			bodyAngle=Math.max(0, bodyAngle - db);

			if (ready && !dragging && swingAngle != 0)
			{
				if (swingCount <= 0)
					swingReverse=false;
				else if (swingCount >= 29)
					swingReverse=true;

				swingCount+=swingReverse ? -1 : 1;

				if (swingAngle == 0)
					swingCount == 0
				angle=swingAngle * (swingCount - 15) / 15;
				swingAngle=Math.max(0, swingAngle - ds);
			}
		}

		private var dragging:Boolean=false;
		private var swingCount:Number=0;
		private var swingReverse:Boolean;
		private var swingAngle:Number=0;
		private var ds:Number=0;

		private function swing(value:Number, sec:Number):void
		{
			swingCount=value > 0 ? 29 : 0;
			swingReverse=value > 0;
			swingAngle=Math.abs(value);
			ds=swingAngle / (sec * 30);
		}

		public function startShakeHead(value:Number, sec:Number):void
		{
			headAngle=value;
			dh=headAngle / (sec * 30);
		}

		public function startShakeBody(value:Number, sec:Number):void
		{
			bodyAngle=value;
			db=bodyAngle / (sec * 30);

		}

		public function playEnter():void
		{
			var dur:Number=playDur * (stagePt.y - enterPt.y) / 1024;
			TweenLite.to(this, dur, {x: stagePt.x, y: stagePt.y, ease: Bounce.easeOut, onComplete: function():void {
				addCountDown();
				ready=true;
			}});
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(stage);

			var dx:Number=pt.x / DPIUtil.getDPIScale() - stagePt.x
			var maxDX:Number=Math.min(Math.abs(dx), stagePt.y / 2);
			var dy:Number=stagePt.y * stagePt.y - maxDX * maxDX;
			var _rot:Number=Math.atan2(maxDX, stagePt.y);
			var min:Number=Math.min(Math.PI / 12, Math.abs(_rot));

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dragging=true;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (ready && dragging)
						angle=dx > 0 ? min : -min;
					break;
				}

				case TouchPhase.ENDED:
				{
					_rot=dx > 0 ? min : -min;
					swing(_rot, 5);
					dragging=false;
					startShakeHead(Math.PI / 20, 3);
					startShakeBody(Math.PI / 30, 3);
					break;
				}

				default:
				{
					break;
				}
			}
		}

		public function playExit(callback:Function=null):void
		{
			ready=false;
			var dur:Number=playDur * (stagePt.y - enterPt.y) / 1024;
			TweenLite.to(this, dur, {x: enterPt.x, y: enterPt.y, ease: Bounce.easeIn, onComplete: callback});
		}

		private static var playDur:Number=1.5;
		public var isMatched:Boolean;
		public var ready:Boolean;
		private var downPt:Point;
		private var _angle:Number;

		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle=value;
			x=stagePt.x + stagePt.y * Math.sin(value);
			y=stagePt.y * Math.cos(value);
		}


		public function addMask(mask:OperaMask):void
		{
//			var pt:Point=globalToLocal(new Point(mask.x, mask.y));
			isMatched=true;
			removeEventListener(TouchEvent.TOUCH, onTouch);
			headHolder.addChild(mask);
			mask.scaleX=mask.scaleY=1;
			mask.pivotX=mask.pivotY=0;
			mask.x=maskPos.x;
			mask.y=maskPos.y;
			startShakeHead(Math.PI / 18, 2);
		}

		public var timeCount:int=240;

		private var countDownTxt:TextField;

		public function countDown():void
		{
			if (ready && countDownTxt && !isMatched)
			{
				timeCount--;
				countDownTxt.text=Math.round(timeCount / 30).toString();
			}
		}
	}
}
