package views.module5
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;

	import events.OperaSwitchEvent;

	import models.FontVo;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.FlipImage;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.global.TailBar;
	import views.module5.scene52.OpearaGame2;
	import views.module5.scene52.OperaGame;

	/**
	 * 娱乐模块
	 * 看戏场景(京剧游戏1,2)
	 * @author Administrator
	 */
	public class Scene52 extends PalaceScene
	{

		private var mc:MovieClip;

		private var game:OperaGame;

		private var gameHolder:Sprite;

		private var curtainL:Image;
		private var curtainR:FlipImage;
		private var offsetX:Number;

		private var game2:OpearaGame2;

		public function Scene52(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=13;
			gameHolder=new Sprite();
			addChild(gameHolder);

			curtainL=getImage("opera-curtainL");
			offsetX=curtainL.width;
			curtainL.x=0;
			addChild(curtainL);
			curtainR=new FlipImage(curtainL.texture, true, false);
			curtainR.location=1;
			curtainR.x=1024 - offsetX;
			addChild(curtainR);

			king=new MovieClip(assetManager.getTextures("kingDrag"), 18);
			addChild(king);
			king.loop=false;
			Starling.juggler.add(king);
			king.stop();
			king.x=714;
			king.y=768;
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete: function():void {
				Prompt.showTXT(king.x + 20, king.y + 135, "哇，好大的戏台子，我去后面瞧瞧热闹。", 20, lionSay, null, 3);
			}});
		}

		private function lionSay():void
		{
			LionMC.instance.say("这个淘气的孩子，随他玩会儿吧。", 5, 0, 0, function():void {
				TweenLite.to(king, .5, {y: 768});
				initGame();
				LionMC.instance.hide();
			});
		}

		public function onOperaSwitch(e:OperaSwitchEvent, forceInit:Boolean=false):void
		{
			TweenLite.killDelayedCallsTo(this);
			TweenLite.killTweensOf(curtainL);
			TweenLite.killTweensOf(curtainR);
			switch (e.action)
			{
				case OperaSwitchEvent.OPEN:
				{
					openCurtains(e.openCallback);
					break;
				}

				case OperaSwitchEvent.CLOSE:
				{
					closeCurtains(e.closeCallback);
					break;
				}

				case OperaSwitchEvent.OPEN_CLOSE:
				{
					openCurtains(function():void {
						if (e.openCallback != null)
							e.openCallback();
						TweenLite.delayedCall(e.delay, function():void {
							closeCurtains(e.closeCallback);
						});
					});
					break;
				}

				case OperaSwitchEvent.CLOSE_OPEN:
				{
					var cb:Function=function():void {
						if (e.closeCallback != null)
							e.closeCallback();
						TweenLite.delayedCall(e.delay, function():void {
							openCurtains(e.openCallback);
						});
					}
					if (forceInit)
						closeCurtains(function():void {
							playEnter(cb);
						});
					else
						closeCurtains(cb);
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function playEnter(callback:Function):void
		{
			var holder:Sprite=new Sprite();
			addChild(holder);
			var arr:Array=this["bodyArr" + game.gamelevel.toString()];
			var delay:Number;
			var sy:Number=-300;
			var dy:Number=550;
			var sx:Number=130;
			var dx:Number=150;
			var index:int=0;
			function initBody():void
			{
				var t:String=arr[index];
				var txt:TextField=getTF(t);
				holder.addChild(txt);
				txt.alpha=0;
				txt.pivotX=txt.width >> 1
				txt.x=sx + dx * index;
				txt.y=dy + 25;
				var body:Image=getImage(t);
				body.pivotX=body.width >> 1;
				body.pivotY=body.height;
				holder.addChild(body);
				body.x=sx + dx * index;
				body.y=sy;
				delay=Math.random() * 1.5;
				TweenLite.delayedCall(delay, function():void {
					TweenLite.to(body, .5, {y: dy, ease: Bounce.easeOut, onComplete: function():void {
						TweenLite.to(txt, .5, {alpha: 1, onComplete: function():void {
							TweenLite.delayedCall(2, function():void {
								TweenLite.to(body, .5, {y: sy, ease: Bounce.easeIn});
								TweenLite.to(txt, .5, {alpha: 0});})
						}});
					}});});
				index++;
			}
			for (var i:int=0; i < arr.length; i++)
			{
				initBody();
			}

			TweenLite.delayedCall(5, function():void {
				if (callback != null)
					callback();
				holder.removeFromParent(true);
			});
		}

		private function getTF(t:String):TextField
		{
			return new TextField(150, 100, t, FontVo.PALACE_FONT, 34, 0xffffff);
		}

		private var bodyArr0:Array=["沙僧", "唐僧", "猪八戒", "孙悟空", "牛魔王", "铁扇公主"];
		private var bodyArr1:Array=["诸葛亮", "张飞", "关羽", "孙尚香", "周瑜", "曹操"];

		private var king:MovieClip;

		private function closeCurtains(closeCallback:Function=null):void
		{
			TweenLite.to(curtainL, 1, {x: 0});
			TweenLite.to(curtainR, 1, {x: 1024 - offsetX, onComplete: closeCallback});
		}

		private function openCurtains(openCallback:Function=null):void
		{
			TweenLite.to(curtainL, 1, {x: -offsetX});
			TweenLite.to(curtainR, 1, {x: 1024, onComplete: openCallback});
		}

		private function initGame():void
		{
			game=new OperaGame(assetManager);
			game.onOperaSwitch=onOperaSwitch;
			gameHolder.addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGameOver);
			game.addEventListener("nextGame", onPlayGame2);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}

		private function onPlayGame2(e:Event):void
		{
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete: function():void {
				king.play();
				Prompt.showTXT(king.x + 20, king.y + 135, "真好玩儿", 20, getGameInfo, null, 3);
			}});
		}

		private function getGameInfo(e:Event=null):void
		{
			Starling.juggler.remove(king);
			king.removeFromParent(true);
			king=null;
			var lvl:int=game.gamelevel;
			if (game.isWin)
			{
				if (lvl == 0)
					showCard("10", function():void {
						initGame2(lvl);
						showAchievement(28);
					});
				else
					showCard("11", function():void {
						initGame2(lvl);
						showAchievement(29);
					});
			}
			else
				initGame2(lvl);

			game.removeFromParent(true);
			game=null;
		}

		private function initGame2(lvl:int):void
		{
			game2=new OpearaGame2(lvl, assetManager);
			gameHolder.addChild(game2);
			game2.onOperaSwitch=onOperaSwitch;
			game2.addEventListener(PalaceGame.GAME_OVER, onGame2Over);
			TailBar.hide();
		}

		private function onGame2Over(e:Event):void
		{
			showAchievement(27);
			sceneOver();
		}

		private function onGameRestart(e:Event):void
		{
			game.removeFromParent(true);
			game=null;

			initGame();
		}

		private function onGameOver(e:Event):void
		{
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete: function():void {
				king.play();
				Prompt.showTXT(king.x + 20, king.y + 135, "真好玩儿", 20, getGameInfo, null, 3);
			}});
//			var lvl:int=game.gamelevel;
//			initGame2(lvl);
//
//			game.removeFromParent(true);
//			game=null;
		}
	}
}
