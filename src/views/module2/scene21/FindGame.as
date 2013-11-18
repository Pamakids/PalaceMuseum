package views.module2.scene21
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.pamakids.manager.SoundManager;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class FindGame extends PalaceGame
	{
		private var scrArr:Array=["drum", "flute", "crickets"];

		public function FindGame(am:AssetManager=null)
		{
			super(am);

			addBG();
			var art:Image=getImage("find-bg");
			art.x=10;
			art.y=105;
			addChild(art);

			for (var i:int=0; i < scrArr.length; i++)
			{
				var img:Image=getImage(scrArr[i] + "-shadow");
				img.x=destPosArr[i].x;
				img.y=destPosArr[i].y;
				addChild(img);
				shadowArr.push(img);
			}

			drum=getImage("drum");
			drum.x=originPosArr[0].x;
			drum.y=originPosArr[0].y;
			drum.scaleX=drum.scaleY=36 / drum.width;
			drum.visible=false;
			addChild(drum);

			flute=getImage("flute");
			flute.x=originPosArr[1].x;
			flute.y=originPosArr[1].y;
			flute.scaleX=flute.scaleY=40 / flute.width;
			flute.visible=false;
			addChild(flute);

			addBugS();

			addEventListener(TouchEvent.TOUCH, onTouch);

			addClose();

			addHints(-1);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var hintArr:Vector.<Image>=new Vector.<Image>(4);
		private var reverseArr:Vector.<Boolean>=new Vector.<Boolean>(4);

		private function addHints(index:int):void
		{
			if (reverseArr[index + 1])
				return;
			var src:String;
			if (index < 0)
				src="findHint";
			else
				src=scrArr[index] + "Hint";
			var hint:Image=getImage(src);
			hint.touchable=false;
			addChild(hint);
			hint.x=hintPosArr[2 * (index + 1)];
			hint.y=hintPosArr[2 * (index + 1) + 1];
			hintArr[index + 1]=hint;
		}

		private function removeHint(index:int):void
		{
			var img:Image=hintArr[index];
			if (img)
				img.removeFromParent(true);
			hintArr[index]=null;
			reverseArr[index]=true;
		}

		private var count:int=0;
		private var hintPosArr:Array=[493, 52, 305, 205, 647, 477, 808, 512];

		private function onEnterFrame(e:Event):void
		{
			for (var i:int=0; i < hintArr.length; i++)
			{
				var img:Image=hintArr[i];
				if (img)
				{
					var b:Boolean=reverseArr[i];
					if (b)
						img.alpha+=.05;
					else
						img.alpha-=.05;
					if (img.alpha == 0)
						reverseArr[i]=true;
					else if (img.alpha == 1)
						reverseArr[i]=false;
				}
			}

			count++;
			if (count == 120)
			{
				removeHint(0);
			}
			else if (count == 420)
			{
				for (var j:int=0; j < scrArr.length; j++)
				{
					addHints(j);
				}

			}
		}

		private function addBugS():void
		{
			bugS=new MovieClip(assetManager.getTextures("bugS"), 30);
			bugS.x=originPosArr[2].x;
			bugS.y=originPosArr[2].y;
			bugS.stop();
			addChild(bugS);
			bugS.addEventListener(TouchEvent.TOUCH, onBugSTouch);
		}

		private function onBugSTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bugS, TouchPhase.ENDED);
			if (tc)
			{
				SoundManager.instance.play("bug");
				removeHint(3);
				bugS.removeEventListener(TouchEvent.TOUCH, onBugSTouch);
				bugS.loop=0;
				bugS.play();
				Starling.juggler.add(bugS);
				bugS.addEventListener(Event.COMPLETE, playBugB);
			}
		}

		private var jumpCount:int=0;

		private function playBugB(e:Event):void
		{
			if (bugS)
			{
				var img:Image=shadowArr[2] as Image;
				TweenLite.to(img, 2, {alpha: 0});
				bugS.removeEventListener(Event.COMPLETE, playBugB);
				bugS.stop();
				Starling.juggler.remove(bugS);
				bugS.removeFromParent(true);
				bugS=null;
			}

			if (!bugB)
			{
				bugB=new MovieClip(assetManager.getTextures("bugB"), 30);
				bugB.loop=3;
				Starling.juggler.add(bugB);
				addChild(bugB);
				bugB.addEventListener(Event.COMPLETE, playBugB);
			}
			if (jumpCount < 3)
			{
				bugB.stop();
				bugB.x=bugBDestX - (2 - jumpCount) * jumpGap;
				bugB.y=bugBY;
				bugB.play();
			}
			else
			{
				bugB.removeEventListener(Event.COMPLETE, playBugB);
				bugB.pause();
				Starling.juggler.remove(bugB);
				checkResult();
			}
			jumpCount++;
		}

		private var jumpGap:Number=165;
		private var bugBDestX:Number=75;
		private var bugBY:Number=-32;

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			if (rattleDrumArea.containsPoint(pt))
			{
				SoundManager.instance.play("drum");
				playEff(drum, destPosArr[0]);
				rattleDrumArea=new Rectangle(-1000, -1000, 0, 0)
				removeHint(1);
			}
			else if (fluteArea.containsPoint(pt))
			{
				SoundManager.instance.play("flute");
				playEff(flute, destPosArr[1]);
				fluteArea=new Rectangle(-1000, -1000, 0, 0);
				removeHint(2);
			}
		}

		private var rattleDrumArea:Rectangle=new Rectangle(309, 211, 31, 95);
		private var fluteArea:Rectangle=new Rectangle(651, 481, 42, 35);
		private var originPosArr:Array=[new Point(326, 291), new Point(652, 478), new Point(806, 490)];
		private var destPosArr:Array=[new Point(133, 23), new Point(35, 9), new Point(251, 16)];
		private var shadowArr:Array=[];

		private function playEff(img:Image, destPos:Point):void
		{
			this.setChildIndex(img, this.numChildren - 1);
			img.visible=true;
			TweenLite.to(img, .5, {scaleX: 1, scaleY: 1});
			TweenLite.delayedCall(1, function():void {

				var index:int=destPosArr.indexOf(destPos);
				var shadow:Image=shadowArr[index] as Image;
				TweenLite.to(shadow, 1, {alpha: 0});

				var destScale:Number=shadow.width / img.width;

				TweenLite.to(img, .5, {scaleX: destScale, scaleY: destScale,
						x: destPos.x, y: destPos.y, onComplete: checkResult});
			});
		}

		private function playBug(destPos:Point):void
		{
			this.setChildIndex(bug, this.numChildren - 1);
			var dy:Number=bug.y - 100;
			TweenLite.to(bug, 1.5, {x: 1024, y: dy, ease: Elastic.easeIn});
			TweenLite.delayedCall(2, function():void {
				bug.x=-100;
				bug.y=-100;
				bug.scaleX=bug.scaleY=1;
				var index:int=destPosArr.indexOf(destPos);
				var img:Image=shadowArr[index] as Image;
				TweenLite.to(img, 1, {alpha: 0});
				var destScale:Number=img.width / bug.width;
				TweenLite.to(bug, .5, {x: destPos.x - 5, y: destPos.y - 5, scaleX: destScale, scaleY: destScale,
						onComplete: checkResult});

			});
		}

		private var drum:Image;
		private var flute:Image;
		private var bug:Image;

		private function checkResult():void
		{
			checkCount++;
			if (checkCount == 3)
				isWin=true;
		}

		private var checkCount:int=0;
		private var bugS:MovieClip;
		private var bugB:MovieClip;
	}
}
