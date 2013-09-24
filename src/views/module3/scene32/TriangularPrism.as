/**
 *
 * 三棱镜
 * 九龙壁
 *
 * */

package views.module3.scene32
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.CollectionCard;
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

//			var sp:Shape=new Shape();
//			sp.graphics.beginFill(0);
//			sp.graphics.drawRect(0, 0, 1024, 768);
//			sp.graphics.endFill();
//			addChild(sp);

			var bg:Image=getImage("prism-bg");
//			bg.alpha=.5;
			addChild(bg);

			addArea();

			addPrism2();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			prism.addEventListener(TouchEvent.TOUCH, onPrimsTouch);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.C)
				trace(crtRotation);
		}

		private function onPrimsTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(prism, TouchPhase.MOVED);
			if (!tc)
				return;
			var pa:Point=tc.getPreviousLocation(this);
			var pb:Point=tc.getLocation(this);

			var dAngle:Number=Math.atan2(pb.y - 384, pb.x - 512) - Math.atan2(pa.y - 384, pa.x - 512);
			prism.rotation+=dAngle;
		}

		private function addArea():void
		{
			for (var i:int=0; i < posArr.length; i++)
			{
				var img:Image=getImage("part" + i.toString());
				img.alpha=0;
				img.x=posArr[i].x;
				img.y=posArr[i].y;
				addChild(img);
				areaArr.push(img);
			}
		}

		private var posArr:Array=[new Point(750, 34), new Point(749, 301), new Point(682, 529),
			new Point(408, 549), new Point(63, 506), new Point(29, 313),
			new Point(29, 87), new Point(262, 3), new Point(539, 7)]

		private function addPrism2():void
		{
			lightIn=new Sprite();
			lightIn.addChild(getImage("light-input"));
			SPUtils.registSPCenter(lightIn, 6);
			lightIn.x=512;
			lightIn.y=384;
			lightIn.alpha=0;
			addChild(lightIn);

			lightOut=new Sprite();
			lightOut.addChild(getImage("light-out"));
			SPUtils.registSPCenter(lightOut, 4);
			lightOut.x=512;
			lightOut.y=384;
			lightOut.alpha=0;
			addChild(lightOut);

			prism=new Sprite();
			prism.addChild(getImage("light-prism"));
			prism.x=512;
			prism.y=384;
			prism.pivotX=prism.width / 2;
			prism.pivotY=prism.height / 3 * 2;
			addChild(prism);
		}

		private function onEnterFrame(e:Event):void
		{
			lightIn.rotation=Math.PI + crtRotation;
//			prism.rotation+=.01;
			lightOut.rotation=applyAngle2(crtRotation, prism.rotation);

			if (lightOut.alpha == 1)
			{
				addColor(lightOut.rotation);
			}
		}

		private var angleArr:Array=[-0.701, -0.328, -0.211, 0.326, 0.450, 0.953, 1.192, 1.941,
			2.237, 2.771, 2.869, -2.97, -2.81, -2.44, -2.30, -1.68, -1.40, -0.84];

		private function addColor(_rotation:Number):void
		{
			var index:int=-2;
			for (var i:int=0; i < angleArr.length; i+=2)
			{
				if (angleArr[i] - angleArr[i + 1] > 3)
				{
					if ((_rotation > angleArr[i] && _rotation < Math.PI) || (_rotation < angleArr[i + 1] && _rotation > -Math.PI))
						index=i;
				}
				else if (_rotation < angleArr[i + 1] && _rotation > angleArr[i])
				{
					index=i;
					break;
				}
			}

			crtAreaIndex=index / 2;

			if (areaCount > 15 && crtAreaIndex >= 0)
			{
				var ap:Number=areaArr[crtAreaIndex].alpha;
				if (ap.toFixed(2) == "0.40")
					count++;
				areaArr[crtAreaIndex].alpha=ap + .01;
			}
		}

		private var areaArr:Array=[];

		private var degree30:Number=Math.PI / 6; //30度
		private var degree40:Number=Math.PI / 4.5; //40度

		private function applyAngle2(inAngle:Number, prismAngle:Number):Number
		{
			var inAngleFixed:Number=inAngle - prismAngle;
			inAngleFixed%=Math.PI * 2;
			if (inAngleFixed < 0)
				inAngleFixed+=Math.PI * 2;

			var outIndex:int=0; //出射中心线
			if (inAngleFixed >= degree30 * 1 && inAngleFixed < degree30 * 5) //30-150
				outIndex=9;
			else if (inAngleFixed >= degree30 * 5 && inAngleFixed < degree30 * 9) //150-270
				outIndex=1;
			else if (inAngleFixed >= degree30 * 9 && inAngleFixed < degree30 * 12) //270-360
				outIndex=5;
			else if (inAngleFixed >= degree30 * 0 && inAngleFixed < degree30 * 1) //0-30
				outIndex=5;

			var deltaAngle:Number=inAngleFixed % degree30;
			var isLeft:Boolean=int(inAngleFixed / degree30) % 2 == 0;
			var isAdd:Boolean=int((inAngleFixed + degree30 * 3) / degree30) % 4 >= 2;
			var outAngleFixed:Number=outIndex * degree30 + (isAdd ? 1 : -1) * (isLeft ? (degree30 - deltaAngle) : deltaAngle);

			return outAngleFixed + prismAngle;
		}

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
			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					crtRotation=Math.atan2(pt.y - 384, pt.x - 512);
					TweenLite.killTweensOf(lightIn);
					TweenLite.killTweensOf(lightOut);
					TweenLite.to(lightIn, .5, {alpha: 1});
					TweenLite.to(lightOut, 1, {alpha: 1});
					break;
				}

				case TouchPhase.MOVED:
				{
					crtRotation=Math.atan2(pt.y - 384, pt.x - 512);
//					var dy:Number=pt.y;
//					lightIn.y=dy;
//					if (dy > 260 && dy < 360)
//					{
//						outVisible=true;
//						var d:Number=(dy - 260) / 100;
//						lightOut.x=257 + 50 * d;
//						lightOut.y=dy + 0 * d;
//						lightOut.scaleY=1 + d / 2;
//						if (d < .1)
//						{
//							lightOut.scaleY=.3 + d * 7;
//							lightOut.alpha=.3 + d * 7;
//						}
//						lightOut.rotation=Math.PI / 18 + Math.PI / 18 * d;
//					}
//					else
//					{
//						outVisible=false;
//					}
//					horse.clipRect.y=dy - rectH / 2;
					break;
				}

				case TouchPhase.ENDED:
				{
					TweenLite.killTweensOf(lightIn);
					TweenLite.killTweensOf(lightOut);
					TweenLite.to(lightIn, 1, {alpha: 0});
					TweenLite.to(lightOut, .5, {alpha: 0});
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

		private var prism:Sprite;
		private var crtRotation:Number=0;
		private var _crtAreaIndex:int=0;
		private var areaCount:int=0;
		private var _count:int=0;

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count=value;
			if (_count == 9)
				dispatchEvent(new Event("addCard"));
//				addCard("card-dragon")
		}

		public function get crtAreaIndex():int
		{
			return _crtAreaIndex;
		}

		public function set crtAreaIndex(value:int):void
		{
			if (_crtAreaIndex != value)
				areaCount=0;
			else
				areaCount++;
			_crtAreaIndex=value;
		}

		private function applyAngle(deltaAngle:Number):void
		{
			deltaAngle=deltaAngle > 0 ? -(Math.PI - deltaAngle) : (Math.PI + deltaAngle);
			var _rotation:Number=Math.max(minRadian, Math.min(deltaAngle, maxRadian))
			lightIn.rotation=_rotation;

			var dy:Number=-(_rotation - minRadian) / (maxRadian - minRadian);

			var angle1:Number=calcAngle(_rotation, Math.PI / 12, 1.5);
			if (angle1 != -1)
			{
				var angle2:Number=calcAngle(angle1, -Math.PI / 12, 1 / 1.5);
				if (angle2 != -1)
				{
					lightOut.rotation=angle2
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
