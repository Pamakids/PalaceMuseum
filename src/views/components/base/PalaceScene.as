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
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.Prompt;

	public class PalaceScene extends Sprite
	{
		public var assets:AssetManager;

		public function PalaceScene()
		{
			Prompt.parent=this;
		}

		public function init():void
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

