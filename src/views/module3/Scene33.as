package views.module3
{
	import com.greensock.TweenLite;

	import models.SOService;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
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

		private var chatArr:Array=["chatking1", "chatlion1", "chatking2", "chatlion3", "chatlion2"];
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

		private var chatlion1:String="别着急，小太监还没有用银牌试毒，不能吃。";
		private var chatlion2:String="这些是膳牌，是大臣请求接见是递交的，翻翻看吧！";
		private var chatlion3:String="快点找到银牌！";

		public function Scene33(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=9;

			addBG("bg23");
			addKing();
			addFood();
			addCards();

			lion=new MovieClip(assetManager.getTextures("liontalk"), 12);
			lion.x=15;
			lion.y=456;
			lion.setFrameDuration(13, 3);
			lion.loop=true;
			lion.stop();
			Starling.juggler.add(lion);
			addChild(lion);

			chatIndex=0;
			TweenLite.delayedCall(.5, startChat);
		}

		override public function dispose():void
		{
			if (lion)
			{
				lion.stop();
				Starling.juggler.remove(lion);
				lion.removeFromParent(true);
				lion=null;
			}
			super.dispose();
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

		private function addKing():void
		{
			kingHolder=new Sprite();
			addChild(kingHolder);

			kingHungry=new MovieClip(assetManager.getTextures("kingHungry"), 12);
			kingHolder.addChild(kingHungry);
			Starling.juggler.add(kingHungry);
			kingHungry.loop=-1;
			kingHungry.play();
			kingHungry.x=569;
			kingHungry.y=28;

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
				lion.stop();
				lion.play();
				dx=150;
				dy=445;
			}
			var isT:Boolean;
			if (chat == "chatlion3")
			{
				isT=true;
				dx=180;
				dy=590;
				if (SOService.instance.checkHintCount(silverCardClickHint))
					addEventListener(Event.ENTER_FRAME, onEnterFrame);

			}
			Prompt.showTXT(dx, dy, this[chat], 20, nextChat, this, 1, false, 3, isT);
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
			if (count < 30 * 5)
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
					var index:int=getChildIndex(pin) + 1;
					addChildAt(hintShow, index);
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

		private var lion:MovieClip;
		private var choosed:Boolean;

		private var kingHungry:MovieClip;

		private var kingFull:MovieClip;

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
			game=new DishGame(assetManager);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			addChild(game);
		}

		private function onGamePlayed(e:Event):void
		{
			var win:Boolean=game.isWin;

			game.removeFromParent(true);
			game=null;

			if (kingHungry)
			{
				kingHungry.stop();
				Starling.juggler.remove(kingHungry);
			}
			kingHolder.removeChildren();
			var chair:Image=getImage("chair");
			chair.x=(1024 - chair.width) / 2;
			chair.y=(768 - chair.height) / 2;
			kingHolder.addChild(chair);

//			var kingSit:Image=getImage("king23-sit");
//			kingSit.x=(1024 - kingSit.width) / 2;
//			kingSit.y=(768 - kingSit.height) / 2;
//			kingHolder.addChild(kingSit);

			var kingSit:Image=getImage("kingBody");
			kingSit.x=316;
			kingSit.y=338;
			trace(kingSit.x, kingSit.y);
			kingHolder.addChild(kingSit);

			kingFull=new MovieClip(assetManager.getTextures("kingFull"), 18);
			kingHolder.addChild(kingFull);
			Starling.juggler.add(kingFull);
			kingFull.play();
			kingFull.loop=-1;
			kingFull.x=342;
			kingFull.y=28;

			if (win)
			{
				showCard("7", function():void {
					showAchievement(18, function():void {
						Prompt.showTXT(200, 450, "把没吃完的菜赏赐下去吧", 20, addChooses);
					});
				});
			}
			else
				Prompt.showTXT(200, 450, "把没吃完的菜赏赐下去吧", 20, addChooses);
		}

		private function addChooses():void
		{
			kingFull.addEventListener(Event.COMPLETE, function(e:Event):void {
				kingFull.pause();
				Starling.juggler.remove(kingFull);
			});
			var gap:Number=142 + 16;
			for (var i:int=0; i < 4; i++)
			{
				var btn:ElasticButton=new ElasticButton(getImage("choose" + (i + 1).toString()));
				btn.shadow=getImage("choose" + (i + 1).toString() + "-down");
				btn.index=i;
				btn.x=380 + gap * i;
				btn.y=580;
				foodHolder.addChild(btn);
				btn.addEventListener(ElasticButton.CLICK, onBtnClick);
			}
		}

		private function onBtnClick(e:Event):void
		{
			if (choosed)
				return;
			var b:ElasticButton=e.currentTarget as ElasticButton;
			if (b)
			{
				choosed=true;
				if (b.index == 3)
					showAchievement(20, moveTable);
				else
					moveTable();
				for (var i:int=0; i < foodHolder.numChildren; i++)
				{
					var obj:DisplayObject=foodHolder.getChildAt(i);
					if (obj is ElasticButton)
					{
						obj.addEventListener(ElasticButton.CLICK, onBtnClick);
						obj.touchable=false;
						TweenLite.to(obj, .3, {alpha: 0});
					}
				}
			}
		}

		private function moveTable():void
		{
			TweenLite.delayedCall(1, function():void {
				TweenLite.to(cardHolder, 1, {x: 0});
				TweenLite.to(foodHolder, 1, {x: 1024, onComplete: startChat});
			});
		}

		private function onGameRestart(e:Event):void
		{
			game.removeFromParent(true);
			game=null;

			game=new DishGame(assetManager);
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
//			game.startGame();
		}
	}
}
