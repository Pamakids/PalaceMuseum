package views.module2
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import models.SOService;

	import sound.SoundAssets;

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

			addShelfs();

			addking();

			can1=getImage("can1");
			can1.y=291;
			addChild(can1);
			can1.touchable=false;

			can2=getImage("can2");
			can2.y=can1.y + can1.height;
			addChild(can2);
			can2.addEventListener(TouchEvent.TOUCH, onCanTouch);

			var curtainL:Image=getImage("curtain-l");
			addChild(curtainL);
			curtainL.touchable=false;
			var curtainR:Image=getImage("curtain-r");
			curtainR.x=1024 - 245;
			addChild(curtainR);
			curtainR.touchable=false;


			map=getImage("map31");
			map.x=484;
			map.y=596;
			addChild(map);
			map.addEventListener(TouchEvent.TOUCH, onMapTouch);

			addCraw(new Point(125, 686));
			addCraw(new Point(541, 581));

			addSmallBooks();

			kingChat1();
		}

		private function addSmallBooks():void
		{
			for (var i:int=0; i < 2; i++)
			{
				var pt:Point=this["dpt" + i];
				var shadow:Image=getImage("book-shadow" + (i + 1).toString());
				addChild(shadow);
				shadow.touchable=false;
				shadow.x=pt.x;
				shadow.y=pt.y;
				shadowArr.push(shadow);
			}
		}

		private var shadowArr:Array=[];

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
			headHolder.addChildAt(kingHead, 0);
		}

		private var expArr:Array=["kingHappy", "kingLook", "KingNaughty"];

		private function onCanTouch(e:TouchEvent):void
		{
			if (!ready)
				return;
			var tc:Touch=e.getTouch(can2, TouchPhase.ENDED);
			if (tc)
				if (canArea.containsPoint(tc.getLocation(this)))
					initFindGame();
		}

		private function kingChat1():void
		{
			Prompt.showTXT(headHolder.x + 150, headHolder.y + 70, chat3, 20, lionChat1, this);
		}

		private function lionChat1():void
		{
			LionMC.instance.say(chat2, 0, 50, 520, lionChat2, 20, .6);
		}

