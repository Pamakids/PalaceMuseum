package views.module2
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

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

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module2.scene21.FindGame;
	import views.module2.scene21.JigsawGame;
	import views.module2.scene21.ShelfBook;

	/**
	 * 早读模块
	 * 探索场景(地图拼图游戏)
	 * @author Administrator
	 */
	public class Scene21 extends PalaceScene
	{
		private var mapGame:JigsawGame;

		private var map:Image;

		public function Scene21(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=5;
			addBG("bg31")
//			addChild(getImage("bg31"));

			addShelfs();

			addking();

			can=getImage("can31");
			can.y=291;
			addChild(can);
//			can.touchable=false;
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

			addCraw(new Point(125, 686));
			addCraw(new Point(501, 581));

			playLion();
		}

		private function addking():void
		{
			var kingHolder:Sprite=new Sprite();
			addChild(kingHolder);
			kingHolder.touchable=false;

			var table:Image=getImage("table31");
			table.x=260;
			table.y=212;
			kingHolder.addChild(table);

			headHolder=new Sprite();
			headHolder.x=418;
			headHolder.y=292;
			kingHolder.addChild(headHolder);
			playKing(0);

			var cloth:Image=getImage("cloth");
			cloth.x=387;
			cloth.y=478;
			kingHolder.addChild(cloth);

			var hat:Image=getImage("hat");
			hat.x=405;
			hat.y=246;
			kingHolder.addChild(hat);
		}

		private var kingHead:MovieClip;

		private function playKing(index:int):void
		{
			if (kingHead)
			{
				kingHead.stop();
				Starling.juggler.remove(kingHead);
				kingHead.removeFromParent(true);
				kingHead=null;
			}

			kingHead=new MovieClip(assetManager.getTextures(expArr[index]), 18);
			kingHead.loop=0;
			kingHead.play();
			Starling.juggler.add(kingHead);
			kingHead.scaleX=kingHead.scaleY=.8;
			headHolder.addChild(kingHead);
		}

		private var expArr:Array=["kingHappy", "kingLook", "KingNaughty", "kingStrange"];

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
			LionMC.instance.say(hint31find, 0, 50, 520, function():void
			{
				ready=true;
				if (SOService.instance.checkHintCount(shelfHintCount))
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}, 20, .6, true);
		}

		private var shelfHintCount:String="shelfHintCount";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;
		private var inGame:Boolean;

		private function onEnterFrame(e:Event):void
		{
			if (inGame)
				return;
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
					var hintArrow:Image=getImage("shelfhintarrow");
					hintFinger=getImage("shelfhintfinger");
					hintArrow.x=50;
					hintArrow.y=137;
					hintFinger.x=65;
					hintFinger.y=202;
					hintShow.addChild(hintArrow);
					hintShow.addChild(hintFinger);
					var index:int=getChildIndex(shelfL) + 1;
					addChildAt(hintShow, index);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.x == 165)
					{
						hintFinger.scaleX=hintFinger.scaleY=1;
					}
					else if (hintFinger.x == 65)
					{
						hintFinger.scaleX=hintFinger.scaleY=.8;
					}
					hintFinger.x+=hintFinger.scaleX == 1 ? -5 : 5;
				}
			}
		}

		private function onMapTouch(e:TouchEvent):void
		{
			if (!ready)
				return;
			var tc:Touch=e.getTouch(map, TouchPhase.ENDED);
			if (tc)
				initGame();
		}
		private var canArea:Rectangle=new Rectangle(57, 550, 121, 218);

		private var dataArrL:Array=[1, 2, 3, 7, 8, 9, 10, 11, 4, 5, 6];
		private var posArrL:Array=[new Point(97, 50), new Point(201, 74), new Point(305, 74), new Point(81, 183), new Point(224, 194),
			new Point(310, 213), new Point(100, 337), new Point(235, 327), new Point(90, 466), new Point(189, 453), new Point(294, 475)];
		private var dataArrR:Array=[7, 3, 8, 1, 2, 5, 9, 10, 4, 6, 11];
		private var posArrR:Array=[new Point(99, 48), new Point(243, 72), new Point(107, 194), new Point(242, 184), new Point(373, 207),
			new Point(72, 336), new Point(155, 355), new Point(248, 338), new Point(94, 468), new Point(220, 476), new Point(356, 440)];

		private var innerX:Number=300;
		private var rx:Number=1024 - 457;

		private var nameArr:Array=["《诗经》", "《学蒙语》", "《大学》", "《资治通鉴》", "《论语》", "《春秋》", "《三国志传》", "《史记》",
			"《全唐诗》", "《古文渊鉴》", "《孟子》", "《学藏语》", "《二十四孝》", "《礼记》", "《御注老子》", "《历代题诗》",
			"《周易》", "《圣训》", "《明史》", "《中庸》", "《佩文韵府》", "《尚书》"];

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
				book.bookname=nameArr[i]
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
				book1.bookname=nameArr[j + 11]
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
			if (!isMoved)
				isMoved=shelfL.x > -200;
		}

		private var probability:Number=0;
		private var ready:Boolean;

