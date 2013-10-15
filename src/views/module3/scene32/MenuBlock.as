package views.module3.scene32
{
	import starling.display.Sprite;

	public class MenuBlock extends Sprite
	{
		public var index:int;

		public function MenuBlock()
		{
			this.pivotX=MenuGame.blockW >> 1;
			this.pivotY=MenuGame.blockH >> 1;
		}
	}
}
