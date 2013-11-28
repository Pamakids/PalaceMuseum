package views.module4
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module4.scene44.Flower;
	import views.module4.scene44.Kite;

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

			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

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
			king.touchable=false;
			addChild(king);
			king.x=1024 - king.width >> 1;
			king.y=768 - king.height;
		}

		private var windX:Number;
		private var windY:Number;
		private var kiteBounds:Rectangle;
		private var linePos:Point=new Point(997 - 5, 96 - 10);
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

			kite=new Kite();
			kite.addChild(getImage("kite"));
			kite.x=kitePos.x;
			kite.y=kitePos.y;
			kite.isFree=false;
			kite.addEventListener(TouchEvent.TOUCH, onKiteTouch);

			resetKiteBounds();
//			kiteBounds=new Rectangle(kitePos.x - 10, kitePos.y - 10, 20, 20)

			fg.addChild(kite);
			fg.addChild(line);
		}

		private function onKiteTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(kite, TouchPhase.ENDED);
			if (!tc)
				return;
			kite.touchable=false;
			kite.isFree=true;
			var dx:Number=kite.x - 200;
			TweenLite.to(kite, 3, {x: dx, y: -30, onComplete: stickKite, ease: Quad.easeOut});
			checkOver(1);
		}

		private function stickKite():void
		{
			resetKiteBounds();
			kite.isFree=false;
			TweenLite.delayedCall(3, resetKite);
		}

		private function resetKiteBounds():void
		{
			kiteBounds=new Rectangle(kite.x - 10, kite.y - 10, 20, 20)
		}

		private function resetKite():void
		{
			kite.isFree=true;
			TweenLite.to(kite, 3, {x: kitePos.x, y: kitePos.y, ease: Bounce.easeIn,
							 onComplete: function():void {
								 kite.touchable=true;
								 kite.isFree=false;
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

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(2);

		private var kite:Kite;

		private var line:Sprite;

		private var lw:Number;

		private var lh:Number;

		private function checkOver(index:int):void
		{
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			sceneOver();
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
			var r:Rectangle=isleft ? birdArea1 : birdArea2;
			var birdNum:int=Math.random() < .5 ? 2 : 4; //2-4
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
			var bird:MovieClip=new MovieClip(assetManager.getTextures(color + "bird"));
			bird.scaleX=toleft ? -1 : 1; //水平翻转
			birdLayer.addChild(bird);
			Starling.juggler.add(bird);
			bird.loop=true;
			bird.play();
			bird.x=sx;
			bird.y=sy;
			var dx:Number=r.x + (toleft ? -1 : 1) * (300 + Math.random() * 900);
			var dy:Number=-100 - Math.random() * 200; //保证出屏幕
			var delay:Number=3 + Math.random() * 3;
			assetManager.playSound("bird");
			TweenLite.to(bird, delay, {x: dx, y: dy, onComplete: function():void {
				Starling.juggler.remove(bird);
				bird.stop();
				bird.removeFromParent(true);
				bird=null;
			}});
		}

		private var birdArea1:Rectangle=new Rectangle(285, 38, 100, 200);
		private var birdArea2:Rectangle=new Rectangle(1250, 100, 100, 250);

		private function onEnterFrame(e:Event):void
		{
			if (!kite.isFree)
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

			line.width=lw - (kite.x - kitePos.x) - 44;
			line.height=lh - (kite.y - kitePos.y) - 37;
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
					var tx:Number=fg.x + dx / 2;
					if (tx < (1024 - _W))
						dx=(1024 - _W - fg.x) * 2;
					else if (tx > 0)
						dx=(0 - fg.x) * 2;
					bg2.x+=dx / 5;
					fg.x+=dx / 2;
//					king.x+=dx / 5;
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
	}
}
