package views.global.books.components
{
	import flash.filesystem.File;
	import flash.utils.getTimer;

	import controllers.UserBehaviorAnalysis;

	import feathers.core.PopUpManager;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;
	import views.components.base.PalaceModule;
	import views.components.base.PalaceScene;
	import views.global.TopBar;
	import views.module2.scene21.JigsawGame;
	import views.module3.scene32.MenuGame;
	import views.module3.scene33.DishGame;
	import views.module5.scene52.OperaGame;

	public class GameScene extends PalaceScene
	{
		private var gamePathArr:Array=["22", "23", "31", "42"];
		private var gameArr:Array=[MenuGame, DishGame, JigsawGame, OperaGame];

		private var game:PalaceGame;
		private var crtGameIndex:int;

		private var am:AssetManager;

		public function GameScene(gameIndex:int)
		{
			SoundAssets.addModuleSnd(sceneName);
			crtGameIndex=gameIndex;
			initLoadImage();

			var _assets:AssetManager=new AssetManager();
			var _name:String=gamePathArr[gameIndex];
			var file:File=File.applicationDirectory.resolvePath("assets/" + "games/game" + _name);
//			var f:File=File.applicationDirectory.resolvePath("assets/common");
			_assets.enqueue(file);
			_assets.loadQueue(function(ratio:Number):void
			{
				trace(ratio)
				if (ratio == 1.0)
				{
					am=_assets;
					initGame(crtGameIndex);
					_loadImage.removeFromParent(true);
					_loadImage=null;
				}
			});
		}

		private function initGame(index:int):void
		{
			var cls:Class=gameArr[index];
			game=new cls(am);
			game.fromCenter=true;
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}

		private static var _loadImage:Image;

		private static function initLoadImage():void
		{
			_loadImage=new Image(Texture.fromBitmap(new PalaceModule.loading()));
			_loadImage.pivotX=_loadImage.width >> 1;
			_loadImage.pivotY=_loadImage.height >> 1;
			_loadImage.x=1024 - 100;
			_loadImage.y=768 - 100;
			_loadImage.scaleX=_loadImage.scaleY=.5;
			PopUpManager.addPopUp(_loadImage, true, false);

			_loadImage.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				if (_loadImage)
					_loadImage.rotation+=0.2;
			});
		}

		private function onGameRestart(e:Event):void
		{
			onGamePlayed(null);
			initGame(crtGameIndex);
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
		}

		override protected function init():void
		{
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(sceneName);
		}

		override public function dispose():void
		{
			if (_loadImage)
				_loadImage.dispose();
			if (am)
				am.dispose();
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, sceneName);
				initTime=-1;
			}
			removeChildren(0, -1, true);
		}

		public var playedCallBack:Function;

		private function onGamePlayed(e:Event):void
		{
			game.removeChildren();
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			if (e)
			{
				if (playedCallBack)
					playedCallBack();
				game.dispose();
				this.removeFromParent(true);
			}
			game=null;
		}
	}
}
