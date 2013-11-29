/**
 *
 * 三棱镜
 * 九龙壁
 *
 * */

package views.module2.scene22
{
	import com.greensock.TweenLite;
	import com.pamakids.manager.SoundManager;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import sound.SoundAssets;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
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

			var bg:Image=getImage("prism-bg");
			addChild(bg);

			addArea();

			addPrism2();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(TouchEvent.TOUCH, onTouch);
			prism.addEventListener(TouchEvent.TOUCH, onPrimsTouch);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

			addClose();
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.C)
				trace(crtRotation.toFixed(2) + ",");
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
				var img:Image=getImage("part" + (i + 1).toString());
				img.alpha=0;
				img.x=posArr[i].x;
				img.y=posArr[i].y;
				areaArr.push(img);

				var shadow:Sprite=new Sprite();
				var si:Image=getImage("shadow" + (i + 1).toString());
				si.alpha=0;
				shadow.addChild(si);
				shadow.pivotX=si.width >> 1;
				shadow.pivotY=si.height >> 1;
				shadow.x=img.x + img.width / 2;
				shadow.y=img.y + img.height / 2;
				shadow.alpha=0;
				shadowArr.push(shadow);
				addChild(shadow);
				addChild(img);
			}
		}

//		private function blink(img:Image):void
//		{
//			TweenLite.to(img, .5, {alpha: 1, onComplete: function():void {
//				TweenLite.delayedCall(3, function():void {
//					TweenLite.to(img, .5, {alpha: 0});
//				});
//			}});
//		}

		private var shadowArr:Array=[];

		private var posArr:Array=[new Point(376, 10), new Point(631, 34),
								  new Point(778, 206), new Point(761, 410), new Point(527, 560),
								  new Point(250, 551), new Point(25, 428), new Point(18, 225),
								  new Point(141, 34)]

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
			lightOut.rotation=applyAngle2(crtRotation, prism.rotation);

			if (lightOut.alpha == 1)
			{
				addColor(lightOut.rotation);
			}
		}

		private var angleArr:Array=[-1.94,
									-1.37,
									-1.10,
									-0.61,
									-0.41,
									-0.04,
									0.16,
									0.50,
									0.82,
									1.35,
									1.88,
									2.34,
									2.61,
									2.94,
									-3.11,
									-2.81,
									-2.58,
									-2.20];

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
			if (crtAreaIndex < 0)
			{
				if (lastAreaIndex != crtAreaIndex)
				{
					TweenLite.to(shadowArr[lastAreaIndex], .5, {alpha: 0});
					lastAreaIndex=crtAreaIndex;
				}
			}
			else
			{
				if (lastAreaIndex != crtAreaIndex)
				{
					if (lastAreaIndex >= 0)
						TweenLite.to(shadowArr[lastAreaIndex], .5, {alpha: 0});
					lastAreaIndex=crtAreaIndex;
					TweenLite.to(shadowArr[crtAreaIndex], .5, {alpha: 1});
				}

				if (areaCount > 15)
				{
					var img:Image=areaArr[crtAreaIndex];
					var ap:Number=img.alpha;
					if (ap.toFixed(2) == "0.40")
					{
						SoundAssets.playSFX("dragonlighton");
						var shadow:Sprite=shadowArr[crtAreaIndex];
						TweenLite.to(shadow.getChildAt(0), .5, {alpha: 1});
//					blink(shadow.getChildAt(0) as Image);
//					TweenMax.to(img, .5, {shake: {scaleX: .2, scaleY: .2, numShakes: 1}});
						count++;
					}
					areaArr[crtAreaIndex].alpha=ap + .01;
				}
			}
		}

		private var areaArr:Array=[];
		private var lastAreaIndex:int=-1;

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
					lastAreaIndex=-1;
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
					if (crtAreaIndex >= 0)
					{
						TweenLite.to(shadowArr[crtAreaIndex], .5, {alpha: 0});
//						lastAreaIndex=-1;
						crtAreaIndex=-1;
					}
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
			{
				closeBtn.visible=false;
				removeEventListener(TouchEvent.TOUCH, onTouch);
				prism.removeEventListener(TouchEvent.TOUCH, onPrimsTouch);
				TweenLite.to(lightIn, 1, {alpha: 0});
				TweenLite.to(lightOut, .5, {alpha: 0});
				TweenLite.to(prism, 2, {alpha: 0});

				dispatchEvent(new Event("addCard"));
			}
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

		public function addDragonWall():void
		{
			if (crtAreaIndex >= 0)
				TweenLite.to(shadowArr[crtAreaIndex], .5, {alpha: 0});

			for (var i:int=0; i < areaArr.length; i++)
			{
				var img:Image=areaArr[i] as Image;
				playEff(i * .2, img);
			}
			TweenLite.delayedCall(areaArr.length * .2 + .5, showWall);
		}

		private function playEff(delay:Number, _img:DisplayObject, show:Boolean=false):void
		{
			TweenLite.delayedCall(delay, function():void {
				TweenLite.to(_img, .3, {alpha: show ? 1 : 0});
			});
		}

		private var wallPosArr:Array=[new Point(459, 114), new Point(363, 113),
									  new Point(567, 113), new Point(251, 115), new Point(664, 114),
									  new Point(136, 113), new Point(783, 113), new Point(15, 111),
									  new Point(875, 106)];

		private function showWall():void
		{
			var title:Image=getImage("wall-title");
			title.x=447;
			title.y=98;
			addChild(title);

			var info:Image=getImage("wall-word");
			info.x=92;
			info.y=516;
			addChild(info);

			var wall:Sprite=new Sprite();
			wall.addChild(getImage("wall"));
			wall.y=171;
			addChild(wall);
			for (var i:int=0; i < wallPosArr.length; i++)
			{
				var dragon:Image=getImage("dragon" + (i + 1).toString());
				dragon.x=wallPosArr[i].x;
				dragon.y=wallPosArr[i].y;
				wall.addChild(dragon);
				dragon.alpha=0;
				playEff(i * .1, dragon, true);
			}
			TweenLite.delayedCall(wallPosArr.length * .1 + .5, function():void {
				closeBtn.visible=true;
				isWin=true;
			});
		}
	}
}
