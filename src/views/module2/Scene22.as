package views.module2
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module2.scene22.MenuGame;

	public class Scene22 extends PalaceScene
	{

		private var scale:Number;

		private var areaArr:Vector.<Rectangle>=new Vector.<Rectangle>();

		private var game:MenuGame;

		public function Scene22(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=8;
			scale=DPIUtil.getDPIScale();

			addChild(getImage("bg-22"));

			areaArr.push(new Rectangle(148, 326, 205, 288));
			areaArr.push(new Rectangle(424, 321, 185, 300));
			areaArr.push(new Rectangle(718, 272, 185, 300));

			addEventListener(TouchEvent.TOUCH, onTouch);
//			playMenuGame();

		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
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
						Prompt.show(rect.x + rect.width / 3 * 2, rect.y + 50, "hint-bg", "hint-" + (3 - i).toString(), 1);
					break;
				}
			}
		}

		private function playMenuGame():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			game=new MenuGame(assets);
			game.x=280;
			game.y=514;
			game.scaleX=game.scaleY=.01;
			addChild(game);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)

			TweenLite.to(game, .5, {x: 0, y: 0, scaleX: 1, scaleY: 1, ease: Bounce.easeIn});
		}

		private function onGameRestart(e:Event):void
		{
			game.removeEventListener("gameOver", onGamePlayed)
			game.removeEventListener("gameRestart", onGameRestart)
			game.removeChildren();
			removeChild(game);
			game=null;

			game=new MenuGame(assets);
			addChild(game);
			game.addEventListener("gameOver", onGamePlayed)
			game.addEventListener("gameRestart", onGameRestart)

		}

		private function onGamePlayed(e:Event):void
		{
			removeChild(game);
			game=null;
			removeEventListener(TouchEvent.TOUCH, onTouch);
			sceneOver();
		}

		override protected function nextScene(e:Event=null):void
		{
			var scale:Number=1.2;
			TweenLite.to(this, 3, {scaleX: scale, scaleY: scale, x: -1024 * (scale - 1),
					onComplete: super.nextScene});
		}
	}
}
