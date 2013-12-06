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
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.global.TailBar;
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
		private var cardXArr:Array=[351, 448, 543, 621];
		private var cardY:Number=511;

		private var chatIndex:int;

		private var pin:Image;

		private var food:Image;
		private var foodHolder:Sprite;

		private var kingHolder:Sprite;

		private var cardHolder:Sprite;
		private var cardSelected:Boolean;
		private var cardEnable:Boolean;

		private var chatking1:String="哇！当皇帝真好，有这么多好吃的！";
		private var chatking2:String="太慢了，我自己来！";

		private var chatlion1:String="别急，试菜的公公还没用银牌试毒呢？";
		private var chatlion2:String="翻翻请求接见的大臣递交的膳牌。 皇亲贵族用红头牌子，大臣用绿头牌子。"; //task
		private var chatlion3:String="试毒要用银牌哟！";

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

			lion.touchable=false;
			lion.addEventListener(TouchEvent.TOUCH, onLionTouch);

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
			food.x=304;
			food.y=470;
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
			kingHungry.loop=true;
			kingHungry.play();
			kingHungry.x=569;
			kingHungry.y=28;

			kingHolder.touchable=false;
			kingHolder.addEventListener(TouchEvent.TOUCH, onKingTouch);

			var table:Image=getImage("table23");
			table.y=483;
			addChild(table);
		}

		private function onKingTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(kingHolder, TouchPhase.ENDED);
			if (!tc)
				return;
			if (kingP)
				kingP.playHide();
			if (kingChat)
				kingP=Prompt.showTXT(kingChat.x, kingChat.y, kingChat.content, 20, null, this);
		}

		private function onLionTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(lion, TouchPhase.ENDED);
			if (!tc)
				return;
			if (lionP)
				lionP.playHide();
			if (lionChat)
				lionP=Prompt.showTXT(lionChat.x, lionChat.y, lionChat.content, 20, null, this, 1, false, 3, true);
		}

		private function startChat():void
		{
			kingHolder.touchable=lion.touchable=false;
			if (chatIndex >= 5)
				return;
			var chat:String=chatArr[chatIndex];
			var dx:Number;
			var dy:Number;
			var isK:Boolean;
			if (chat.indexOf("king") >= 0)
			{
				isK=true;
				dx=800;
				dy=320;
			}
			else
			{
				isK=false;
				lion.stop();
				lion.play();
				dx=150;
				dy=445;
			}
			var isT:Boolean;
			if (chat == "chatlion3")
			{
				kingHolder.touchable=lion.touchable=true;
				isT=true;
				dx=180;
				dy=590;
				if (SOService.instance.checkHintCount(silverCardClickHint))
					addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			else if (chat == "chatlion2")
			{
				lion.touchable=true;
				dx=180;
				dy=590;
				isT=true;
			}
			var obj:Object={x: dx, y: dy, content: this[chat], isTask: isT};
			if (isK)
				kingChat=obj;
			else
				lionChat=obj;
			Prompt.showTXT(dx, dy, this[chat], 20, nextChat, this, 1, false, 3, isT);
		}

		private var kingChat:Object;
		private var lionChat:Object;
		private var kingP:Prompt;
		private var lionP:Prompt;

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
				LionMC.instance.setLastData(lionChat.content, 0, 0, 0, .6, true);
				TailBar.show();
				TweenLite.to(lion, .5, {x: -350, onComplete: function():void {
				}});
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
			chair.x=211;
			chair.y=210;
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
			kingFull.loop=true;
			kingFull.x=342;
			kingFull.y=28;

			kingHolder.touchable=lion.touchable=false;

			if (win)
			{
				showCard("7", function():void {
					showAchievement(18, function():void {
						Prompt.showTXT(180, 590, "皇帝要把没吃完的菜赏下去，通常是赏给王公贵族，你来试试？", 20, addChooses, null, 1, false, 3, true);
					});
				});
			}
			else
			{
				Prompt.showTXT(180, 590, "皇帝要把没吃完的菜赏下去，通常是赏给王公贵族，你来试试？", 20, addChooses, null, 1, false, 3, true);
			}
		}

		private function addChooses():void
		{
			lion.touchable=true;
			lionChat={x: 180, y: 590, content: "皇帝要把没吃完的菜赏下去，通常是赏给王公贵族，你来试试？", isTask: true};

			kingFull.addEventListener(Event.COMPLETE, function(e:Event):void {
				kingFull.pause();
				Starling.juggler.remove(kingFull);
			});
			var gap:Number=85 + 28;
			for (var i:int=0; i < 4; i++)
			{
				var btn:ElasticButton=new ElasticButton(getImage("choose" + (i + 1).toString()));
//				btn.shadow=getImage("choose" + (i + 1).toString() + "-down");
				btn.index=i;
				btn.x=483 + gap * i + 85 / 2;
				btn.y=294 + 219 / 2;
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

				kingHolder.touchable=lion.touchable=false;

				if (b.index == 3)
					Prompt.showTXT(150, 445, "果然是平民少年，更体会百姓的疾苦。", 20,
								   function():void {
									   showAchievement(20, moveTable);
								   }, this);
//					LionMC.instance.say("果然是平民少年，更体会百姓的疾苦。", 0, 0, 0, 
//						function():void {
//						showAchievement(20, moveTable);
//					})
				else
					Prompt.showTXT(150, 445, "嗯，做的有模有样，表现不错。", 20, moveTable, this);
//				LionMC.instance.say("按照规矩办事，表现不错。", 0, 0, 0, moveTable);
//				moveTable();
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
