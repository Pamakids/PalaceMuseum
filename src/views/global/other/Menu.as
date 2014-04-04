package views.global.other
{
	import controllers.MC;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	import views.global.books.components.ModuleList;
	
	public class Menu extends Sprite
	{
		public function Menu()
		{
			super();
			
			init();
		}
		
		private var BG:Image;
		private var moduleList:ModuleList;
		private var a:AssetManager;
		private function init():void
		{
			a = MC.assetManager;
			BG = new Image( a.getTexture("menuBG") );
			this.addChild( BG );
			BG.touchable = false;
			
			moduleList=new ModuleList();
			this.addChild(moduleList);
			moduleList.x = 28;
			moduleList.y=289;
		}		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}