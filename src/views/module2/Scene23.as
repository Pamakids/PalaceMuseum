package views.module2
{
	import com.greensock.TweenLite;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.global.TopBar;
	import views.module2.scene23.DishGame;

	public class Scene23 extends PalaceScene
	{

		private var game:DishGame;

		private var chatArr:Array=["chat-king-1", "chat-lion-1", "chat-king-2", "chat-king-3", "chat-lion-2", "chat-lion-3"];
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

		public function Scene23(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=9;

			addBG();
			addFood();
			addCards();

			var lion:Image=getImage("lion23");
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

			TweenLite.to(card, .5, {alpha: 0, onComplete: startChat});
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
			var kingStand:Image=getImage("king-stand");
			kingHolder.addChild(kingStand);
			kingStand.x=254;

			var table:Image=getImage("table23");
			table.y=768 - 287;
			addChild(table);
		}

		private function startChat():void
		{
			if (chatIndex >= 6)
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
			Prompt.show(dx, dy, "hint-bg", chat, 1, 4, nextChat, this);
		}

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
			}
			else if (chatIndex == 6)
			{
				sceneOver();
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
			initDishGame();
		}

		private function initDishGame():void
		{
			game=new DishGame(assets);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)
			addChild(game);
		}

		private function onGamePlayed(e:Event):void
		{
			TopBar.show();
			game.removeEventListener("gameOver", onGamePlayed)
			game.removeEventListener("gameRestart", onGameRestart)
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
			game.removeEventListener("gameOver", onGamePlayed);
			game.removeEventListener("gameRestart", onGameRestart);
			game.removeChildren();
			removeChild(game);
			game=null;

			game=new DishGame(assets);
			addChild(game);
			game.addEventListener("gameOver", onGamePlayed);
			game.addEventListener("gameRestart", onGameRestart);
			game.startGame();
		}
	}
}
