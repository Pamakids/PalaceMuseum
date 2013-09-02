package views.global.userCenter
{
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.SoftPageAnimation;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.map.MapScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;

	public class UserCenter extends Sprite
	{
		[Embed(source="/assets/module1/loading.png")]
		private var loading:Class

		/**
		 * 场景
		 */
		private static const MAP:String="map";
		private static const ACHIEVEMENT:String="achievement";
		private static const COLLECTION:String="collection";
		private static const HANDBOOK:String="handbook";
		private static const USERINFO:String="userinfo";
		private var screenNames:Array;

		/**
		 * 导航
		 */
		private var _navigator:ScreenNavigator;
		private var _container:Sprite;
		private var _backButton:Button;
		private var _tabBar:TabBar;

		/**
		 * 背景
		 */
		private var backgroundImage:Image;
		private var bookBackground:Image;
		private var contentBackground:Image;
		private var pageRightImage:Image;
		private var pageLeftImage:Image;

		public function UserCenter()
		{
			init();
		}
		private var assets:AssetManager;

		//initialize--------------------------------------------------------------------------------------
		private function init():void
		{
			this.assets=UserCenterManager.assetsManager;
			this.screenNames=[MAP, USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION];

			initBackgroud();
			initTabBar();
			initBackButton();
			initContainer();
			initPageBackground();
			initNavigator();
		}

		private function initPageBackground():void
		{
			this.pageLeftImage=new Image(assets.getTexture("page_left"));
			this.pageRightImage=new Image(assets.getTexture("page_right"));
			this._container.addChild(pageLeftImage);
			this._container.addChild(pageRightImage);
			pageRightImage.x=this.pageLeftImage.width;
		}

		private function initBackgroud():void
		{
			this.backgroundImage=new Image(assets.getTexture("main_background"));
			this.addChild(this.backgroundImage);
			this.bookBackground=new Image(assets.getTexture("book_background"));
			this.addChild(this.bookBackground);
			this.bookBackground.y=41;
			this.backgroundImage.touchable=this.bookBackground.touchable=false;
		}

		private function initTabBar():void
		{
			_tabBar=new TabBar();
			_tabBar.dataProvider=new ListCollection([{defaultIcon: new Image(assets.getTexture("map_up")), selectedUpIcon: new Image(assets.getTexture("map_down"))}, {defaultIcon: new Image(assets.getTexture("userinfo_up")), selectedUpIcon: new Image(assets.getTexture("userinfo_down"))}, {defaultIcon: new Image(assets.getTexture("handbook_up")), selectedUpIcon: new Image(assets.getTexture("handbook_down"))}, {defaultIcon: new Image(assets.getTexture("achievement_up")), selectedUpIcon: new Image(assets.getTexture("achievement_down"))}, {defaultIcon: new Image(assets.getTexture("collection_up")), selectedUpIcon: new Image(assets.getTexture("collection_down"))}]);
			_tabBar.direction=TabBar.DIRECTION_HORIZONTAL;
			_tabBar.selectedIndex=2;
			this.addChild(_tabBar);
			_tabBar.x=60;
			_tabBar.y=11;
			_tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
		}

		private function initBackButton():void
		{
			_backButton=new Button();
			_backButton.defaultSkin=new Image(assets.getTexture("button_close"));
			addChild(_backButton);
			_backButton.x=940;
			_backButton.y=15;
			_backButton.addEventListener(Event.TRIGGERED, onTriggered);
		}

		private function initNavigator():void
		{
			_navigator=new ScreenNavigator();
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen, {}, {}));
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen, {}, {}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen, {}, {}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen, {}, {}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen, {}, {}));
			this._container.addChild(_navigator);

			_navigator.showScreen(HANDBOOK);
		}

		private function initContainer():void
		{
			_container=new Sprite();
			this.addChild(_container);
			_container.x=42;
			_container.y=72;
		}

		private function tabs_changeHandler(e:Event):void
		{
			currentIndex=_tabBar.selectedIndex;
		}

		private function onTriggered(e:Event):void
		{
			//关闭用户中心
			UserCenterManager.closeUserCenter();
		}
		private var _currentIndex:int=-1;

		private function set currentIndex(value:int):void
		{
			if ((_currentIndex != -1) && (_currentIndex == value))
				return;
			_currentIndex=value;
			_navigator.showScreen(screenNames[_currentIndex]);
		}

		//用于指定显示速成手册内的内容指引
		private var handbookContent:int=-1;

		public function showIndex(index:int=-1):void
		{
			handbookContent=index;

//			testAnimations();
		}

		/**动画测试方法*/
		private function testAnimations():void
		{
			//测试动画
			var textures:Vector.<Texture>=new Vector.<Texture>();
			for (var i:int=0; i < 4; i++)
			{
				(i % 2 == 0) ? textures.push(assets.getTexture("page_left")) : textures.push(assets.getTexture("page_right"));
			}
			var animation:SoftPageAnimation=new SoftPageAnimation(940, 696, textures);
			this.addChild(animation);
			animation.x=533;
			animation.y=72;
		}

		override public function dispose():void
		{
			super.dispose();
		}

		internal function setSize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
		}

		//Animation-------------------------------------------------------------------------------------------\
		/**
		 * 翻页特效动画
		 */
		private var softBookAnimation:SoftPageAnimation;

	}
}
