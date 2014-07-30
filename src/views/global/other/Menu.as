package views.global.other
{
	import controllers.MC;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.global.TailBar;
	import views.global.TopBar;
	import views.global.books.components.ModuleList;

	public class Menu extends Sprite
	{
		public function Menu()
		{
			super();

			init();
		}

		private var chatArr:Array=["欢迎回来，你想从哪里开始呢？","好久不见了，你可以选择想去的地方。","我正想你呢，你现在想去哪儿呢？"];

		private var BG:Image;
		private var moduleList:ModuleList;
		private var a:AssetManager;
		private function init():void
		{
			a = MC.assetManager;
			BG = new Image( a.getTexture("menuBG") );
			this.addChild( BG );
			BG.touchable = false;

			moduleList=new ModuleList(false);
			this.addChild(moduleList);
			moduleList.x = 28;
			moduleList.y=130;
			moduleList.addEventListener("closeMenu",onClose);

			TailBar.show();
			TopBar.show();
			LionMC.instance.say(chatArr[int(Math.random()*chatArr.length)]);
		}		

		private function onClose():void
		{
			if(moduleList)
			{
				moduleList.removeEventListener("closeMenu",onClose);
				moduleList.removeFromParent(true);
				moduleList=null;
			}
			this.removeFromParent(true);

		}

		override public function dispose():void
		{
			TopBar.hide();
			super.dispose();
		}
	}
}

