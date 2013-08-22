package views.module1.scene3
{
	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	public class Clock extends Sprite
	{
		private var assets:AssetManager;

		private var clockface:Sprite;
		private var facePt:Point=new Point(262,92);

		private var hourhand:Sprite;
		private var minutehand:Sprite;
		private var crtTarget:Sprite;

		private var sign:Sprite;

		public function Clock(_assets:AssetManager)
		{
			this.assets=_assets;

			addChild(new Image(assets.getTexture("clock-big")));
			pivotX=this.width>>1;
			pivotY=this.height>>1;

			clockface=new Sprite();
			addChild(clockface);
			clockface.x=facePt.x;
			clockface.y=facePt.y;

			sign=new Sprite();
			sign.addChild(new Image(assets.getTexture("clock-sign")));
			sign.pivotX=5;
			sign.pivotY=33;
			clockface.addChild(sign);

			hourhand=new Sprite();
			minutehand=new Sprite();

			hourhand.addChild(new Image(assets.getTexture("hour")));
			hourhand.pivotX=5;
			hourhand.pivotY=30;
			hourhand.addEventListener(TouchEvent.TOUCH,onHandTouch);

			minutehand.addChild(new Image(assets.getTexture("min")));
			minutehand.pivotX=8;
			minutehand.pivotY=43;
			minutehand.addEventListener(TouchEvent.TOUCH,onHandTouch);

			clockface.addChild(minutehand);
			clockface.addChild(hourhand);

//			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}

		private function onHandTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage);
			if(!tc)
				return;

			var pt:Point  = tc.getLocation(stage);

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					if(event.currentTarget&&event.currentTarget is Sprite)
						crtTarget=event.currentTarget as Sprite;
					break;
				}

				case TouchPhase.MOVED:
				{
					if(crtTarget){
						//A点的当前和上一个坐标
						var currentPosA:Point  = tc.getLocation(this);
						var previousPosA:Point = tc.getPreviousLocation(this);
						//计算两个点之间的距离
						var currentVector:Point  = currentPosA.subtract(facePt);
						var previousVector:Point = previousPosA.subtract(facePt);
						//计算上一个弧度和当前触碰点弧度，算出弧度差值
						var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
						var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
						var deltaAngle:Number = currentAngle - previousAngle;

						crtTarget.rotation+=deltaAngle;
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					crtTarget=null;
					if(Math.abs(hourhand.rotation/Math.PI-5/6)<0.03&&Math.abs(minutehand.rotation/Math.PI)<0.03){
						dispatchEvent(new Event("clockMatch"));
					}
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function onEnterFrame(e:Event):void
		{
			hourhand.rotation+=.01;
			minutehand.rotation+=.1;

			sign.alpha+=Math.random()>.5?.1:-.1
		}

		public function reset():void{
			hourhand.rotation=0;
			minutehand.rotation=0;
		}
	}
}

