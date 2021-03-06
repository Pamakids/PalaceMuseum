package views.module3
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import sound.SoundAssets;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module3.scene32.MenuGame;

	/**
	 * 早膳模块
	 * 送菜场景(菜名连线)
	 * @author Administrator
	 */
	public class Scene32 extends PalaceScene
	{
		private var areaArr:Vector.<Rectangle>=new Vector.<Rectangle>();

		private var game:MenuGame;

		public function Scene32(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=8;

			addBG("bg-22");

			areaArr.push(new Rectangle(400, 400, 200, 300));
			areaArr.push(new Rectangle(148, 326, 205, 288));
			areaArr.push(new Rectangle(718, 272, 185, 300));

			addEventListener(TouchEvent.TOUCH, onTouch);

			addCraw(new Point(480, 650));

			LionMC.instance.say("宫里的饭菜起名字时常常图个吉利，看你能否给这些吉祥菜名对号入座。", 0, 0, 0, function():void {
				birdIndex=7;
			}, 20, true);
		}

		private function onTouch(e:TouchEvent):void
		{
			if (inGame)
				return;
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			if (!pt)
				return;
			for (var i:int=0; i < areaArr.length; i++)
			{
				var rect:Rectangle=areaArr[i];
				if (rect.containsPoint(pt))
				{
					if (i == 0)
						playMenuGame();
					else
						Prompt.showTXT(rect.x + rect.width / 4, rect.y + 150, this["hint" + (3 - i).toString()], 20, null, null, 3);
					break;
				}
			}
		}

		private var hint1:String="皇帝在哪里传膳，桌子就要搬到哪里去！";
		private var hint2:String="赶紧端！";
		private var inGame:Boolean;

		private function playMenuGame():void
		{
//			removeEventListener(TouchEvent.TOUCH, onTouch);
			SoundAssets.playSFX("popup");
			inGame=true;
			game=new MenuGame(assetManager);
			game.x=280;
			game.y=514;
			game.scaleX=game.scaleY=.01;
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart)

			TweenLite.to(game, .5, {x: 0, y: 0, scaleX: 1, scaleY: 1, ease: Bounce.easeIn});
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart)
			game.removeChildren(0,-1,true);
			game.removeFromParent(true);
			game=null;

			game=new MenuGame(assetManager);
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed)
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart)
		}

		private function onGamePlayed(e:Event):void
		{
			addMask(0);
			inGame=false;
			if (game.isWin)
			{
				if (game.gamelevel == 0)
					showAchievement(16, sceneOver);
				else
					showCard("6", function():void {
						showAchievement(17, sceneOver)});
			}
			else
				sceneOver();
			game.removeFromParent(true);
			game=null;
		}

//		override protected function nextScene(e:Event=null):void
//		{
//			super.nextScene(e);
//			var scale:Number=1.2;
//			TweenLite.to(this, 3, {scaleX: scale, scaleY: scale, x: -1024 * (scale - 1)});
//		}
	}
}


