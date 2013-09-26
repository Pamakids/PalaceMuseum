package views.components.base
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.global.TopBar;

	public class PalaceGame extends Container
	{
		protected var assets:AssetManager;

		public function PalaceGame(am:AssetManager=null)
		{
			this.assets=am;
			super();
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
