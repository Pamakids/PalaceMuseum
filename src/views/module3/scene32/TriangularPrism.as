package views.module3.scene32
{
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class TriangularPrism extends PalaceGame
	{
		private static const GlassRefractionIndex:Number=1.5;

		private var lightIn:Sprite;

		private var lightOut:Sprite;

		public function TriangularPrism(am:AssetManager=null)
		{
			super(am);
			addChild(getImage("gamebg"));

			lightIn=new Sprite();
			lightIn.addChild(getImage("light-input"));
			SPUtils.registSPCenter(lightIn, 6);
			addChild(lightIn);
			lightIn.x=centerPT.x;
			lightIn.y=centerPT.y;

			lightOut=new Sprite();
			lightOut.addChild(getImage("light-out"));
			SPUtils.registSPCenter(lightOut, 4);
			addChild(lightOut);
			lightOut.x=centerPT.x;
			lightOut.y=centerPT.y;

			var prism:Sprite=new Sprite();
			prism.addChild(getImage("light-prism"));
			prism.x=218;
			prism.y=127;
			addChild(prism);

			var sign:Sprite=new Sprite();
			sign.addChild(getImage("light-sign"));
			sign.x=641;
			sign.y=150;
			addChild(sign);

			applyAngle(Math.PI);
			addEventListener(TouchEvent.TOUCH, onTouch);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			dispatchEvent(new Event("gameOver"));
		}

		private var centerPT:Point=new Point(351, 300);
		private var dist:Number=70;

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.MOVED);
			if (tc)
			{
				var currentPosA:Point=tc.getLocation(this);
				var currentVector:Point=currentPosA.subtract(centerPT);
				var currentAngle:Number=Math.atan2(currentVector.y, currentVector.x);

				if (Math.abs(currentAngle) > Math.PI / 2)
					applyAngle(currentAngle);
			}
		}

		private var minRadian:Number=-0.13;
		private var maxRadian:Number=0.18;
		private var closeBtn:ElasticButton;

		private function applyAngle(deltaAngle:Number):void
		{
			deltaAngle=deltaAngle > 0 ? -(Math.PI - deltaAngle) : (Math.PI + deltaAngle);
			var _rotation:Number=Math.max(minRadian, Math.min(deltaAngle, maxRadian))
			lightIn.rotation=_rotation;

			var dy:Number=-(_rotation - minRadian) / (maxRadian - minRadian);
			lightIn.y=dy * 100 + centerPT.y;

			var angle1:Number=calcAngle(_rotation, Math.PI / 12, 1.5);
			if (angle1 != -1)
			{
				var angle2:Number=calcAngle(angle1, -Math.PI / 12, 1 / 1.5);
				if (angle2 != -1)
				{
					lightOut.rotation=angle2
					lightOut.y=dy * 100 * 9 / 10 + centerPT.y;
					lightOut.scaleY=1.25 + dy / 4;
				}
			}
		}

		public function calcAngle(inAngle:Number, normalsAngle:Number, refractionIndex:Number):Number
		{
			var fixAngleIn:Number=normalsAngle - inAngle;
			if (fixAngleIn < Math.PI / 8)
			{
				var fixAngleOut:Number=Math.asin(Math.sin(fixAngleIn) / refractionIndex);

				if (fixAngleOut < Math.PI / 8)
					return normalsAngle - fixAngleOut;
				else
					return -1;
			}
			else
				return -1;
		}
	}
}
