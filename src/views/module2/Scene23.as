package views.module2
{
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module2.scene23.ShootGame;

	public class Scene23 extends PalaceScene
	{
		public function Scene23(am:AssetManager=null)
		{
			super(am);

			var game:ShootGame=new ShootGame(am);
			addChild(game);
		}
	}
}

