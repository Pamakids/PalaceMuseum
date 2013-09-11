package views.module3.scene32
{
	import com.pamakids.palace.utils.SPUtils;

	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class Telescope extends PalaceGame
	{

		private var view:ViewHolder;
		private var index:int;

		private var telHolder:Sprite;

		private var tele1:Image;

		private var tele2:Image;

		private var tele3:Image;

		public function Telescope(am:AssetManager=null)
		{
			super(am);

			addChild(getImage("tele-bg"));

			addView();

			addRing();

			addTele();

			var king:Image=getImage("tele-king");
			king.x=742;
			king.y=439;
			addChild(king);
			king.touchable=false;
			var arm:Image=getImage("tele-arm");
			arm.x=747;
			arm.y=569;
			addChild(arm);
			arm.touchable=false;

			var acc:Accelerometer=new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{
			view.pivotX-=speedX;
			view.pivotY+=speedY;
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			dispatchEvent(new Event("gameOver"));
		}

		protected function onUpdate(e:AccelerometerEvent):void
		{
			var dx:Number=e.accelerationX;
			if (Math.abs(dx) < .1)
				dx=0;
			speedX=dx * 100;

			var dy:Number=e.accelerationY;
			if (Math.abs(dy) < .1)
				dy=0;
			speedY=dy * 100;
		}

		private var centerPT:Point=new Point(329, 286);

		private function addRing():void
		{
			ring1=new Sprite();
			ring1.addChild(getImage("tele-ring-in"));
			ring2=new Sprite();
			ring2.addChild(getImage("tele-ring-out"));

			SPUtils.registSPCenter(ring1);
			SPUtils.registSPCenter(ring2);

			ring1.x=ring2.x=centerPT.x;
			ring1.y=ring2.y=centerPT.y;

			addChild(ring1);
			addChild(ring2);

			ring2.addEventListener(TouchEvent.TOUCH, onRing2Touch);
		}

		private function onRing2Touch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(ring2, TouchPhase.MOVED);
			if (tc)
			{
				var currentPosA:Point=tc.getLocation(this);
				if (Point.distance(currentPosA, centerPT) < 220)
					rotateRing(tc, ring1);
				else
				{
					rotateRing(tc, ring2);
				}
			}
		}

		private function rotateRing(tc:Touch, target:Sprite):void
		{
			var currentPosA:Point=tc.getLocation(this);
			var previousPosA:Point=tc.getPreviousLocation(this);
			var currentVector:Point=currentPosA.subtract(centerPT);
			var previousVector:Point=previousPosA.subtract(centerPT);
			var currentAngle:Number=Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number=Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number=currentAngle - previousAngle;

			if (Math.abs(deltaAngle) > Math.PI / 2)
			{
				deltaAngle=deltaAngle > 0 ? -(Math.PI * 2 - deltaAngle) : (Math.PI * 2 + deltaAngle);
			}

			if (target == ring2)
				deltaAngle=deltaAngle;
			else
				deltaAngle=deltaAngle / 2;

			target.rotation+=deltaAngle;

			updataBlur();
		}

		private function updataBlur():void
		{
			var ty:Number=Math.abs(tele3.y / maxY);
			var rt1:Number=Math.abs(ring1.rotation) * 2 / Math.PI;
			var rt2:Number=Math.abs(ring2.rotation) * 2 / Math.PI;

			var blur:Number=Math.abs(ty - rt1 * rt2) * 10;
			view.blur(blur);
		}

		private function addView():void
		{
			view=new ViewHolder();
			addChild(view);
			view.img1=getImage("view1");
			view.img2=getImage("view2");
			view.viewPortHeight=view.viewPortWidth=440;
			view.x=view.pivotX=90 + 474 / 2;
			view.y=view.pivotY=46 + 474 / 2;
			view.scale=.1;

			var mask:Image=getImage("tele-mask");
			mask.x=90;
			mask.y=46;
			addChild(mask);
		}

		private function addTele():void
		{
			telHolder=new Sprite();
			addChild(telHolder);

			tele1=getImage("tele1");
			tele2=getImage("tele2");
			tele3=getImage("tele3");
			tele1.pivotX=tele1.width >> 1;
			tele2.pivotX=tele2.width >> 1;
			tele3.pivotX=tele3.width >> 1;

			telHolder.addChild(tele1);
			telHolder.addChild(tele2);
			telHolder.addChild(tele3);

			telHolder.x=687;
			telHolder.y=545;
			telHolder.rotation=-Math.PI * 2 / 5;

			telHolder.addEventListener(TouchEvent.TOUCH, onTeleTouch);
		}

		private var maxY:int=150;

		private var ring1:Sprite;

		private var ring2:Sprite;
		private var closeBtn:ElasticButton;
		private var speedX:Number=0;
		private var speedY:Number=0;

		private function onTeleTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(telHolder, TouchPhase.MOVED);
			if (tc)
			{
				var move:Point=tc.getMovement(telHolder);
				var dy:Number=-move.y / 3;
				tele3.y-=dy;
				if (tele3.y < -maxY)
					tele3.y=-maxY;
				else if (tele3.y > 0)
					tele3.y=0;

				tele2.y=Math.max(-84, tele3.y);

				view.scale=Math.abs(tele3.y) / maxY;
				updataBlur();
			}
		}
	}
}
