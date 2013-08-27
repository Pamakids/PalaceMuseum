package views.global.userInfo
{
	import feathers.controls.ScreenNavigator;
	
	import starling.utils.AssetManager;
	
	import views.components.base.PalaceModule;
	
	public class UserInfo extends PalaceModule
	{
		/**
		 * 导航
		 */		
		private var nav:ScreenNavigator;
		
		public function UserInfo(am:AssetManager=null)
		{
			if(!this.assetManager)
			{
				super(new AssetManager());
				loadAssets();
			}else
			{
				init();
			}
		}
		/**
		 * 资源加载
		 */		
		private function loadAssets():void
		{
			//...
			//...
			//加载完成执行init();
		}
		
		private function init():void
		{
		}
		
		override public function dispose():void
		{
		}
	}
}