//		private var lion:Lion;

		private var shelfL:Sprite;

		private var shelfR:Sprite;
		private var shelfOpen:Boolean;
		private var gamePlayed:Boolean;

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
			if (book.bookname == "《圣训》")
			{
				playKing(0);
				showBigBook();
			}
			else
			{
				playKing(int(Math.random() * expArr.length))
				if (p)
					p.playHide();
				p=Prompt.showTXT(pt.x, pt.y, book.bookname, 24, null, pr, align, true)
			}
		}

		private var p:Prompt;

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

		private function showBigBook():void
		{
			if (!bigBook)
			{
				bigBook=new Sprite();
				var img:Image=getImage("book-big");
				bigBook.addChild(img);
				img.x=270;
				img.y=138;

				bigBook.pivotX=512;
				bigBook.pivotY=384;
				bigBook.x=512;
				bigBook.y=384;
				var close:ElasticButton=new ElasticButton(getImage("button_close"));
				close.shadow=getImage("button_close_down");
				bigBook.addChild(close);
				close.x=800;
				close.y=200;
				close.addEventListener(ElasticButton.CLICK, onCloseBook);
			}
			bigBook.scaleX=.1;
			bigBook.scaleY=.1;
			PopUpManager.addPopUp(bigBook, true, false)
			TweenLite.to(bigBook, 1, {scaleX: 1, scaleY: 1});


		}

//		private var hint31right:String="恭喜你找到圣训！";
		private var hint31find:String="《圣训》是皇帝每天早上必读的书本，快点找到它。";

		private var headHolder:Sprite;

		private function onCloseBook(e:Event):void
		{
			showAchievement(6);
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
			mapGame=new JigsawGame(assetManager);
			mapGame.addEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			mapGame.addEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			addChild(mapGame);
			inGame=true;
		}

		private function onGamePlayed(e:Event):void
		{
			if (mapGame.isWin)
				if (mapGame.gamelevel == 0)
					showAchievement(8);
				else
					showCard("4", function():void {
						showAchievement(9);
					});
			mapGame.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			mapGame.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			mapGame.removeChildren();
			removeChild(mapGame);
			mapGame=null;
			gamePlayed=true;
			checkOver();
			inGame=false;
		}

		private function initFindGame():void
		{
			findGame=new FindGame(assetManager);
			findGame.addEventListener(PalaceGame.GAME_OVER, onFindGamePlayed)
			addChild(findGame);
			inGame=true;
		}

		private function onFindGamePlayed(e:Event):void
		{
			if (findGame.isWin)
			{
				showCard("3", function():void {
					showAchievement(7);
				});
			}
			findGame.removeFromParent(true);
			removeChild(mapGame);
			findGame=null;
			finded=true;
			checkOver();
			inGame=false;
		}

		private function onGameRestart(e:Event):void
		{
			mapGame.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			mapGame.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			mapGame.removeChildren();
			removeChild(mapGame);
			mapGame=null;

			mapGame=new JigsawGame(assetManager);
			addChild(mapGame);
			mapGame.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			mapGame.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}
	}
}