//		private function kingChat2():void
//		{
//			Prompt.showTXT(headHolder.x + 150, headHolder.y + 70, chat3, 20, lionChat2, this);
//		}

		private function lionChat2():void
		{
			TweenLite.delayedCall(1, function():void {
				LionMC.instance.say(chat4, 0, 50, 520, getReady, 20, .6, true);
			});
		}

		private var chat1:String="长大后，皇帝还要上学吗？";
		private var chat2:String="无论多么繁忙，皇帝们从来不放松学习。";
		private var chat3:String="这么多书，都…都要看吗？";
		private var chat4:String="猜猜哪两本是皇帝每天必读的书，都是与前代皇帝治国之道相关的书。";

		private function getReady():void
		{
			birdIndex=2;
			ready=true;
			if (SOService.instance.checkHintCount(shelfHintCount))
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
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

		private var nameArr:Array=[
			"《实录》", //大图
			"《学蒙语》\n与蒙古人的关系很重要，皇帝要会蒙语",
			"《大学》\n孔子及其门徒留下来的儒学入门读物",
			"《资治通鉴》\n北宋司马光主编的编年体史书",
			"《论语》\n记载孔子及其学生言行的一部书",
			"《春秋》\n孔子修订的鲁国编年史",
			"《三国志传》\n西晋陈寿所著关于三国时代历史的断代史",
			"《史记》\n司马迁撰写的中国第一部纪传体通史",
			"《全唐诗》\n清初编辑的唐代诗歌总集",
			"《古文渊鉴》\n康熙皇帝主持编辑的历代散文总集",
			"《孟子》\n记载孟子及其学生言行的儒家经典",
			"《学藏语》\n与藏族人的关系密切，皇帝要懂藏语",
			"《二十四孝》\n元代编辑的行孝故事合集",
			"《礼记》\n记述秦汉以前典章制度、礼仪的一部书",
			"《御注老子》\n唐宋明清的四位皇帝对《老子》的亲手注释",
			"《历代题诗》\n各个朝代题诗的合集",
			"《周易》\n相传周文王所著，以六十四卦表述宇宙间普遍的变化",
			"《圣训》", //大图
			"《明史》\n讲述明朝历史的纪传体断代史书",
			"《中庸》\n孔子的孙子子思创作的儒学名著",
			"《诗经》\n中国最早的诗歌总集",
			"《尚书》\n中国最早的散文总集"
			];

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
		private var _shelfOpen:Boolean;

		public function get shelfOpen():Boolean
		{
			return _shelfOpen;
		}

		public function set shelfOpen(value:Boolean):void
		{
			if (_shelfOpen == value)
				return;
			_shelfOpen=value;
			SoundAssets.stopSFX(value ? "shelfin" : "shelfout");
			SoundAssets.playSFX(value ? "shelfout" : "shelfin");

			if (!value && p)
				p.playHide();
		}

		private var gamePlayed:Boolean;

		private var bigBook:Sprite;
		private var finded:Boolean;
		private var findGame:FindGame;

		private var can1:Image;
		private var can2:Image;

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
			var gpt:Point=pr.localToGlobal(pt);
			var align:int=1;
			if (checkAlign(book))
				align=3;
			if (book.bookname.indexOf("圣训") >= 0)
			{
				playKing(0);
				showBigBook(0, gpt);
			}
			else if (book.bookname.indexOf("实录") >= 0)
			{
				playKing(0);
				showBigBook(1, gpt);
			}
			else
			{
				playKing(int(Math.random() * expArr.length))
				if (p)
					p.playHide();
				var dx:Number=gpt.x / DPIUtil.getDPIScale();
				var dy:Number=gpt.y / DPIUtil.getDPIScale();
				dy=dy < 150 ? 150 : dy;
				p=Prompt.showTXT(dx, dy, book.bookname, 20, null, this, align, true)
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

		private function showBigBook(index:int, pt:Point):void
		{
			crtIndex=index;
			crtPt=pt;
			bigBook=new Sprite();
			var img:Image=getImage("book-big" + (index + 1).toString());
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
			bigBook.scaleX=.1;
			bigBook.scaleY=.1;
			PopUpManager.addPopUp(bigBook, true, false)
			TweenLite.to(bigBook, 1, {scaleX: 1, scaleY: 1});


		}

		private var headHolder:Sprite;

		private function onCloseBook(e:Event):void
		{
			showSmallBook(crtIndex, crtPt);
			PopUpManager.removePopUp(bigBook, true);
			bigBook=null;
		}

		private function showSmallBook(index:int, spt:Point):void
		{
			var dpt:Point;
			if (index == 0)
			{
				if (!book1Found)
					dpt=this["dpt" + index];
				book1Found=true;
			}
			else if (index == 1)
			{
				if (!book2Found)
					dpt=this["dpt" + index];
				book2Found=true;
			}

			if (dpt)
			{
				var book:Image=getImage("book-small" + (index + 1).toString());
				addChild(book);
				book.x=spt.x;
				book.y=spt.y;
				book.touchable=false;
				TweenLite.to(book, .5, {x: dpt.x, y: dpt.y, onComplete: checkOver});
				TweenLite.to(shadowArr[index], .5, {alpha: 0});
			}
		}

		private var dpt0:Point=new Point(317, 600);
		private var dpt1:Point=new Point(377, 600);

		private function checkOver():void
		{
			if (book1Found && book2Found)
			{
				showAchievement(6);
				sceneOver();
			}
		}

		private var book1Found:Boolean;
		private var book2Found:Boolean;
		private var crtIndex:int;
		private var crtPt:Point;

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
			inGame=false;
		}

		private function initFindGame():void
		{
			findGame=new FindGame(assetManager);
			findGame.addEventListener(PalaceGame.GAME_OVER, onFindGamePlayed)
			addChild(findGame);
			inGame=true;
			SoundAssets.playSFX("scrollout");
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

		override protected function nextScene(e:Event=null):void
		{
			if (kingHead)
			{
				kingHead.stop();
				Starling.juggler.remove(kingHead);
				kingHead.removeFromParent(true);
				kingHead=null;
			}

			touchable=false;

			var tempHead:Image=getImage("kingHappy0001");
			tempHead.scaleX=tempHead.scaleY=.8;
			headHolder.addChild(tempHead);

//			assetManager.removeTextureAtlas("kingExp");
//			assetManager.removeTextureAtlas("m3s1");

			assetManager.removeTextureAtlas("bug");
			assetManager.removeTextureAtlas("mapPiece");
			assetManager.removeTexture("map");
			assetManager.removeTexture("mapEdge");

			TweenLite.delayedCall(.1, super.nextScene);

//			super.nextScene(e);
		}
	}
}
