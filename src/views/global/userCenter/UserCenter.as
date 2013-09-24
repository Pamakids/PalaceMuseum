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

	import views.components.SoftPageAnimation;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.map.MapScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;

	public class UserCenter extends Sprite
	{
		[Embed(source="/assets/common/loading.png")]
		private var loading:Class

		/**
		 * 场景
		 */
		public static const MAP:String="map";
		public static const ACHIEVEMENT:String="achievement";
		public static const COLLECTION:String="collection";
		public static const HANDBOOK:String="handbook";
		public static const USERINFO:String="userinfo";
		private var screenNames:Array;

		private const contentWidth:Number=968;
		private const contentHeight:Number=664;

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

//initialize--------------------------------------------------------------------------------------

//		private var datas:Dictionary;

		private function init():void
		{
			this.screenNames=[MAP, USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION];
//			this.datas = new Dictionary(true);

			initBackgroud();
			initTabBar();
			initBackButton();
			initContainer();
			initNavigator();
			initAnimation();
		}

		private function initBackgroud():void
		{
			this.backgroundImage=new Image(UserCenterManager.getTexture("main_background"));
			this.addChild(this.backgroundImage);
			this.bookBackground=new Image(UserCenterManager.getTexture("book_background"));
			this.addChild(this.bookBackground);
			this.bookBackground.y=74;
			this.backgroundImage.touchable=this.bookBackground.touchable=false;
		}

		private function initTabBar():void
		{
			_tabBar=new TabBar();
			_tabBar.dataProvider=new ListCollection([
				{
					defaultIcon: new Image(UserCenterManager.getTexture("map_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("map_down"))
				},
				{
					defaultIcon: new Image(UserCenterManager.getTexture("userinfo_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("userinfo_down"))
				},
				{
					defaultIcon: new Image(UserCenterManager.getTexture("handbook_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("handbook_down"))
				},
				{
					defaultIcon: new Image(UserCenterManager.getTexture("achievement_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("achievement_down"))
				},
				{
					defaultIcon: new Image(UserCenterManager.getTexture("collection_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("collection_down"))
				}
				]);
			_tabBar.direction=TabBar.DIRECTION_HORIZONTAL;
			_tabBar.selectedIndex=2;
			this.addChild(_tabBar);
			_tabBar.gap=2;
			_tabBar.x=45;
			_tabBar.y=36;
			_tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
		}

		private function initBackButton():void
		{
			_backButton=new Button();
			_backButton.defaultSkin=new Image(UserCenterManager.getTexture("button_close"));
			addChild(_backButton);
			_backButton.x=924;
			_backButton.y=10;
			_backButton.addEventListener(Event.TRIGGERED, onTriggered);
		}

		private function initNavigator():void
		{
			_navigator=new ScreenNavigator();
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen,
				{
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen,
				{
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen,
				{
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen,
				{
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen,
				{
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			this._container.addChild(_navigator);
			_navigator.showScreen(HANDBOOK);
		}

		private function initContainer():void
		{
			_container=new Sprite();
			this.addChild(_container);
			_container.x=28;
			_container.y=89;
		}

		/**
		 * 翻页特效动画
		 */
		private var softBookAnimation:SoftPageAnimation;

		private function initAnimation():void
		{
			var i:int=_tabBar.selectedIndex;
			var ts:Vector.<Texture>=(_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
			softBookAnimation=new SoftPageAnimation(968, 664, ts, 0, false);
			softBookAnimation.buttonCallBackMode=true;
			softBookAnimation.addEventListener(SoftPageAnimation.ANIMATION_COMPLETED, animationCompleted);
			this._container.addChild(softBookAnimation);
			softBookAnimation.visible=false;
		}

//logical----------------------------------------------------------------------------

		private function animationCompleted():void
		{
			softBookAnimation.visible=false;
		}

		private var original:int=2;

		private function tabs_changeHandler():void
		{
			if (softBookAnimation && softBookAnimation.active) //动画播放中
			{
				_tabBar.selectedIndex=original;
				return;
			}

			var target:int=_tabBar.selectedIndex;
			if (original == target)
				return;
			//起始页纹理
			var ts1:Vector.<Texture>=(_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
			//目标页
			var ts2:Vector.<Texture>;
			if (target == 2)
				ts2=UserCenterManager.getHandbookTextures().slice(0, 2);
			else
				ts2=UserCenterManager.getScreenTexture(screenNames[target]);

			var ts:Vector.<Texture>;
			var start:int;
			var end:int;

			if (!ts2)
			{
				softBookAnimation.visible=true;
				_navigator.showScreen(screenNames[target]);
				ts2=(_navigator.activeScreen as IUserCenterScreen).getScreenTexture(); //目标页纹理
				ts=new Vector.<Texture>(4);
				if (original > target)
				{
					start=1;
					end=0;
					ts[0]=ts2[0];
					ts[1]=ts2[1];
					ts[2]=ts1[0];
					ts[3]=ts1[1];
				}
				else
				{
					start=0;
					end=1;
					ts[0]=ts1[0];
					ts[1]=ts1[1];
					ts[2]=ts2[0];
					ts[3]=ts2[1];
				}
				softBookAnimation.reSetTextures(ts, start);
				softBookAnimation.turnToPage(end);
			}
			else
			{
				ts=new Vector.<Texture>(4);
				if (original > target)
				{
					start=1;
					end=0;
					ts[0]=ts2[0];
					ts[1]=ts2[1];
					ts[2]=ts1[0];
					ts[3]=ts1[1];
				}
				else
				{
					start=0;
					end=1;
					ts[0]=ts1[0];
					ts[1]=ts1[1];
					ts[2]=ts2[0];
					ts[3]=ts2[1];
				}
				softBookAnimation.reSetTextures(ts, start);
				softBookAnimation.visible=true;
				_navigator.showScreen(screenNames[target]);
				softBookAnimation.turnToPage(end);
			}

			original=target;
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

		/**
		 * 指定显示速成手册内页码
		 * @param index
		 */
		public function showIndex(index:int=-1):void
		{
			if (index == -1)
				return;
			if (_navigator.activeScreen is HandbookScreen)
			{
				(_navigator.activeScreen as HandbookScreen).turnToPage(index);
			}
		}

		override public function dispose():void
		{
			if (_tabBar)
				_tabBar.dispose();
			_tabBar=null;
			if (backgroundImage)
				backgroundImage.dispose();
			backgroundImage=null;
			if (bookBackground)
				bookBackground.dispose();
			bookBackground=null;
			if (_navigator)
				_navigator.dispose();
			_navigator=null;
			if (_backButton)
				_backButton.dispose();
			_backButton=null;
			if (_container)
				_container.dispose();
			_container=null;
			if (contentBackground)
				contentBackground.dispose();
			contentBackground=null;
			if (pageLeftImage)
				pageLeftImage.dispose();
			pageLeftImage=null;
			if (pageRightImage)
				pageRightImage.dispose();
			pageRightImage=null;
			screenNames=null;
			if (softBookAnimation)
				softBookAnimation.dispose();
			softBookAnimation=null;
			super.dispose();
		}

		internal function setSize(width:Number, height:Number):void
		{
			this.width=width;
			this.height=height;
		}

	}
}
