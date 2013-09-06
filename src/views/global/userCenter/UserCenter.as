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
		private static const MAP:String = "map";
		private static const ACHIEVEMENT:String = "achievement";
		private static const COLLECTION:String = "collection";
		private static const HANDBOOK:String = "handbook";
		private static const USERINFO:String = "userinfo";
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
			this.assets = UserCenterManager.assetsManager;
			this.screenNames = [MAP, USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION];
			
			initBackgroud();
			initTabBar();
			initBackButton();
			initContainer();
			initPageBackground();
			initNavigator();
			initAnimation();
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
			this.backgroundImage = new Image(assets.getTexture("main_background"));
			this.addChild( this.backgroundImage );
			this.bookBackground = new Image(assets.getTexture("book_background"));
			this.addChild( this.bookBackground );
			this.bookBackground.y = 41;
			this.backgroundImage.touchable = this.bookBackground.touchable = false;
		}

		private function initTabBar():void
		{
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection([
				{
					defaultIcon:		new Image(assets.getTexture("map_up")),
					selectedUpIcon:		new Image(assets.getTexture("map_down"))
				},
				{
					defaultIcon:		new Image(assets.getTexture("userinfo_up")),
					selectedUpIcon:		new Image(assets.getTexture("userinfo_down"))
				},
				{
					defaultIcon:		new Image(assets.getTexture("handbook_up")),
					selectedUpIcon:		new Image(assets.getTexture("handbook_down"))
				},
				{
					defaultIcon:		new Image(assets.getTexture("achievement_up")),
					selectedUpIcon:		new Image(assets.getTexture("achievement_down"))
				},
				{
					defaultIcon:		new Image(assets.getTexture("collection_up")),
					selectedUpIcon:		new Image(assets.getTexture("collection_down"))
				}
			]);
			_tabBar.direction = TabBar.DIRECTION_HORIZONTAL;
			_tabBar.selectedIndex = 2;
			this.addChild( _tabBar );
			_tabBar.x = 60;
			_tabBar.y = 11;
			_tabBar.addEventListener( Event.CHANGE, tabs_changeHandler );
		}

		private function initBackButton():void
		{
			_backButton = new Button();
			_backButton.defaultSkin =  new Image(assets.getTexture("button_close"));
			addChild(_backButton);
			_backButton.x = 924;
			_backButton.y = 20;
			_backButton.addEventListener(Event.TRIGGERED, onTriggered);
		}

		private function initNavigator():void
		{
			_navigator = new ScreenNavigator();
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen, 
				{
				},
				{
					width: 946, height: 696
				}));
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen, 
				{
				}, 
				{
					width: 946, height: 696
				}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen, 
				{
				}, 
				{
					width: 946, height: 696
				}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen, 
				{
				}, 
				{
					width: 946, height: 696
				}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen, 
				{
				}, 
				{
					width: 946, height: 696
				}));
			this._container.addChild( _navigator );
			_navigator.showScreen(HANDBOOK);
		}

		private function initContainer():void
		{
			_container = new Sprite();
			this.addChild( _container );
			_container.x = 42;
			_container.y = 72;
		}

		/**
		 * 翻页特效动画
		 */		
		private var softBookAnimation:SoftPageAnimation;
		private var textures:Vector.<Texture>;
		private function initAnimation():void
		{
			textures = new Vector.<Texture>(10);
			trace(_navigator.activeScreen);
			var ts:Vector.<Texture> = (_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
			var i:int = _tabBar.selectedIndex;
			textures[i*2] = ts[0];
			textures[i*2+1] = ts[1];
			
			softBookAnimation = new SoftPageAnimation(946, 696, textures, i, false);
			softBookAnimation.buttonCallBackMode = true;
			softBookAnimation.addEventListener(SoftPageAnimation.ANIMATION_COMPLETED, animationCompleted);
		}
		
		
//logical----------------------------------------------------------------------------
		
		private function animationCompleted():void
		{
			softBookAnimation.removeFromParent();
		}
		
		private function tabs_changeHandler(e:Event):void
		{
			var i:int = _tabBar.selectedIndex;
			//检测是否有所需纹理
			if(textures[i*2] && textures[i*2+1])
			{
				//播放缓动动画，动画完成后动画清除，showScreen
				this._container.addChild( softBookAnimation );
				softBookAnimation.turnToPage( i );
				_navigator.showScreen(screenNames[i]);
			}
			else
			{
				if((_tabBar.selectedItem as IUserCenterScreen).testTextureInitialized())
				{
					var ts:Vector.<Texture> = (_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
					textures[i*2] = ts[0];
					textures[i*2+1] = ts[1];
					
					//播放缓动动画，动画完成后动画清除，showScreen
					this._container.addChild( softBookAnimation );
					softBookAnimation.turnToPage( i );
					_navigator.showScreen(screenNames[i]);
				}
				else		//纹理未准备完成，跳过动画播放部分，直接显示页面
				{
					_navigator.showScreen(screenNames[i]);
				}
			}
		}

		private function onTriggered(e:Event):void
		{
			//关闭用户中心
			UserCenterManager.closeUserCenter();
		}
		private var _currentIndex:int = -1;
		private function set currentIndex(value:int):void
		{
			if((_currentIndex != -1) && (_currentIndex == value))
				return;
			_currentIndex = value;
			_navigator.showScreen(screenNames[_currentIndex]);
		}

		//用于指定显示速成手册内的内容指引
		private var handbookContent:int = -1;
		public function showIndex(index:int = -1):void
		{
			handbookContent = index;
		}
		
		override public function dispose():void
		{
			
			
			super.dispose();
		}

		internal function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}

	}
}
