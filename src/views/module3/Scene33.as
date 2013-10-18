package views.module3
{
	import com.greensock.TweenLite;

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

	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module3.scene33.DishGame;

	/**
	 * 早膳模块
	 * 用膳场景(试毒游戏)
	 * @author Administrator
	 */
	public class Scene33 extends PalaceScene
	{
		private var game:DishGame;

		private var chatArr:Array=["chatking1", "chatlion1", "chatking2", "chatking3", "chatlion2"];
		private var cardXArr:Array=[438, 488, 537, 584];
		private var cardY:Number=510;

		private var chatIndex:int;

		private var pin:Image;

		private var food:Image;
		private var foodHolder:Sprite;

		private var kingHolder:Sprite;

		private var cardHolder:Sprite;
		private var cardSelected:Boolean;
		private var cardEnable:Boolean;

		private var chatking1:String="什么时候可以吃饭？";
		private var chatking2:String="太慢了，我自己来！";
		private var chatking3:String="快点找到银牌！";

		private var chatlion1:String="别着急，小太监还没有用银牌试毒，不能吃。";
		private var chatlion2:String="这些是膳牌，是大臣请求接见是递交的，翻翻看吧！";

//		private var chatlion3:String="今天暂时不单独接见，露出破绽就坏了！先去上朝吧！";

		public function Scene33(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=9;

			addBG();
			addFood();
			addCards();

			lion=getImage("lion23");
			lion.x=5;
			lion.y=316;
			addChild(lion);

			chatIndex=0;
			TweenLite.delayedCall(.5, startChat);
		}

		private function addCards():void
		{
			cardHolder=new Sprite();
			addChild(cardHolder);
			cardHolder.x=-1024

			for (var i:int=0; i < 4; i++)
			{
				var card:Image=getImage("card" + (i + 1).toString());
				card.x=cardXArr[i];
				card.y=cardY;
				cardHolder.addChild(card);
				card.addEventListener(TouchEvent.TOUCH, onCardTouch);
			}
		}

		private function onCardTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (!tc || cardSelected || !cardEnable)
				return;

			var card:Image=e.currentTarget as Image;
			if (card)
			{
				var index:int=cardXArr.indexOf(card.x) + 1;
				cardSelected=true;
				var cardB:Image=getImage("card" + index.toString() + "b");
				cardB.x=card.x;
				cardB.y=card.y;
				cardB.scaleX=cardB.scaleY=.5;
				addChild(cardB);
				TweenLite.to(cardB, .5, {x: 685, y: 53, scaleX: 1, scaleY: 1, onComplete: function():void {
					cardB.addEventListener(TouchEvent.TOUCH, onCardBTouch);
				}});
			}
		}

		private function onCardBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (!tc)
				return;
			var card:Image=e.currentTarget as Image;
			card.removeEventListener(TouchEvent.TOUCH, onCardBTouch);
			TweenLite.to(card, .5, {alpha: 0,
					onComplete: function():void {
						cardSelected=false;
						showAchievement(19);
						sceneOver();
					}});
		}

		private function addFood():void
		{
			foodHolder=new Sprite();
			addChild(foodHolder);
			food=getImage("food");
			food.x=231;
			food.y=473;
			foodHolder.addChild(food);

			pin=getImage("pin23");
			pin.x=247;
			pin.y=513;
			foodHolder.addChild(pin);
		}

		private function addBG():void
		{
			addChild(getImage("bg23"))

			kingHolder=new Sprite();
			addChild(kingHolder);

			var kingHungry:MovieClip=new MovieClip(assets.getTextures("kingHungry"), 18);
			kingHolder.addChild(kingHungry);
			Starling.juggler.add(kingHungry);
			kingHungry.loop=-1;
			kingHungry.play();
			kingHungry.x=569;
			kingHungry.y=28;

//			var kingStand:Image=getImage("king-stand");
//			kingHolder.addChild(kingStand);
//			kingStand.x=254;

			var table:Image=getImage("table23");
			table.y=768 - 287;
			addChild(table);
		}

		private function startChat():void
		{
			if (chatIndex >= 5)
				return;
			var chat:String=chatArr[chatIndex];
			var dx:Number;
			var dy:Number;
			if (chat.indexOf("king") >= 0)
			{
				dx=800;
				dy=320;
			}
			else
			{
				dx=200;
				dy=450;
			}
			Prompt.showTXT(dx, dy, this[chat], 20, nextChat, this);
			if (chat == "chatking3")
			{
				if (SOService.instance.checkHintCount(silverCardClickHint))
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private var silverCardClickHint:String="silverCardClickHint";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;

		private function onEnterFrame(e:Event):void
		{
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (count < 30 * 8)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintFinger=getImage("pushbuttonhint");
					hintFinger.x=262;
					hintFinger.y=408;
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.y == 358)
						isHintReverse=true;
					else if (hintFinger.y == 408)
						isHintReverse=false;
					hintFinger.y+=isHintReverse ? 5 : -5;
				}
			}
		}

		private var isHintReverse:Boolean;

		private var lion:Image;

		private function nextChat():void
		{
			chatIndex++;
			if (chatIndex == 4)
			{
				pin.addEventListener(TouchEvent.TOUCH, onPinTouch);
			}
			else if (chatIndex == 5)
			{
				cardEnable=true;
				TweenLite.to(lion, .5, {x: -350});
			}
			else
				startChat();
		}

		private function onPinTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (!tc)
				return;
			pin.removeEventListener(TouchEvent.TOUCH, onPinTouch);
			isMoved=true;
			initDishGame();
		}

		private function initDishGame():void
		{
			game=new DishGame(assets);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			addChild(game);
		}

		private function onGamePlayed(e:Event):void
		{
			if (game.isWin())
			{
				showCard("7", function():void {
					showAchievement(18);
				});
			}
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			game.removeChildren();
			removeChild(game);
			game=null;

			kingHolder.removeChildren();
			var chair:Image=getImage("chair");
			chair.x=(1024 - chair.width) / 2;
			chair.y=(768 - chair.height) / 2;

			var kingSit:Image=getImage("king23-sit");
			kingSit.x=(1024 - kingSit.width) / 2;
			kingSit.y=(768 - kingSit.height) / 2;

			kingHolder.addChild(chair);
			kingHolder.addChild(kingSit);

			TweenLite.to(cardHolder, 1, {x: 0});
			TweenLite.to(foodHolder, 1, {x: 1024, onComplete: startChat});
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			game.removeChildren();
			removeChild(game);
			game=null;

			game=new DishGame(assets);
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			game.startGame();
		}
	}
}
