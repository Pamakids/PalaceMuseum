package views.global.userCenter.userInfo
{
	import flash.filesystem.File;
	import flash.system.System;

	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module2.scene22.MenuGame;
	import views.module2.scene23.DishGame;
	import views.module3.scene31.JigsawGame;
	import views.module4.scene42.OperaGame;

	public class GameScene extends PalaceScene
	{
		[Embed(source="/assets/common/loading.png")]
		private static const Loading:Class

		private var gamePathArr:Array=["22", "23", "31", "42"];
		private var gameArr:Array=[MenuGame, DishGame, JigsawGame, OperaGame];

		private var game:PalaceGame;
		private var crtGameIndex:int;

		public function GameScene(gameIndex:int)
		{
			crtGameIndex=gameIndex;

			initLoadImage();

			var _assets:AssetManager=new AssetManager();
			var _name:String=gamePathArr[gameIndex];
			var file:File=File.applicationDirectory.resolvePath("assets/" + "module" + _name.charAt(0) + "/scene" + _name);
			var f:File=File.applicationDirectory.resolvePath("assets/common");
			_assets.enqueue(file, f);
			_assets.loadQueue(function(ratio:Number):void
			{
				trace(ratio)
				if (ratio == 1.0)
				{
					this.assets=_assets;
					initGame(crtGameIndex);
					_loadImage.removeFromParent(true);
					_loadImage=null;
				}
			});
		}

		private function initGame(index:int):void
		{
			var cls:Class=gameArr[index];
			game=new cls(this.assets);
			game.fromCenter=true;
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.addEventListener(PalaceGame.GAME_RESTART, onGameRestart);
		}

		private static var _loadImage:Image;

		private static function initLoadImage():void
		{
			_loadImage=new Image(Texture.fromBitmap(new Loading()));
			_loadImage.pivotX=_loadImage.width >> 1;
			_loadImage.pivotY=_loadImage.height >> 1;
			_loadImage.x=1024 - 100;
			_loadImage.y=768 - 100;
			_loadImage.scaleX=_loadImage.scaleY=.5;
			PopUpManager.addPopUp(_loadImage);

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

		override public function dispose():void
		{
			if (_loadImage)
				_loadImage.dispose();
			if (this.assets)
				this.assets.dispose();
		}

		public var playedCallBack:Function;

		private function onGamePlayed(e:Event):void
		{
			removeChild(game);
			game.removeEventListener(PalaceGame.GAME_OVER, onGamePlayed);
			game.removeEventListener(PalaceGame.GAME_RESTART, onGameRestart);
			this.removeFromParent(true);
			if (e)
				game.dispose();
			if (playedCallBack)
				playedCallBack();
		}
	}
}
