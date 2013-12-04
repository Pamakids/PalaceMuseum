
package views.module4
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;

	import controllers.SoundManager;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module4.scene44.Flower;

	public class Scene44 extends PalaceScene
	{
		private var _W:Number=1664;

		private var bg2:Image;
		private var birdLayer:Sprite;
		private var fg:Sprite;
		private var king:Sprite;
		private var flowerPos:Object;
		private var dpt:Point;

		public function Scene44(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=11;

			flowerPos=assetManager.getObject("flowerPos");

			bg2=getImage("bg44");
			bg2.x=1024 - _W >> 1;
			addChild(bg2);

			fg=new Sprite();
			fg.x=1024 - _W >> 1;
			addChild(fg);

			addKite();

			birdLayer=new Sprite();
			fg.addChild(birdLayer);

			var fgImg:Image=getImage("fg44");
			fgImg.touchable=false;
			fg.addChild(fgImg);

			addBtrees();
			addFlowers();
			addTrees();
			addKing();

			moveBG(200)
			outMove=true;

			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var outMove:Boolean;

		private function addBtrees():void
		{
			var t1:Image=getImage("treeb1");
			t1.pivotX=t1.width >> 1;
			t1.pivotY=t1.height;
			t1.x=160 + t1.pivotX;
			t1.y=-71 + t1.pivotY;
			fg.addChild(t1);
			t1.addEventListener(TouchEvent.TOUCH, onTreeTouch);

			var t2:Image=getImage("treeb2");
			t2.pivotX=t2.width >> 1;
			t2.pivotY=t2.height;
			t2.x=1207 + t2.pivotX;
			t2.y=-71 + t2.pivotY;
			fg.addChild(t2);
			t2.addEventListener(TouchEvent.TOUCH, onTreeTouch);

			var ts:Image=getImage("trees2");
			ts.x=1379;
			ts.y=52;
			ts.touchable=false;
			fg.addChild(ts);
		}

		private function addKing():void
		{
			king=new Sprite();
			king.addChild(getImage("king-1"));
//			king.touchable=false;
			king.addEventListener(TouchEvent.TOUCH, onKingTouch);
			addChild(king);
			king.x=1024 - king.width >> 1;
			king.y=768 - king.height;
		}

		private function onKingTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(king, TouchPhase.ENDED);
			if (tc)
				Prompt.showTXT(512, 600, "哇，连石子路都这么漂亮！", 20, null, this);
		}

		private var windX:Number;
		private var windY:Number;
		private var kiteBounds:Rectangle;
		private var lineDis:Point=new Point(1180, 326);
		private var kitePos:Point=new Point(972, 70);

		private function getRandomSpeed():Number
		{
			return (.1 + Math.random() * .3); //.2-.4
		}

		private function addKite():void
		{
			windX=(Math.random() > .5 ? 1 : -1) * getRandomSpeed();
			windY=(Math.random() > .5 ? 1 : -1) * getRandomSpeed();

			line=new Sprite();
			var lineImg:Image=getImage("kite-line");
			line.addChild(lineImg);
			lw=lineImg.width;
			lh=lineImg.height;
			line.pivotX=lw;
			line.pivotY=lh;
			line.x=lineDis.x;
			line.y=lineDis.y;
			line.touchable=false;

			kite=getImage("kite");
			kite.x=kitePos.x;
			kite.y=kitePos.y;
			isFree=false;
			kite.addEventListener(TouchEvent.TOUCH, onKiteTouch);

			resetKiteBounds();

			fg.addChild(kite);
			fg.addChild(line);

			resetLine();
		}

		private var isFree:Boolean;

		private function onKiteTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(kite, TouchPhase.ENDED);
			if (!tc)
				return;
			kite.touchable=false;
			isFree=true;
			var dx:Number=kite.x - 200;
			TweenLite.to(kite, 3, {x: dx, y: -30, onComplete: stickKite, ease: Quad.easeOut});
		}

		private function stickKite():void
		{
			isFree=false;
			resetKiteBounds();
			showCard("15", function():void {
				checkOver(1);
				TweenLite.delayedCall(3, resetKite);
			});
		}

		private function resetKiteBounds():void
		{
			kiteBounds=new Rectangle(kite.x - 10, kite.y - 10, 20, 20)
		}

		private function resetKite():void
		{
			isFree=true;
			TweenLite.to(kite, 3, {x: kitePos.x, y: kitePos.y, ease: Bounce.easeIn,
							 onComplete: function():void {
								 kite.touchable=true;
								 isFree=false;
								 resetKiteBounds();
							 }});
		}

		private function addFlowers():void
		{
			var str:String;
			var pos:Array;
			for (var i:int=0; i < 15; i++)
			{
				str="flower" + (i + 1).toString();
				pos=flowerPos[str];

				var flower:Flower=new Flower()
				fg.addChild(flower);
				flower.x=pos[0];
				flower.y=pos[1];
				flower.initFlower(getImage(str), getImage(str + "-1"));
				flower.addEventListener(TouchEvent.TOUCH, onFlowerTouch);
			}
		}

		private function onFlowerTouch(e:TouchEvent):void
		{
			var flower:Flower=e.currentTarget as Flower;
			if (!flower)
				return;
			var tc:Touch=e.getTouch(flower, TouchPhase.ENDED);
			if (!tc)
				return;
			flower.isOpen=!flower.isOpen;
			checkOver(0)
		}

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(3);

		private var kite:Image;

		private var line:Sprite;

		private var lw:Number;

		private var lh:Number;

		private function checkOver(index:int):void
		{
			if (!checkArr)
				return;
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			checkArr=null;
			startPlayNotes();
			sceneOver();
		}

		private function startPlayNotes():void
		{
			king.removeFromParent(true);

			king=new Sprite();
			king.addChild(getImage("king-2"));
			king.touchable=false;
			addChild(king);
			king.x=1024 - king.width >> 1;
			king.y=768 - king.height;

			SoundManager.instance.play("gamebg52", 0, .5);
			playNote();
		}

		private function playNote():void
		{
			var delay:Number=.2 + Math.random() * .5;
			TweenLite.delayedCall(delay, playNote); //1s
			var scale:Number=Math.random() * .6 + .4;
			var index:int=Math.random() * 3;
			var note:Image=getImage("note" + index);
			note.pivotX=note.width >> 1;
			note.pivotY=note.height >> 1;
			note.scaleX=note.scaleY=scale;
			note.touchable=false;
			note.x=1100;
			note.y=600;
			addChild(note);
			TweenMax.to(note, 4, {bezier: [{x: 930, y: 550}, {x: 830, y: 650}, {x: 730, y: 550}, {x: 630, y: 600}],
							rotation: Math.PI * -2, scaleX: .25, scaleY: .25, ease: Quad.easeIn,
							onComplete: function():void {
								endNote(note);
							}});
		}

		private function endNote(note:Image):void
		{
			TweenLite.to(note, .5, {x: 612, y: 613, scaleX: .1, scaleY: .1, alpha: 0, onComplete: function():void {
				note.removeFromParent(true);
			}});
		}

		override public function dispose():void
		{
			SoundManager.instance.stop("gamebg52");
			TweenLite.killTweensOf(playNote);
			TweenLite.killTweensOf(this);
			super.dispose();
		}

		private function addTrees():void
		{
			var t1:Image=getImage("tree-1");
			t1.pivotX=t1.width;
			t1.pivotY=t1.height;
			t1.x=1401 + t1.pivotX;
			t1.y=35 + t1.pivotY;
			fg.addChild(t1);
			t1.addEventListener(TouchEvent.TOUCH, onTreeTouch);

			var t2:Image=getImage("tree-2");
			t2.pivotY=t2.height;
			t2.x=-36 + t2.pivotX;
			t2.y=82 + t2.pivotY;
			fg.addChild(t2);
			t2.addEventListener(TouchEvent.TOUCH, onTreeTouch);
		}

		private function onTreeTouch(e:TouchEvent):void
		{
			var tree:Image=e.currentTarget as Image;
			if (!tree)
				return;
			var tc:Touch=e.getTouch(tree, TouchPhase.ENDED);
			if (!tc)
				return;
			tree.touchable=false;
			var b:Boolean=tree.width > 400;
			var r:Number=b ? .005 : .02;
			var n:int=b ? 4 : 2;
			var d:Number=b ? 1 : 2.5;
			TweenMax.to(tree, d, {shake: {rotation: r, numShakes: n}, onComplete: function():void {
				tree.touchable=true;
			}})

			if (b)
				addBrids(tree.x < 800) //左
		}

		private function addBrids(isleft:Boolean):void
		{
			checkOver(2);
			var r:Rectangle=isleft ? birdArea1 : birdArea2;
			var birdNum:int=Math.random() < .5 ? 2 : 3; //2-4
			for (var i:int=0; i < birdNum; i++)
			{
				addOneBird(isleft, r);
			}
		}

		private var prob:Number=.8;

		private function addOneBird(isleft:Boolean, r:Rectangle):void
		{
			var toleft:Boolean=isleft ? Math.random() > prob : Math.random() < prob; //左边小概率左飞,右边大概率左飞
			var sx:Number=r.x + Math.random() * r.width;
			var sy:Number=r.y + Math.random() * r.height;
			var color:String=Math.random() > .5 ? "y" : "p"; //黄,紫
			var scale:Number=Math.random() * .6 + .2;
			var bird:MovieClip=new MovieClip(assetManager.getTextures(color + "bird"));
			bird.scaleX=(toleft ? -1 : 1) * scale; //水平翻转
			bird.scaleY=scale;
			birdLayer.addChild(bird);
			Starling.juggler.add(bird);
			bird.loop=true;
			bird.play();
			bird.x=sx;
			bird.y=sy;
			var dx:Number=r.x + (toleft ? -1 : 1) * (300 + Math.random() * 900);
			var dy:Number=-100 - Math.random() * 200; //保证出屏幕
			var delay:Number=3 + Math.random() * 3;
			assetManager.playSound("bird", 0, 0, new SoundTransform(scale));
			TweenLite.to(bird, delay, {x: dx, y: dy, onComplete: function():void {
				Starling.juggler.remove(bird);
				bird.stop();
				bird.removeFromParent(true);
				bird=null;
			}});
		}

		private var birdArea1:Rectangle=new Rectangle(285, 38, 100, 200);
		private var birdArea2:Rectangle=new Rectangle(1250, 100, 100, 250);

		private var count:int=0;

		private function onEnterFrame(e:Event):void
		{
			if (outMove)
			{
				count++;
				if (count > 60)
					outMove=false;
				moveBG(-10);
			}
			if (!isFree)
			{
				kite.x+=windX;
				if (kite.x < kiteBounds.x)
				{
					windX=reverseSpeed(windX);
					kite.x=kiteBounds.x
				}
				else if (kite.x > kiteBounds.x + kiteBounds.width)
				{
					windX=reverseSpeed(windX);
					kite.x=kiteBounds.x + kiteBounds.width
				}

				kite.y+=windY;
				if (kite.y < kiteBounds.y)
				{
					windY=reverseSpeed(windY);
					kite.y=kiteBounds.y
				}
				else if (kite.y > kiteBounds.y + kiteBounds.height)
				{
					windY=reverseSpeed(windY);
					kite.y=kiteBounds.y + kiteBounds.height
				}
			}

			resetLine();
		}

		private function resetLine():void
		{
			line.width=Math.abs(kite.x + 69 - lineDis.x);
			line.height=Math.abs(kite.y + 56 - lineDis.y);
		}

		private function reverseSpeed(speed:Number):Number
		{
			return (speed > 0 ? -1 : 1) * getRandomSpeed();
		}

		private function onTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			outMove=false;
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (!dpt)
						return;
					var delta:Point=tc.getMovement(this);
					var dx:Number=delta.x;
					moveBG(dx);
					break;
				}
				case TouchPhase.ENDED:
				{
					dpt=null;
					break;
				}
				default:
				{
					break;
				}
			}
		}

		private function moveBG(dx:Number):void
		{
			var tx:Number=fg.x + dx / 2;
			if (tx < (1024 - _W))
				dx=(1024 - _W - fg.x) * 2;
			else if (tx > 0)
				dx=(0 - fg.x) * 2;
			bg2.x+=dx / 5;
			fg.x+=dx / 2;
		}
	}
}
