package views.module3
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.Lion;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module3.scene31.FindGame;
	import views.module3.scene31.JigsawGame;

	public class Scene31 extends PalaceScene
	{
		private var mapGame:JigsawGame;

		private var map:Image;


		public function Scene31(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=5;
			addChild(getImage("bg31"));

			addShelfs();

			var table:Image=getImage("table31");
			table.x=260;
			table.y=223;
			addChild(table);
			table.touchable=false;

			can=getImage("can31");
			can.y=291;
			addChild(can);
			can.addEventListener(TouchEvent.TOUCH, onCanTouch);

			var curtainL:Image=getImage("curtain-l");
			addChild(curtainL);
			curtainL.touchable=false;
			var curtainR:Image=getImage("curtain-r");
			curtainR.x=1024 - 245;
			addChild(curtainR);
			curtainR.touchable=false;

			map=getImage("map31");
			map.x=444;
			map.y=596;
			addChild(map);
			map.addEventListener(TouchEvent.TOUCH, onMapTouch);

			playLion();
		}

		private function onCanTouch(e:TouchEvent):void
		{
			if (!ready)
				return;
			var tc:Touch=e.getTouch(can, TouchPhase.ENDED);
			if (tc)
				if (canArea.containsPoint(tc.getLocation(this)))
					initFindGame();
		}

		private function playLion():void
		{
			lion=new Lion();
			lion.src=getImage("lion");
			addChild(lion);

			lion.x=-140;
			lion.y=300;
			lion.rotation=-Math.PI / 4;
			TweenLite.to(lion, .8, {x: 30, y: 540, rotation: 0, ease: Elastic.easeOut, onComplete: function():void
			{
				lion.say("hint31-find", "hint-bg", function():void {
					TweenLite.to(lion, .5, {x: -140, onComplete: function():void
					{
						ready=true;
					}
						});
				});
			}});
		}

		private function onMapTouch(e:TouchEvent):void
		{
			if (!ready)
				return;
			var tc:Touch=e.getTouch(map, TouchPhase.ENDED);
			if (tc)
				initGame();
		}
		private var canArea:Rectangle=new Rectangle(55, 423, 105, 331);

		private var dataArrR:Array=[7, 3, 8, 1, 2, 5, 9, 10, 4, 6, 11];
		private var posArrR:Array=[new Point(99, 48), new Point(243, 72), new Point(107, 194), new Point(242, 184), new Point(373, 207),
			new Point(72, 336), new Point(155, 355), new Point(248, 338), new Point(94, 468), new Point(220, 476), new Point(356, 440)];
		private var dataArrL:Array=[1, 2, 3, 7, 8, 9, 10, 11, 4, 5, 6];
		private var posArrL:Array=[new Point(97, 50), new Point(201, 74), new Point(305, 74), new Point(81, 183), new Point(224, 194),
			new Point(310, 213), new Point(100, 337), new Point(235, 327), new Point(90, 466), new Point(189, 453), new Point(294, 475)];

		private var innerX:Number=300;
		private var rx:Number=1024 - 457;

		private function addShelfs():void
		{
			shelfL=new Sprite();
			shelfL.addChild(getImage("bookshelf"));
			for (var i:int=0; i < dataArrL.length; i++)
			{
				var book:Image=getImage("book" + dataArrL[i].toString());
				book.x=posArrL[i].x;
				book.y=posArrL[i].y;
				book.addEventListener(TouchEvent.TOUCH, onBookTouch);
				shelfL.addChild(book);
			}
			shelfL.x=-innerX;
			addChild(shelfL)
			shelfL.addEventListener(TouchEvent.TOUCH, onLShelfTouch);

			shelfR=new Sprite();
			shelfR.addChild(getImage("bookshelf-r"));
			for (var j:int=0; j < dataArrR.length; j++)
			{
				var book1:Image=getImage("book" + dataArrR[j].toString());
				book1.x=posArrR[j].x;
				book1.y=posArrR[j].y;
				book1.addEventListener(TouchEvent.TOUCH, onBookTouch);
				shelfR.addChild(book1);
			}
			shelfR.x=rx + innerX;
			addChild(shelfR)
			shelfR.addEventListener(TouchEvent.TOUCH, onRShelfTouch);
		}

		private function onLShelfTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(shelfL, TouchPhase.MOVED);
			if (tc)
				moveShelf(tc.getMovement(this).x)
		}

		private function onRShelfTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(shelfR, TouchPhase.MOVED);
			if (tc)
				moveShelf(-tc.getMovement(this).x)
		}

		private function moveShelf(dx:Number):void
		{
			shelfL.x=Math.max(0 - innerX, Math.min(shelfL.x + dx, 0));
			shelfR.x=Math.max(rx, Math.min(shelfR.x - dx, rx + innerX));
			shelfOpen=shelfL.x == 0;
		}

		private var probability:Number=0;
		private var ready:Boolean;

		private var lion:Lion;

		private var shelfL:Sprite;

		private var shelfR:Sprite;
		private var shelfOpen:Boolean;
		private var gamePlayed:Boolean;
		private var bookFinded:Boolean;

		private var bigBook:Sprite;
		private var finded:Boolean;
		private var findGame:FindGame;

		private var can:Image;

		private function onBookTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			if (!ready || !shelfOpen || bookFinded)
				return;
			var book:Image=e.currentTarget as Image;
			if (!book)
				return;
			var tc:Touch=e.getTouch(book, TouchPhase.ENDED);
			if (!tc)
				return;
			if (!book.hitTest(tc.getLocation(book)))
				return;
			if (Math.random() < probability)
			{
				bookFinded=true;
				showBigBook();
				setChildIndex(lion, numChildren - 1);
				TweenLite.to(lion, .5, {x: 30, onComplete: function():void {
					lion.say("hint31-right", "hint-bg", function():void {
						TweenLite.to(lion, .5, {x: -140});
					});
				}
					});
			}
			else
			{
				var pr:Sprite=book.parent as Sprite;
				var pt:Point=new Point(book.x + book.width / 2 + pr.x, book.y + book.height / 2);
				Prompt.show(pt.x, pt.y, "hint-bg", "hint31-wrong", 1);
			}
			book.removeEventListener(TouchEvent.TOUCH, onBookTouch);
			probability+=.2;
		}

		private function showBigBook():void
		{
			bigBook=new Sprite();
			bigBook.addChild(getImage("book-big"));
			var close:ElasticButton=new ElasticButton(getImage("button_close"));
			close.x=840;
			close.y=55;
			bigBook.addChild(close);
			bigBook.x=46;
			bigBook.y=2;
			close.addEventListener(ElasticButton.CLICK, onCloseBook);
			addChild(bigBook);
		}

		private function onCloseBook(e:Event):void
		{
			sceneOver();
			removeChild(bigBook);
		}

		private function sceneOver():void
		{
			if (gamePlayed && bookFinded && finded)
				dispatchEvent(new Event("gotoNext", true));
		}

		private function initGame():void
		{
			mapGame=new JigsawGame(assets);
			mapGame.addEventListener("gameOver", onGamePlayed)
			mapGame.addEventListener("gameRestart", onGameRestart)
			addChild(mapGame);
		}

		private function onGamePlayed(e:Event):void
		{
			mapGame.removeEventListener("gameOver", onGamePlayed)
			mapGame.removeEventListener("gameRestart", onGameRestart)
			mapGame.removeChildren();
			removeChild(mapGame);
			mapGame=null;
			gamePlayed=true;
			sceneOver();
		}

		private function initFindGame():void
		{
			findGame=new FindGame(assets);
			findGame.addEventListener("gameOver", onFindGamePlayed)
			addChild(findGame);
		}

		private function onFindGamePlayed(e:Event):void
		{
			findGame.removeEventListener("gameOver", onFindGamePlayed)
			findGame.removeChildren();
			removeChild(mapGame);
			findGame=null;
			finded=true;
			sceneOver();
		}

		private function onGameRestart(e:Event):void
		{
			mapGame.removeEventListener("gameOver", onGamePlayed);
			mapGame.removeEventListener("gameRestart", onGameRestart);
			mapGame.removeChildren();
			removeChild(mapGame);
			mapGame=null;

			mapGame=new JigsawGame(assets);
			addChild(mapGame);
			mapGame.addEventListener("gameOver", onGamePlayed);
			mapGame.addEventListener("gameRestart", onGameRestart);
		}
	}
}
