package views.module6
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.PalaceStars;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module2.scene21.recycle.JigsawGame;
	import views.module6.scene61.PicGame1;
	import views.module6.scene61.PicGame3;

	public class Scene61 extends PalaceScene
	{
		private var game2:JigsawGame;

		private var bbg:Sprite;
		private var dpt:Point;
		public function Scene61(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=4;
			bbg=new Sprite();
			bbg.addChild(getImage('bg61'));
			addChild(bbg);

			bbg.x=1024-bbg.width>>1;

			var king:Image=getImage('king');
			king.x=1024-king.width>>1;
			king.y=768-king.height;
			addChild(king);

			king.addEventListener(TouchEvent.TOUCH,onKingTouch);

			bagSP=new Sprite();
			addChild(bagSP);
			var bag:Image=getImage('bag');

			var kx:Number=king.x;
			var ky:Number=king.y;

			bagSP.addChild(bag);
			bag.x=kx+130; 
			bag.y=ky+287;

			arrowPosArr.push(new Point(kx+1,ky+194));
			arrowPosArr.push(new Point(kx+2,ky+147));
			arrowPosArr.push(new Point(kx+42,ky+143));

			initAreas();

			addEventListener('showCollection',onCollection);
		}

		private function onKingTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(e.currentTarget as DisplayObject,TouchPhase.ENDED);
			if(tc)
				Prompt.showTXT(580,540,'不是射箭吗？为什么来这里？');
		}

		override protected function init():void
		{
			super.init();
			Prompt.showTXT(580,540,'不是射箭吗？为什么来这里？',20,lionSay);
		}

		private function lionSay():void
		{
			LionMC.instance.say('快找到练习用的箭，玄机就在画中！',0,0,0,function():void{
				bbg.addEventListener(TouchEvent.TOUCH,onBGTouch);
				birdIndex=2;
			},20,true);
		}

		private function onCollection(e:Event):void
		{
			if(e.target==game1)
			{
				showCard('16');
			}else if(e.target==game3)
			{
				showCard('17');
			}
			else if(e.target==game2)
			{
				showCard('18');
			}
		}

		private function initAreas():void
		{
			areaArr.push(new Rectangle(145,97,312,434));
			areaArr.push(new Rectangle(707,97,312,434));
			areaArr.push(new Rectangle(1217,97,312,434));

			addCraw(new Point(432,507),null,bbg);
			addCraw(new Point(979,507),null,bbg);
			addCraw(new Point(1488,507),null,bbg);
		}

		private var arrowsArr:Array;

		private var arrowPosArr:Array=[];

		private var areaArr:Array=[];

		private function onBGTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(bbg);
			if (!tc)
				return;

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=tc.getLocation(this);
					break;
				}

				case TouchPhase.MOVED:
				{
					var mov:Point=tc.getMovement(this);
					bbg.x+=mov.x;
					if(bbg.x>0)
						bbg.x=0;
					else if(bbg.x<1024-bbg.width)
						bbg.x=1024-bbg.width;
					break;
				}

				case TouchPhase.ENDED:
				{
					var pt:Point=tc.getLocation(this);
					if (dpt && Point.distance(dpt, pt) < 10)
						checkArea(tc.getLocation(bbg));
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkArea(pt:Point):void
		{
			for (var i:int = 0; i < areaArr.length; i++) 
			{
				var rect:Rectangle=areaArr[i];
				if(rect.containsPoint(pt))
				{
					enterGame(i);
					return;
				}
			}

		}

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(3);

		private var bagSP:Sprite;
		private var game1:PicGame1;
		private var game3:PicGame3;

		private function enterGame(i:int):void
		{
			switch(i)
			{
				case 0:
				{
					initGame1();
					break;
				}

				case 1:
				{
					initGame2();
					break;
				}

				case 2:
				{
					initGame3();
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function onGame1Played(e:Event):void
		{
			if (game1.isWin)
				playStars(0);
			playArrow(0);
			game1.removeEventListener(PalaceGame.GAME_OVER, onGame1Played)
			game1.removeChildren();
			removeChild(game1);
			game1=null;
		}

		private function initGame1():void
		{
			game1=new PicGame1(assetManager);
			game1.addEventListener(PalaceGame.GAME_OVER, onGame1Played)
			addChild(game1);
		}

		private function initGame2():void
		{
			game2=new JigsawGame(assetManager);
			game2.addEventListener(PalaceGame.GAME_OVER, onGame2Played)
			addChild(game2);
		}

		private function onGame2Played(e:Event):void
		{
			if (game2.isWin)
				playStars(1);
			playArrow(1);
			game2.removeEventListener(PalaceGame.GAME_OVER, onGame2Played)
			game2.removeChildren();
			removeChild(game2);
			game2=null;
		}

		private function initGame3():void
		{
			game3=new PicGame3(assetManager);
			game3.addEventListener(PalaceGame.GAME_OVER, onGame3Played)
			addChild(game3);
		}

		private function onGame3Played(e:Event):void
		{
			if (game3.isWin)
				playStars(2);
			playArrow(2);
			game3.removeEventListener(PalaceGame.GAME_OVER, onGame3Played)
			game3.removeChildren();
			removeChild(game3);
			game3=null;
		}

		private function playStars(i:int):void
		{
			var rect:Rectangle=areaArr[i];
			new PalaceStars(rect.x+rect.width/2+bbg.x,rect.y+rect.height/2,this);
		}

		private function playArrow(i:int):void
		{
			if(!checkArr[i])
			{
				touchable=false;

				checkArr[i]=true;
				var arrow:Image=getImage('arrow');
				arrow.scaleX=.1;
				arrow.scaleY=.1;
				var rect:Rectangle=areaArr[i];
				arrow.x=rect.x+rect.width/2+bbg.x;
				arrow.y=rect.y+rect.height/2;
				bagSP.addChildAt(arrow,0);
				TweenLite.to(arrow,1,{scaleX:1,scaleY:1,x:0,y:150,onComplete:step2});

				function step2():void
				{
					var dx:Number=arrowPosArr[i].x;
					var dy:Number=arrowPosArr[i].y;
					TweenLite.to(arrow,1,{x:dx,y:dy,onComplete:checkFinish});
				}
			}
		}

		private function checkFinish():void
		{
			touchable=true;
			for each (var b:Boolean in checkArr) 
			{
				if(!b)
					return;
			}
			sceneOver();
		}
	}
}

