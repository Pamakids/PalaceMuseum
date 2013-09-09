package views.module3.scene32
{
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

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
			prism.x=168;
			prism.y=227;
			addChild(prism);

			var sign:Sprite=new Sprite();
			sign.addChild(getImage("light-sign"));
			sign.x=641;
			sign.y=89;
			addChild(sign);

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private var centerPT:Point=new Point(311, 300);
		private var dist:Number=70;

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.MOVED);
			if (tc)
			{
				var currentPosA:Point=tc.getLocation(this);
				var previousPosA:Point=tc.getPreviousLocation(this);
				var currentVector:Point=currentPosA.subtract(centerPT);
				var previousVector:Point=previousPosA.subtract(centerPT);
				var currentAngle:Number=Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number=Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number=currentAngle - previousAngle;

				var rotation:Number=lightIn.rotation
//				rotation=Math.max(0, Math.min(rotation, Math.PI))
				lightIn.rotation=rotation + deltaAngle;

				var angle1:Number=calcAngle(lightIn.rotation, Math.PI / 12, 1.5);
				if (angle1 != -1)
				{
					var angle2:Number=calcAngle(angle1, -Math.PI / 12, 1 / 1.5);
					if (angle2 != -1)
						lightOut.rotation=angle2
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
