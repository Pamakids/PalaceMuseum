package modules.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.base.PalaceScene;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Scene13 extends PalaceScene
	{
		private var bg:Sprite;

		private var gameHolder:Sprite;

		private var game:TwisterGame;
		private var playing:Boolean;
		public function Scene13()
		{

		}

		override public function init():void{
			bg=new Sprite();
			bg.x=512;
			addChild(bg);

			bg.addChild(getImage("background13"));
			bg.pivotX=bg.width>>1;

			addPlaque();
			addKing();
			addEunuch();
			addClock();
		}

		private function addPlaque():void
		{
			var plaque:Sprite=new Sprite();
			plaque.addChild(getImage("plaque.png"));
			plaque.x=391;
			addChild(plaque);
			plaque.addEventListener(TouchEvent.TOUCH,onPlaqueTouch);
		}

		private function addKing():void
		{
			var king:Sprite=new Sprite();
			king.addChild(getImage("king13.png"));
			king.x=344;
			king.y=145;
			addChild(king);
		}

		private function addEunuch():void
		{
			var eunuch:Sprite=new Sprite();
			eunuch.addChild(getImage("eunuch13.png"));
			eunuch.x=599;
			eunuch.y=322;
			addChild(eunuch);
		}

		private function addClock():void
		{
			var clock:Sprite=new Sprite();
			clock.addChild(getImage("clock.png"));
			clock.x=901;
			clock.y=144;
			addChild(clock);
		}

		private function onPlaqueTouch(e:TouchEvent):void
		{
			if(playing)
				return;
			var tc:Touch=e.getTouch(stage,TouchPhase.ENDED);
			if(tc)
				initGame();
		}

		private function initGame():void{
			playing=true;

			gameHolder=new Sprite();
			gameHolder.x=512;
			gameHolder.y=768/2;
			addChild(gameHolder);

			var gameBG:Sprite=new Sprite();
			gameBG.addChild(getImage("gamebg13"));
			gameBG.pivotX=gameBG.width>>1;
			gameBG.pivotY=gameBG.height>>1;
			gameHolder.addChild(gameBG);

			game=new TwisterGame();
			game.assets=assets;
			gameHolder.addChild(game);
			game.addEventListener("gameover",gameOver);
		}

		private function gameOver(e:Event):void
		{
			game.removeEventListener("gameover",gameOver);
			TweenLite.to(gameHolder,2,{scaleX:.1,scaleY:.1,onComplete:function():void{
				gameHolder.removeChildren();
				game.dispose();
				gameHolder.dispose();
				playing=false;
			}});
		}
	}
}

