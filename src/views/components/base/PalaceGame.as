package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.global.TopBar;

	public class PalaceGame extends Container
	{
		public static const GAME_OVER:String="gameOver";
		public static const GAME_RESTART:String="gameRestart";

		public var assets:AssetManager;
		public var fromCenter:Boolean=false;
		public var gameName:String;

		public function PalaceGame(am:AssetManager=null)
		{
			this.assets=am;
			super();
		}

		public function get gameResult():String
		{
			return StringUtils.getClassName(this).toLocaleLowerCase() + "gameresult";
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.hide();
		}

		override protected function init():void
		{
		}

		override public function dispose():void
		{
			if (fromCenter)
				this.assets.dispose()
			else
				this.assets=null;
			super.dispose();
			TopBar.show();

		}

		protected function getImage(name:String):Image
		{
			if (assets)
			{
				var t:Texture=assets.getTexture(name);
				if (t)
					return new Image(t);
				else
					return null;
			}
			return null;
		}
	}
}
