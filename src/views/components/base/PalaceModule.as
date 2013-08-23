/**
 * 故宫项目
 * 模块
 * starling
 *
 * */

package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	public class PalaceModule extends Sprite
	{
		public var moduleName:String;
		protected var assetManager:AssetManager;
		protected var autoDispose:Boolean=true;

		public function PalaceModule(am:AssetManager=null)
		{
			moduleName=StringUtils.getClassName(this);
			assetManager=am;
		}

		protected function getImage(name:String):Image
		{
			return new Image(assetManager.getTexture(name));
		}

		override public function dispose():void
		{
			if (autoDispose)
				assetManager.dispose();
			assetManager=null;
			super.dispose();
		}
	}
}

