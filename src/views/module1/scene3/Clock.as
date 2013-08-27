package views.module1.scene3
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

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
			flace.x=234;
			flace.y=396;
			addChild(flace);

			var close:Image=getImage("clock-close");
			close.x=830;
			addChild(close);
			close.addEventListener(TouchEvent.TOUCH, onCloseTouch);

			//			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
//			pivotX=bg.width / 2;
//			pivotY=bg.height / 2;
		}

		private function onCloseTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (!tc)
				return;
			PopUpManager.removePopUp(this);
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
								crtTime-=delta;
								for (var i:int=0; i < laceArr.length; i++)
								{
									var img:Image=laceArr[i] as Image;
									img.x+=delta / 5;
									if (img.x < -65)
										img.x=3 * 65 + img.x;
								}

								for (var j:int=0; j < wordArr.length; j++)
								{
									var img1:Image=wordArr[j] as Image;
									img1.x+=delta / 5;
									if (img1.x < -370)
										img1.x=2 * 370 + img1.x;
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

		private var hotarea:Rectangle=new Rectangle(230, 315, 555, 277);
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

				TweenLite.to(clock, 1, {scaleX: 1.2, scaleY: 1.2, onComplete: function():void
				{
					TweenLite.to(clock, 1, {scaleX: 1, scaleY: 1});
				}});
				TweenLite.delayedCall(2, function():void
				{
					dispatchEvent(new Event("clockMatch"));
				});
			}
		}

		private function onEnterFrame(e:Event):void
		{
			min.rotation+=.01;
			hour.rotation+=.001;

			for (var i:int=0; i < laceArr.length; i++)
			{
				var img:Image=laceArr[i] as Image;
				img.x-=.3;
				if (img.x < -65)
					img.x=2 * 65;
			}

			for (var j:int=0; j < wordArr.length; j++)
			{
				var img1:Image=wordArr[j] as Image;
				img1.x-=.3;
				if (img1.x < -370)
					img1.x=370;
			}
		}

		private function addWheel():void
		{
			var wheel:Sprite=new Sprite();
			wheel.x=459;
			wheel.y=343;
			addChild(wheel);
			wheel.clipRect=new Rectangle(0, 0, 122, 166);

			for (var i:int=0; i < 6; i++)
			{
				var lace:Image=getImage("clock-lace");
				lace.x=i % 3 * 65;
				lace.y=i < 3 ? 0 : 127;
				wheel.addChild(lace);
				laceArr.push(lace);
			}

			for (var j:int=0; j < 2; j++)
			{
				var word:Image=getImage("clock-word");
				word.x=j * 370;
				word.y=33;
				wheel.addChild(word);
				wordArr.push(word);
			}

			mask=getImage("clock-mask");
			wheel.addChild(mask);

		}

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
