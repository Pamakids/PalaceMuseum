package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.geom.Point;

	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.global.TailBar;
	import views.global.TopBar;
	import views.module1.scene13.Clock;
	import views.module1.scene13.TwisterGame;

	/**
	 * 早起模块
	 * 探索场景: 时钟/牌匾
	 * @author Administrator
	 */
	public class Scene13 extends PalaceScene
	{
		private var gameHolder:Sprite;

		private var game:TwisterGame;
		private var cardShow:Boolean;
		private var _gamePlayed:Boolean;

		public function get gamePlayed():Boolean
		{
			return _gamePlayed;
		}

		public function set gamePlayed(value:Boolean):void
		{
			_gamePlayed=value;
		}

		private var clock:Clock;

		public function Scene13(am:AssetManager)
		{
			super(am);
			crtKnowledgeIndex=4;
		}

		override protected function init():void
		{
			addBG("bg13");

			for (var i:int=0; i < 6; i++)
			{
				var pendant:Image=getImage("pendant" + (i + 1).toString());
				pendant.addEventListener(TouchEvent.TOUCH, onPendantTouch);
				addChild(pendant);
				pendant.x=pendantPosArr[i].x;
				pendant.y=pendantPosArr[i].y;
				pendant.pivotX=offsetXArr[i];
				var delay:Number=2 + Math.random() * 2;
				var angle:Number=2 * Math.random() * Math.PI / 10 - Math.PI / 10
				TweenMax.to(pendant, delay, {shake: {rotation: angle, numShakes: 3}});
			}
			addPlaque();
			addClock();
			addCraw(new Point(661, 40));
			addCraw(new Point(898, 360));

			LionMC.instance.say("为明天早起上个闹钟吧！\n花些时间熟悉一下\n皇帝的寝室。", 0, 0, 0, function():void {
				birdIndex=1;
			}, 20, .6, true);
		}

		private var pendantPosArr:Array=[new Point(299, 226), new Point(390, 192),
										 new Point(484, 163), new Point(574, 164), new Point(635, 176), new Point(765, 227)];
		private var offsetXArr:Array=[12, 9, 10, 8, 11, 4];

		private function onPendantTouch(e:TouchEvent):void
		{
			var pendant:Image=e.currentTarget as Image;
			if (!pendant)
				return;
			var tc:Touch=e.getTouch(pendant, TouchPhase.ENDED);
			if (!tc)
				return;
			pendant.touchable=false;
			var delay:Number=2 + Math.random() * 2;
			var angle:Number=2 * Math.random() * Math.PI / 10 - Math.PI / 10
			TweenMax.to(pendant, delay, {shake: {rotation: angle, numShakes: 3}, onComplete: function():void
			{
				pendant.touchable=true;
			}});
		}

		private function addPlaque():void
		{
			var plaque:Sprite=new Sprite();
			plaque.addChild(getImage("plaque"));
			plaque.x=391;
			addChild(plaque);
			plaque.addEventListener(TouchEvent.TOUCH, onPlaqueTouch);
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
			clock=new Clock(assetManager);
			clock.addEventListener(PalaceGame.GAME_OVER, clockMatch);
			clock.scaleX=clock.scaleY=1;
			clock.x=50;
			clock.y=25;
			clock.reset();
			PopUpManager.addPopUp(clock, true, false);
		}

		private function checkAcheive5():void
		{
//			if (_clockMatched && _gamePlayed)
//				showAchievement(5);
		}

		private function clockMatch(e:Event):void
		{
			TweenLite.to(clock, .5,
						 {scaleX: .1, scaleY: .1, x: 512, y: 768 / 2, onComplete:
							 function():void
							 {
								 if (clock.ended)
									 showCard("2",
											  function():void
											  {
												  showAchievement(4, checkAcheive5);
											  }
											  );
								 PopUpManager.removePopUp(clock, true);
								 clock=null;
								 sceneOver();
							 }
						 }
						 );
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
				gameBG.addChild(getImage("bggame13"));
				gameBG.pivotX=gameBG.width >> 1;
				gameBG.pivotY=gameBG.height >> 1;
				gameHolder.addChild(gameBG);

				game=new TwisterGame(assetManager);
				game.addEventListener(PalaceGame.GAME_OVER, closeGame);
				gameHolder.addChild(game);
			}
			PopUpManager.addPopUp(gameHolder, true, false);
		}

		private function closeGame(e:Event):void
		{
			if (game.isOver)
			{
				if (!gamePlayed)
				{
					TweenLite.to(gameHolder, 1, {scaleX: .1, scaleY: .1, onComplete: function():void
					{
						gamePlayed=true;
						PopUpManager.removePopUp(gameHolder);
						game.dispose2();
						game=null;
						gameHolder=null;
						showCard("1", function():void {
							showAchievement(3);
						});
					}});
				}
				else
				{
					TweenLite.to(gameHolder, 1, {scaleX: .1, scaleY: .1, onComplete: function():void
					{
						PopUpManager.removePopUp(gameHolder);
						game.dispose2();
						game=null;
						gameHolder=null;
					}});
				}
			}
			else
			{
				PopUpManager.removePopUp(gameHolder);
				TopBar.show();
				TailBar.instance.visible=true;
			}
		}

		override public function dispose():void
		{
			if (game)
			{
				game.dispose2();
				game=null;
				gameHolder=null;
			}
			super.dispose();
		}
	}
}

