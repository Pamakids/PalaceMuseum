package views.module3.scene32
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Shape;
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
			var bg:Shape=new Shape();
			bg.graphics.beginFill(0);
			bg.graphics.drawRect(0, 0, 1024, 768);
			bg.graphics.endFill();
			addChild(bg);
//			addChild(getImage("gamebg"));

			horse=new Sprite();
			horse.addChild(getImage("horse"));
			addChild(horse);
			horse.clipRect=new Rectangle(0, 0, 0, 0);

			addPrism();

			var sign:Sprite=new Sprite();
			sign.addChild(getImage("light-sign"));
//			sign.x=641;
//			sign.y=150;
//			addChild(sign);

			addEventListener(TouchEvent.TOUCH, onTouch);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
		}

		private var rectH:Number=82;

		private function addPrism():void
		{
			lightIn=new Sprite();
			var input:Image=getImage("light-input");
			input.pivotY=input.height >> 1;
			var mask:Image=getImage("light-mask");
			mask.pivotY=mask.height >> 1;
			lightIn.addChild(mask);
			lightIn.addChild(input);

			lightIn.y=280;
			addChild(lightIn);

			horse.clipRect.width=1024;
			horse.clipRect.height=rectH;
			horse.clipRect.y=lightIn.y - rectH / 2;

			var prismBG:Shape=new Shape();
			addChild(prismBG);
			prismBG.graphics.beginFill(0);
			prismBG.graphics.drawRect(257, 253, 767, 161);
			prismBG.graphics.endFill();

			lightOut=new Sprite();
			lightOut.addChild(getImage("light-out"));
			SPUtils.registSPCenter(lightOut, 4);
			lightOut.x=257;
			lightOut.y=lightIn.y
			addChild(lightOut);
			lightOut.rotation=Math.PI / 18;

			var prism:Sprite=new Sprite();
			prism.addChild(getImage("light-prism"));
			prism.x=160;
			prism.y=249;
			addChild(prism);
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			dispatchEvent(new Event("gameOver"));
		}


		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{

					break;
				}

				case TouchPhase.MOVED:
				{
					var pt:Point=tc.getLocation(this);

					var dy:Number=pt.y;
					lightIn.y=dy;
					if (dy > 260 && dy < 360)
					{
						outVisible=true;
						var d:Number=(dy - 260) / 100;
						lightOut.x=257 + 50 * d;
						lightOut.y=dy + 0 * d;
						lightOut.scaleY=1 + d / 2;
						if (d < .1)
						{
							lightOut.scaleY=.3 + d * 7;
							lightOut.alpha=.3 + d * 7;
						}
						lightOut.rotation=Math.PI / 18 + Math.PI / 18 * d;
					}
					else
					{
						outVisible=false;
					}
					horse.clipRect.y=dy - rectH / 2;
					break;
				}

				case TouchPhase.ENDED:
				{

					break;
				}

				default:
				{
					break;
				}
			}
		}

		private var minRadian:Number=-0.13;
		private var maxRadian:Number=0.18;
		private var closeBtn:ElasticButton;

		private var horse:Sprite;

		private var _outVisible:Boolean=false;

		public function get outVisible():Boolean
		{
			return _outVisible;
		}

		public function set outVisible(value:Boolean):void
		{
			if (_outVisible != value)
			{
				TweenLite.killTweensOf(lightOut);
				TweenLite.to(lightOut, .5, {alpha: value ? 1 : 0});
			}
			_outVisible=value;
		}


		private function applyAngle(deltaAngle:Number):void
		{
			deltaAngle=deltaAngle > 0 ? -(Math.PI - deltaAngle) : (Math.PI + deltaAngle);
			var _rotation:Number=Math.max(minRadian, Math.min(deltaAngle, maxRadian))
			lightIn.rotation=_rotation;

			var dy:Number=-(_rotation - minRadian) / (maxRadian - minRadian);
//			lightIn.y=dy * 100 + centerPT.y;

			var angle1:Number=calcAngle(_rotation, Math.PI / 12, 1.5);
			if (angle1 != -1)
			{
				var angle2:Number=calcAngle(angle1, -Math.PI / 12, 1 / 1.5);
				if (angle2 != -1)
				{
					lightOut.rotation=angle2
//					lightOut.y=dy * 100 * 9 / 10 + centerPT.y;
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
