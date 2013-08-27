package views.global.userCenter
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	
	import views.components.base.PalaceModule;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.map.MapScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;
	
	public class UserCenter extends PalaceModule
	{
		private static const MAP:String = "map";
		private static const ACHIEVEMENT:String = "achievement";
		private static const COLLECTION:String = "collection";
		private static const HANDBOOK:String = "handbook";
		private static const USERINFO:String = "userinfo";
		
		/**
		 * 导航
		 */		
		private var _navigator:ScreenNavigator;
		private var _container:Sprite;
		
		public function UserCenter(am:AssetManager=null)
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
			initNavigator();
			initContainer();
			
			
		}
		
		private function initNavigator():void
		{
			_navigator = new ScreenNavigator();
			
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen, {}, {}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen, {}, {}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen, {}, {}));
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen, {}, {}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen, {}, {}));
			
			_navigator.showScreen( HANDBOOK );
		}
		
		private function initContainer():void
		{
		}
		
		override public function dispose():void
		{
		}
	}
}