package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;
	
	import controllers.MC;
	
	import models.SOService;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.global.TopBar;

	public class PalaceGame extends Container
	{
		public static const GAME_OVER:String="gameOver";
		public static const GAME_RESTART:String="gameRestart";

		protected var assetManager:AssetManager;
		public var fromCenter:Boolean=false;

		public function get gameName():String
		{
			return StringUtils.getClassName(this);;
		}

		public function PalaceGame(am:AssetManager=null)
		{
			SOService.instance.setSO(gameName, true);
			assetManager=am;
			super();
		}

		public function get gameResult():String
		{
			return gameName + "gameresult";
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.hide();
			MC.instance.hideMC();
		}

		override protected function init():void
		{
		}

		override public function dispose():void
		{
			if (fromCenter)
				assetManager.dispose()
			else
				assetManager=null;
			super.dispose();
			TopBar.show();
			MC.instance.showMC();
		}

		protected function getImage(name:String):Image
		{
			if (assetManager)
			{
				var t:Texture=assetManager.getTexture(name);
				if (t)
					return new Image(t);
				else
					return null;
			}
			return null;
		}
	}
}
