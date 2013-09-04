/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package views.components.base
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.global.TopBar;

	public class PalaceScene extends Container
	{
		protected var assets:AssetManager;

		public function PalaceScene(am:AssetManager=null)
		{
			Prompt.parent=this;
			Prompt.addAssetManager(am);
			this.assets=am;
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.show();
		}

		override protected function init():void
		{
		}

		override public function dispose():void
		{
			if (assets)
			{
				removeChildren();
				assets.dispose();
				Prompt.removeAssetManager(assets);
			}
			super.dispose();
			TopBar.hide();
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

