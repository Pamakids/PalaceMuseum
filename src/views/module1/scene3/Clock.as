package views.module1.scene3
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	public class Clock extends PalaceScene
	{
		private var hour:Image;

		private var min:Image;
		private var laceArr:Array=[];
		private var wordArr:Array=[];

		private var mask:Image;
		private var scale:Number;

		public function Clock(am:AssetManager)
		{
			super(am);


			scale=DPIUtil.getDPIScale();
			var bg:Image=getImage("clock-bg");
			addChild(bg);

			var hint:Image=getImage("clock-hint");
			addChild(hint);
			hint.x=129;
			hint.y=80;

			addClock();
			addWheel();

			var flace:Image=getImage("clock-frontlace");
			flace.x=189;
			flace.y=374;
			addChild(flace);

			close=getImage("clock-close");
			close.x=830;
			addChild(close);
			close.addEventListener(TouchEvent.TOUCH, onCloseTouch);

			if (SOService.instance.checkHintCount(clockHint))
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private var clockHint:String="clockhintCount";
		private var count:int=0;

		private function onEnterFrame(e:Event):void
		{
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (count < 30 * 8)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintFinger=getImage("clockhintfinger");
					var hintArrow:Image=getImage("clockhintarrow");
					hintArrow.x=455;
					hintArrow.y=320;
					hintFinger.x=535;
					hintFinger.y=410;
					hintShow.addChild(hintArrow);
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.x == 435)
					{
						hintFinger.scaleX=hintFinger.scaleY=1;
					}
					else if (hintFinger.x == 535)
					{
						hintFinger.scaleX=hintFinger.scaleY=.8;
					}
					hintFinger.x+=hintFinger.scaleX == 1 ? 5 : -5;
				}
			}
		}

		private function onCloseTouch(e:TouchEvent):void
		{
			if (ended)
				return;
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (!tc)
				return;
			PopUpManager.removePopUp(this, true);
		}

		override public function dispose():void
		{
			this.assets=null;
			removeChildren();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage);
			if (!tc || ended)
				return;
			var pt:Point=tc.getLocation(this);
			if (hotarea.containsPoint(pt))
			{

				switch (tc.phase)
				{
					case TouchPhase.BEGAN:
					{
						isDown=true;
						break;
					}

					case TouchPhase.MOVED:
					{
						if (isDown)
						{
							var delta:int=tc.getMovement(this).x;
							if (delta < 0)
							{
								isMoved=true;
								crtTime-=delta;
								for (var i:int=0; i < laceArr.length; i++)
								{
									var img:Image=laceArr[i] as Image;
									img.x+=delta / 3;
									if (img.x < -LACE_WIDTH)
										img.x=3 * LACE_WIDTH + img.x;
								}

								for (var j:int=0; j < wordArr.length; j++)
								{
									var img1:Image=wordArr[j] as Image;
									img1.x+=delta / 2;
									if (img1.x < -WORD_WIDTH)
										img1.x=2 * WORD_WIDTH + img1.x;
								}
							}
						}
						break;
					}

					case TouchPhase.ENDED:
					{
						isDown=false;
						break;
					}

					default:
					{
						break;
					}
				}
			}
		}

		private var hotarea:Rectangle=new Rectangle(283, 318, 435, 188);
		private var _crtTime:int;
		private var isDown:Boolean;
		private var ended:Boolean;

		private var clock:Sprite;

		public function get crtTime():int
		{
			return _crtTime;
		}

		public function set crtTime(value:int):void
		{
			_crtTime=value;
			if (_crtTime < 1800)
			{
				min.rotation=Math.PI / 180 * (_crtTime);
				hour.rotation=Math.PI / 180 * (_crtTime / 12);
			}
			else
			{
				min.rotation=Math.PI / 180 * (1800);
				hour.rotation=Math.PI / 180 * (1800 / 12);
				ended=true;

				TweenLite.to(clock, 1, {scaleX: 1.5, scaleY: 1.5, onComplete: function():void
				{
					TweenLite.to(clock, 1, {scaleX: 1, scaleY: 1});
				}});
				TweenLite.delayedCall(2, function():void
				{
					dispatchEvent(new Event("clockMatch"));
				});
			}
		}

		private function addWheel():void
		{
			var wheel:Sprite=new Sprite();
			wheel.x=438;
			wheel.y=315;
			addChild(wheel);
			wheel.clipRect=new Rectangle(2, 0, 129, 182);

			for (var i:int=0; i < 6; i++)
			{
				var lace:Image=getImage("clock-lace");
				lace.x=i % 3 * LACE_WIDTH;
				lace.y=i < 3 ? 0 : 143;
				wheel.addChild(lace);
				laceArr.push(lace);
			}

			for (var j:int=0; j < 2; j++)
			{
				var word:Image=getImage("clock-word");
				word.x=j * WORD_WIDTH;
				word.y=37;
				wheel.addChild(word);
				wordArr.push(word);
			}

			mask=getImage("clock-mask");
			wheel.addChild(mask);

		}

		private const LACE_WIDTH:int=72;
		private const WORD_WIDTH:int=484;

		private var close:Image;
		private var _isMoved:Boolean;

		public function get isMoved():Boolean
		{
			return _isMoved;
		}

		public function set isMoved(value:Boolean):void
		{
			_isMoved=value;
		}

		private var hintShow:Sprite;

		private var hintFinger:Image;

		private function addClock():void
		{
			clock=new Sprite();
			addChild(clock);

			hour=getImage("hour-hand");
			min=getImage("min-hand");

			hour.pivotX=8;
			hour.pivotY=62;

			min.pivotX=14;
			min.pivotY=88;

			clock.addChild(hour);
			clock.addChild(min);

			clock.x=138;
			clock.y=144;
		}

		public function reset():void
		{
			ended=false;
			crtTime=Math.random() * 720 + 360;
		}
	}
}
