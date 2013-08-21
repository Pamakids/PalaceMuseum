/**
 * 故宫项目
 * 模块
 * starling
 *
 * */

package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;

	import starling.display.Sprite;

	public class PalaceModule extends Sprite
	{
		public var moduleName:String;
		public function PalaceModule()
		{
			moduleName=StringUtils.getClassName(this);
		}

		public function init():void
		{

		}

		override public function dispose():void
		{
			super.dispose();
		}
	}
}

