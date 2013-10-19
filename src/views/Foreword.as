package views
{
	import feathers.controls.List;
	
	import starling.display.Sprite;
	import starling.utils.AssetManager;

	/**
	 * 引子
	 * @author Administrator
	 */	
	public class Foreword extends Sprite
	{
		private var assets:AssetManager;
		
		public function Foreword()
		{
			init();
		}
		
		private function init():void
		{
			assets = new AssetManager();
			initList();
		}
		
		private function initList():void
		{
		}
		
		private var list:List;
	}
}