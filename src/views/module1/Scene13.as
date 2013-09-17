package views.module1
{
	import com.greensock.TweenLite;

	import feathers.core.PopUpManager;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.CollectionCard;
	import views.components.base.PalaceScene;
	import views.module1.scene3.Clock;
	import views.module1.scene3.TwisterGame;

	public class Scene13 extends PalaceScene
	{
		private var bg:Sprite;

		private var gameHolder:Sprite;

		private var game:TwisterGame;
		private var halo:Sprite;
		private var cardShow:Boolean;
		private var _gamePlayed:Boolean;

		public function get gamePlayed():Boolean
		{
			return _gamePlayed;
		}

		public function set gamePlayed(value:Boolean):void
		{
			_gamePlayed=value;
			if (_gamePlayed)
				TweenLite.delayedCall(5, nextScene);
		}

		private function nextScene():void
		{
			trace('nextScene');
			dispatchEvent(new Event("gotoNext", true));
		}

		private var clock:Clock;
		private var _clockMatched:Boolean;

		public function get clockMatched():Boolean
		{
			return _clockMatched;
		}

		public function set clockMatched(value:Boolean):void
		{
			_clockMatched=value;
			if (_clockMatched)
				TweenLite.delayedCall(5, nextScene);
		}


		public function Scene13(am:AssetManager)
		{
			super(am);
			crtKnowledgeIndex=4;
		}

		override protected function init():void
		{
			bg=new Sprite();
			bg.x=512;
			addChild(bg);

			bg.addChild(getImage("background13"));
			bg.pivotX=bg.width >> 1;

			addPlaque();
			addKing();
			addEunuch();
			addClock();
			addHalo();
			addBook();
		}

		private function addHalo():void
		{
			halo=new Sprite();
			halo.addChild(getImage("halo"));
			halo.pivotX=halo.width >> 1;
			halo.pivotY=halo.height >> 1;
			addChild(halo);
			halo.x=512;
			halo.y=768 / 2;
			halo.visible=false;
		}

		private function addPlaque():void
		{
			var plaque:Sprite=new Sprite();
			plaque.addChild(getImage("plaque"));
			plaque.x=391;
			addChild(plaque);
			plaque.addEventListener(TouchEvent.TOUCH, onPlaqueTouch);
		}

		private function addKing():void
		{
			var king:Sprite=new Sprite();
			king.addChild(getImage("king13"));
			king.x=344;
			king.y=145;
			addChild(king);
		}

		private function addEunuch():void
		{
			var eunuch:Sprite=new Sprite();
			eunuch.addChild(getImage("eunuch13"));
			eunuch.x=599;
			eunuch.y=322;
			addChild(eunuch);
		}

		private function addClock():void
		{
			var clock:Sprite=new Sprite();
			clock.addChild(getImage("clock"));
			clock.x=901;
			clock.y=144;
			addChild(clock);
			clock.addEventListener(TouchEvent.TOUCH, onClockTouch);

		}

		private function onClockTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage, TouchPhase.ENDED);
			if (tc)
				initClock();
		}

		private function initClock():void
		{
			if (!clockMatched)
			{
				if (!clock)
				{
					clock=new Clock(assets);
					clock.addEventListener("clockMatch", clockMatch);
				}
			}
			clock.scaleX=clock.scaleY=1;
			clock.x=50;
			clock.y=25;
			clock.reset();
			PopUpManager.addPopUp(clock, true, false);
		}

		private function clockMatch(e:Event):void
		{
			if (!clockMatched)
			{
				clockMatched=true;
				TweenLite.to(clock, .5, {scaleX: .1, scaleY: .1, x: 512, y: 768 / 2, onComplete: function():void
				{
					PopUpManager.removePopUp(clock);
					addCard("card-clock");
				}});
			}
			else
			{
				TweenLite.to(clock, .5, {scaleX: .1, scaleY: .1, x: 512, y: 768 / 2, onComplete: function():void
				{
					PopUpManager.removePopUp(clock);
				}});
			}


		}

		private function addBook():void
		{
			var book:Sprite=new Sprite();
			book.addChild(getImage("book"));
			book.x=10;
			book.y=10;
			addChild(book);
		}

		private function onPlaqueTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
				initGame();
		}

		private function initGame():void
		{
			if (!gameHolder)
			{
				gameHolder=new Sprite();
				gameHolder.x=512;
				gameHolder.y=768 / 2;

				var gameBG:Sprite=new Sprite();
				gameBG.addChild(getImage("gamebg13"));
				gameBG.pivotX=gameBG.width >> 1;
				gameBG.pivotY=gameBG.height >> 1;
				gameHolder.addChild(gameBG);

				game=new TwisterGame(assets);
				game.addEventListener("gameover", gameOver);
				gameHolder.addChild(game);
			}
			else
			{
				gameHolder.scaleX=gameHolder.scaleY=1;
				if (game.isOver)
				{
					game.reset();
				}
			}

			PopUpManager.addPopUp(gameHolder, true, false);
		}

		private function gameOver(e:Event):void
		{
			if (!gamePlayed)
			{
				TweenLite.to(gameHolder, 1, {scaleX: .1, scaleY: .1, onComplete: function():void
				{
					PopUpManager.removePopUp(gameHolder);
					addCard("card-plaque")
				}});
			}
			else
			{
				TweenLite.to(gameHolder, 1, {scaleX: .1, scaleY: .1, onComplete: function():void
				{
					PopUpManager.removePopUp(gameHolder);
				}});
			}
			gamePlayed=true;
		}

		private function addCard(src:String):void
		{
			if (cardShow)
				return;
			cardShow=true;
			setChildIndex(halo, numChildren - 1);
			halo.visible=true;
			halo.scaleX=halo.scaleY=.5;
			halo.rotation=0;
			TweenLite.to(halo, 2.5, {scaleX: 1, scaleY: 1, rotation: Math.PI, onComplete: function():void
			{
				halo.visible=false;
				cardShow=false;
				trace('haloed');
			}});

			var card:CollectionCard=new CollectionCard();
			card.addChild(getImage(src));
			card.pivotX=card.width >> 1;
			card.pivotY=card.height >> 1;
			card.x=512;
			card.y=768 / 2;
			card.show();
			addChild(card);
			trace('added card');
		}
	}
}

