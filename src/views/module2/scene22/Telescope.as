package views.module2.scene22
{
	import com.pamakids.manager.SoundManager;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import models.SOService;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

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
			addEye();

			var arm:Image=getImage("tele-arm");
			arm.x=747;
			arm.y=569;
			addChild(arm);
			arm.touchable=false;

			addClose();

			if (SOService.instance.checkHintCount(teleHint))
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var teleHint:String="teleHintCheck"

		private function onEnterFrame(e:Event):void
		{
			if (handMoved && ringMoved)
				isMoved=true;
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (count < 30 * 5)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintHand=getImage("hintHand");
					hintRing=getImage("hintRing");

					hintHand.x=708;
					hintHand.y=484;
					hintRing.x=563;
					hintRing.y=56;

					hintShow.addChild(hintHand);
					hintShow.addChild(hintRing);

					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintShow.alpha == 1)
						isReverse=true;
					else if (hintShow.alpha == 0)
						isReverse=false;
					hintShow.alpha+=isReverse ? -.05 : .05;
					hintHand.visible=!handMoved;
					hintRing.visible=!ringMoved;
				}
			}
		}

		private var centerPT:Point;

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

		private var dpt:Point;

		private function onRing2Touch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(ring2);
			if (!tc)
				return;
			var currentPosA:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=tc.getLocation(stage);
					SoundManager.instance.stop("ringrolling");
					ringBlock=false;
					if (Point.distance(currentPosA, centerPT) < 210)
						actionIndex=0; //move
					else
						actionIndex=1; //rotate
					break;
				}

				case TouchPhase.MOVED:
				{
					if (!ringBlock)
					{
						if (actionIndex == 0)
							moveView(tc.getMovement(this));
						else if (actionIndex == 1)
							rotateRing(tc, ring2);
					}
					break;
				}
				case TouchPhase.ENDED:
				{
					var pt:Point=tc.getLocation(stage)
					if (dpt && Point.distance(pt, dpt) < 10)
						checkViewPoint(pt);
					dpt=null;
					SoundManager.instance.stop("ringrolling");
					ringBlock=false;
					actionIndex=-1
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkViewPoint(pt:Point):void
		{
			if (view.scale < 1)
				return;
			var vpt:Point=view.globalToLocal(pt);
			if (lionRect.containsPoint(vpt))
			{
				view.standUp=false;
				dispatchEvent(new Event("lionFound", true));
			}
		}

		private function moveView(pt:Point):void
		{
			view.pivotX-=pt.x;
			view.pivotY-=pt.y;
		}

		private function rotateRing(tc:Touch, target:Sprite):void
		{
			SoundManager.instance.play("ringrolling");
			isRingMoved=true;
			if (isZoomed)
				isWin=true;

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

			var blur:Number=updataBlur();
			if (Math.abs(blur) < 0.01 && tele3.y == -maxY)
			{
				SoundManager.instance.stop("ringrolling");
				SoundManager.instance.play("ringblock");
				ringBlock=true;
//				view.standUp=true;
			}
//			else
//				view.standUp=false;
			ringMoved=true;
		}

		private function updataBlur():Number
		{
			var ty:Number=Math.abs(tele3.y / maxY);
//			var rt1:Number=Math.abs(ring1.rotation) * 2 / Math.PI;
			var rt2:Number=Math.abs(ring2.rotation) * 2 / Math.PI;

			var blur:Number=Math.abs(ty - rt2) * 10;
			if (blur == 0)
				trace(blur)
			view.blur(blur);
			return blur;
		}

		private function addView():void
		{
			var mask:Image=getImage("tele-mask");
			mask.x=99;
			mask.y=54;

			centerPT=new Point(mask.x + mask.width / 2, mask.y + mask.height / 2)

			view=new ViewHolder();
			addChild(view);
			view.img1=getImage("view1");
			view.img2=getImage("view2");
			view.viewPortHeight=view.viewPortWidth=440;
			view.x=view.pivotX=centerPT.x;
			view.y=view.pivotY=centerPT.y;
			view.scale=.1;

			view.initLion(getImage("lionsit"), getImage("lionstand"));

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
		private var speedX:Number=0;
		private var speedY:Number=0;

		private var actionIndex:int=-1;
		private var isRingMoved:Boolean;
		private var isZoomed:Boolean;
		private var eye:MovieClip;
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int;
		private var isReverse:Boolean;

		private var hintHand:Image;

		private var hintRing:Image;
		private var handMoved:Boolean;
		private var ringMoved:Boolean;
		private var ringBlock:Boolean;

//		private var lionRect:Rectangle=new Rectangle(1211, 214, 74, 81);
		private var lionRect:Rectangle=new Rectangle(1222, 208, 54, 84);

		private function onTeleTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(telHolder);
			if (!tc)
				return;
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					SoundManager.instance.stop("telescale");
					break;
				}
				case TouchPhase.MOVED:
				{
					var move:Point=tc.getMovement(telHolder);
					var dy:Number=-move.y / 3;
					tele3.y-=dy;
					if (tele3.y < -maxY)
					{
						SoundManager.instance.stop("telescale");
						tele3.y=-maxY;
					}
					else if (tele3.y > 0)
					{
						SoundManager.instance.stop("telescale");
						tele3.y=0;
					}
					else
						SoundManager.instance.play("telescale");

					tele2.y=Math.max(-84, tele3.y);

					view.scale=Math.abs(tele3.y) / maxY;

					isZoomed=true;

					handMoved=true;

					if (isRingMoved)
						isWin=true;

					updataBlur();
					break;
				}
				case TouchPhase.ENDED:
				{
					SoundManager.instance.stop("telescale");
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function addEye():void
		{
			eye=new MovieClip(assetManager.getTextures("eye"), 30);
			eye.loop=1;
			eye.play();
			Starling.juggler.add(eye);
			eye.x=806;
			eye.y=559;
			addChild(eye);
		}

		override public function dispose():void
		{
			if (eye)
			{
				eye.stop();
				Starling.juggler.remove(eye);
				eye.removeFromParent(true);
				eye=null;
			}
			super.dispose();
		}
	}
}
