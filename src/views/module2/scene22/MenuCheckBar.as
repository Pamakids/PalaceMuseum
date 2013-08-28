package views.module2.scene22
{
	import starling.display.Sprite;

	public class MenuCheckBar extends Sprite
	{
		public function MenuCheckBar()
		{
		}

		public function set rectX(value:Number):void
		{
			if (clipRect)
				clipRect.x=value;
		}

	}
}
