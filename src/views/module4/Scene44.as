package views.module4
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
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
			fg.addChild(getImage("fg44"));
			fg.x=1024 - _W >> 1;
			addChild(fg);

			addKite();
			addFlowers();
			addTrees();
			addKing();

			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
		private var kiteBounds:Rectangle=new Rectangle(913, 16, 20, 20);
		private var linePos:Point=new Point(997, 96);
		private var lineDis:Point;

		private function getRandomSpeed():Number
		{
			return (.2 + Math.random() * .2); //.2-.4
		}

		private function addKite():void
		{
			windX=(Math.random() > .5 ? 1 : -1) * getRandomSpeed();
			windY=(Math.random() > .5 ? 1 : -1) * getRandomSpeed();

			line=getImage("kite-line");
			fg.addChild(line);
			line.x=linePos.x;
			line.y=linePos.y;
			lineDis=new Point(line.x + line.width, line.y + line.height);

			kite=new Kite();
			kite.addChild(getImage("kite"));
			fg.addChild(kite);
			kite.x=923;
			kite.y=26;
			kite.isFree=false;
			kite.addEventListener(TouchEvent.TOUCH, onKiteTouch);
		}

		private function onKiteTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(kite, TouchPhase.ENDED);
			if (!tc)
				return;
			kite.isFree=true;
			TweenLite.to(line, 1, {alpha: 0});
			TweenLite.to(kite, 3, {x: 923 - 300, y: 26 - 200, onComplete: resetKite, ease: Quad.easeOut});
			checkOver(1);
		}

		private function resetKite():void
		{
			kite.x=lineDis.x;
			kite.y=lineDis.y;
			kite.scaleX=kite.scaleY=.3;

			TweenMax.to(kite, 3, {scaleX: 1, scaleY: 1, bezier: [{x: 923, y: lineDis.y}, {x: 923, y: 26}], ease: Quad.easeInOut,
							onComplete: function():void {
								kite.isFree=false;
								TweenLite.to(line, .2, {alpha: 1});
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

		private var line:Image;

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
			TweenMax.to(tree, 3, {shake: {rotation: .1, numShakes: 2}, onComplete: function():void {
				tree.touchable=true;
			}})
		}

		private function onEnterFrame(e:Event):void
		{
			if (kite.isFree)
				return;
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
				windY=windX=reverseSpeed(windY);
				kite.y=kiteBounds.y
			}
			else if (kite.y > kiteBounds.y + kiteBounds.height)
			{
				windY=windX=reverseSpeed(windY);
				kite.y=kiteBounds.y + kiteBounds.height
			}

			line.x=linePos.x + (kite.x - 923) / 2.5;
			line.y=linePos.y + (kite.y - 26) / 2.5;
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
