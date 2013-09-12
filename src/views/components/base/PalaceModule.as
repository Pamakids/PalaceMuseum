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
	import starling.utils.AssetManager;

	public class PalaceModule extends Container
	{
		public var moduleName:String;
		protected var assetManager:AssetManager;
		protected var autoDispose:Boolean=true;
		public var crtScene:PalaceScene;

		public function PalaceModule(am:AssetManager=null, width:Number=0, height:Number=0)
		{
			moduleName=StringUtils.getClassName(this);
			assetManager=am;
			super(width, height);
		}

		protected function getImage(name:String):Image
		{
			return new Image(assetManager.getTexture(name));
		}

		override public function dispose():void
		{
			if (autoDispose && assetManager)
				assetManager.dispose();
			assetManager=null;
			super.dispose();
		}
	}
}

