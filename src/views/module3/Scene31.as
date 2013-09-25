package views.module3
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.Lion;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module3.scene31.FindGame;
	import views.module3.scene31.JigsawGame;
	import views.module3.scene31.ShelfBook;

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

		private var nameArr:Array=["《蒙语入门》", "《学藏语》", "《资治通鉴》", "《三国志传》", "《四书》", "《五经》", "《全唐诗》"];

		private var lIndexArr:Array=[7, 10];
		private var rIndexArr:Array=[1, 3, 4, 7, 9, 10];

		private function addShelfs():void
		{
			shelfL=new Sprite();
			shelfL.addChild(getImage("bookshelf"));
			for (var i:int=0; i < dataArrL.length; i++)
			{
				var book:ShelfBook=new ShelfBook();
				book.addChild(getImage("book" + dataArrL[i].toString()));

				book.x=posArrL[i].x;
				book.y=posArrL[i].y;
				book.bookname=nameArr[int(Math.random() * nameArr.length)]
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
				var book1:ShelfBook=new ShelfBook();
				book1.addChild(getImage("book" + dataArrR[j].toString()));
				book1.x=posArrR[j].x;
				book1.y=posArrR[j].y;
				book1.bookname=nameArr[int(Math.random() * nameArr.length)]
				book1.addEventListener(TouchEvent.TOUCH, onBookTouch);
				shelfR.addChild(book1);
			}
			shelfR.x=rx + innerX;
			addChild(shelfR);
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
			shelfOpen=shelfL.x > -100;
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
			if (!ready || !shelfOpen)
				return;
			var book:ShelfBook=e.currentTarget as ShelfBook;
			if (!book)
				return;
			var tc:Touch=e.getTouch(book, TouchPhase.ENDED);
			if (!tc)
				return;
			if (!book.hitTest(tc.getLocation(book)))
				return;

			var pr:Sprite=book.parent as Sprite;
			var pt:Point=new Point(book.x + book.width / 2, book.y + book.height / 2);
			var align:int=1;
			if (checkAlign(book))
				align=3;
			if (book.clicked)
				Prompt.showTXT(pt.x, pt.y, book.bookname, 24, null, pr, align, true)
			else
			{
				if ((Math.random() < probability && !bookFinded) || rightBook == book)
				{
					showAchievement(6);
					rightBook=book;
					bookFinded=true;
					showBigBook();
					setChildIndex(lion, numChildren - 1);
					TweenLite.killTweensOf(lion);
					TweenLite.to(lion, .5, {x: 30, onComplete: function():void {
						lion.say("hint31-right", "hint-bg", function():void {
							TweenLite.to(lion, .5, {x: -140});
						});
					}
						});
				}
				else
				{
					Prompt.showTXT(pt.x, pt.y, book.bookname, 24, null, pr, align, true)
					probability+=.2;
					book.clicked=true;
//				Prompt.show(pt.x, pt.y, "hint-bg", "hint31-wrong", 1);
				}
			}
		}

		private function checkAlign(book:ShelfBook):Boolean
		{
			var pt:Point=new Point(book.x, book.y);
			var index:int=findIndex(pt, posArrL);
			if (index >= 0)
			{
				if (lIndexArr.indexOf(index) >= 0)
					return true;
			}
			else
			{
				index=findIndex(pt, posArrR);
				if (index >= 0)
					if (rIndexArr.indexOf(index) >= 0)
						return true;
			}
			return false;
		}

		private function findIndex(pt:Point, arr:Array):int
		{
			for each (var p:Point in arr)
			{
				if (p.x == pt.x && p.y == pt.y)
					return arr.indexOf(p);
			}
			return -1;
		}

		private var rightBook:ShelfBook;

		private function showBigBook():void
		{
			if (!bigBook)
			{
				bigBook=new Sprite();
				var img:Image=getImage("book-big");
				bigBook.addChild(img);
				img.x=219;
				img.y=138;
//				img.addEventListener(TouchEvent.TOUCH, onBigBookTouch);

				bigBook.pivotX=512;
				bigBook.pivotY=384;
				bigBook.x=512;
				bigBook.y=384;
				var close:ElasticButton=new ElasticButton(getImage("button_close"));
				bigBook.addChild(close);
				close.x=840;
				close.y=55;
				close.addEventListener(ElasticButton.CLICK, onCloseBook);

				var hint:Sprite=new Sprite();
				bigBook.addChild(hint);
				hint.x=568;
				hint.y=480;
				var bgImage:Image=getImage("hint-bg-k-large");
				hint.addChild(bgImage);
				var t:TextField=new TextField(bgImage.width - 30, bgImage.height - 10, bookTxt, FontVo.PALACE_FONT, 24, 0x561a1a, true);
				t.x=bgImage.x + 15;
				t.y=bgImage.y;
				t.touchable=false;
				t.hAlign="center";
				hint.addChild(t);
				hint.pivotY=bgImage.height;
			}
			bigBook.scaleX=.1;
			bigBook.scaleY=.1;
			PopUpManager.addPopUp(bigBook, true, false)
			TweenLite.to(bigBook, 1, {scaleX: 1, scaleY: 1});


		}

		private function onBigBookTouch(e:TouchEvent):void
		{
			var img:Image=e.currentTarget as Image;
			var tc:Touch=e.getTouch(img, TouchPhase.ENDED);
			if (tc)
				Prompt.showTXT(568, 480, bookTxt, 20, null, bigBook, 1, true);
		}

		private var bookTxt:String="清朝皇帝对大臣的指\n令和讲话称为“圣训”。\n后继位的皇帝每天早读\n时首先会读一段圣训，\n学习领会祖先的教导。";

		private function onCloseBook(e:Event):void
		{
			sceneOver();
			PopUpManager.removePopUp(bigBook);
		}

		private function checkOver():void
		{
//			if (gamePlayed && bookFinded && finded)
//				sceneOver();
		}

		private function initGame():void
		{
			mapGame=new JigsawGame(assets);
			mapGame.addEventListener("gameOver", onGamePlayed)
			mapGame.addEventListener("easyEnd", function():void {
				showAchievement(8);
				onGamePlayed(null);
			})
			mapGame.addEventListener("hardEnd", function():void {
				showAchievement(9);
				onGamePlayed(null)
			})
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
			checkOver();
		}

		private function initFindGame():void
		{
			findGame=new FindGame(assets);
			findGame.addEventListener("gameOver", onFindGamePlayed)
			findGame.addEventListener("addCard", onFindGameAddCard)
			addChild(findGame);
		}

		private function onFindGameAddCard(e:Event):void
		{
			showCard("picture");
			showAchievement(7);
		}

		private function onFindGamePlayed(e:Event):void
		{
			findGame.removeEventListener("gameOver", onFindGamePlayed)
			findGame.removeEventListener("addCard", onFindGameAddCard)
			findGame.removeChildren();
			removeChild(mapGame);
			findGame=null;
			finded=true;
			checkOver();
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
