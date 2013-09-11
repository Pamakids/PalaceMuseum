package views.global.userCenter
{
	import com.greensock.TweenLite;
	
	import flash.utils.Dictionary;
	
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
		public static const MAP:String = "map";
		public static const ACHIEVEMENT:String = "achievement";
		public static const COLLECTION:String = "collection";
		public static const HANDBOOK:String = "handbook";
		public static const USERINFO:String = "userinfo";
		private var screenNames:Array;
		
		private const contentWidth:Number = 968;
		private const contentHeight:Number = 664;
		
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
		
		private var datas:Dictionary;
		
		private function init():void
		{
			this.assets = UserCenterManager.assetsManager;
			this.screenNames = [MAP, USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION];
			this.textures = new Vector.<Texture>(10);
			this.datas = new Dictionary(true);
			
			initBackgroud();
			initTabBar();
			initBackButton();
			initContainer();
//			initPageBackground();
			initNavigator();
		}
		
//		private function initPageBackground():void
//		{
//			this.pageLeftImage=new Image(assets.getTexture("page_left"));
//			this.pageRightImage=new Image(assets.getTexture("page_right"));
//			this._container.addChild(pageLeftImage);
//			this._container.addChild(pageRightImage);
//			pageRightImage.x=this.pageLeftImage.width;
//		}

		private function initBackgroud():void
		{
			this.backgroundImage = new Image(assets.getTexture("main_background"));
			this.addChild( this.backgroundImage );
			this.bookBackground = new Image(assets.getTexture("book_background"));
			this.addChild( this.bookBackground );
			this.bookBackground.y = 74;
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
			_tabBar.gap = 10;
			_tabBar.x = 50;
			_tabBar.y = 30;
			_tabBar.addEventListener( Event.CHANGE, tabs_changeHandler );
		}

		private function initBackButton():void
		{
			_backButton = new Button();
			_backButton.defaultSkin =  new Image(assets.getTexture("button_close"));
			addChild(_backButton);
			_backButton.x = 924;
			_backButton.y = 10;
			_backButton.addEventListener(Event.TRIGGERED, onTriggered);
		}

		private function initNavigator():void
		{
			_navigator = new ScreenNavigator();
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
					width: contentWidth, height: contentHeight
				}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen, 
				{
				}, 
				{
					width: contentWidth, height: contentHeight
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
			this._container.addChild( _navigator );
			_navigator.showScreen(HANDBOOK);
		}

		private function initContainer():void
		{
			_container = new Sprite();
			this.addChild( _container );
			_container.x = 28;
			_container.y = 89;
		}

		/**
		 * 翻页特效动画
		 */		
		private var softBookAnimation:SoftPageAnimation;
		private var textures:Vector.<Texture>;
		private function initAnimation():void
		{
			var i:int = _tabBar.selectedIndex;
			var ts:Vector.<Texture> = (_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
			textures[i*2] = ts[0];
			textures[i*2+1] = ts[1];
			
			softBookAnimation = new SoftPageAnimation(968, 664, textures, i, false);
			softBookAnimation.buttonCallBackMode = true;
			softBookAnimation.addEventListener(SoftPageAnimation.ANIMATION_COMPLETED, animationCompleted);
			this._container.addChild( softBookAnimation );
		}
		
//logical----------------------------------------------------------------------------
		
		private function animationCompleted():void
		{
			softBookAnimation.visible = false;
		}
		
		private var original:int = 2;
		private function tabs_changeHandler():void
		{
			if(softBookAnimation && softBookAnimation.active)		//动画播放中
			{
				_tabBar.selectedIndex = original;
				return;
			}
			
			if(softBookAnimation)
				softBookAnimation.visible = true;
			
			//获取原本页的纹理
			var ts:Vector.<Texture>;
			if(!(textures[original*2] && textures[original*2+1]) && (_navigator.activeScreen as IUserCenterScreen).testTextureInitialized())
			{
				ts = (_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
				textures[original*2] = ts[0];
				textures[original*2+1] = ts[1];
				
				if(!softBookAnimation)
					initAnimation();
			}
			
			var i:int = _tabBar.selectedIndex;
			_navigator.showScreen(screenNames[i]);
			
			//纹理未准备好，延迟回调
			if(!(textures[i*2] && textures[i*2+1]) && !(_navigator.activeScreen as IUserCenterScreen).testTextureInitialized())
			{
				TweenLite.delayedCall(1, tabs_changeHandler);
				return;
			}
			
			//目标页是否存在场景纹理
			if(!(textures[i*2] && textures[i*2+1]) && (_navigator.activeScreen as IUserCenterScreen).testTextureInitialized())
			{
				ts = (_navigator.activeScreen as IUserCenterScreen).getScreenTexture();
				textures[i*2] = ts[0];
				textures[i*2+1] = ts[1];
			}
			
			//检测是否有所需纹理
			if(textures[i*2] && textures[i*2+1] && textures[original*2] && textures[original*2+1] && i!=original)
			{
				softBookAnimation.visible = true;
				softBookAnimation.turnToPage( i );
			}
			else
			{
				softBookAnimation.visible = false;
				softBookAnimation.currentPage = i;
			}
			original = i;
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

		/**
		 * 指定显示速成手册内页码
		 * @param index
		 */		
		public function showIndex(index:int = -1):void
		{
			if(index == -1)
				return;
			if(_navigator.activeScreen is HandbookScreen)
			{
				(_navigator.activeScreen as HandbookScreen).turnToPage( index );
			}
		}
		
		override public function dispose():void
		{
			if(_tabBar)
				_tabBar.dispose();
			_tabBar = null;
			assets = null;
			if(backgroundImage)
				backgroundImage.dispose();
			backgroundImage = null;
			if(bookBackground)
				bookBackground.dispose();
			bookBackground = null;
			if(_navigator)
				_navigator.dispose();
			_navigator = null;
			if(_backButton)
				_backButton.dispose();
			_backButton = null;
			if(_container)
				_container.dispose();
			_container = null;
			if(contentBackground)
				contentBackground.dispose();
			contentBackground = null;
			if(pageLeftImage)
				pageLeftImage.dispose();
			pageLeftImage = null;
			if(pageRightImage)
				pageRightImage.dispose();
			pageRightImage = null;
			screenNames = null;
			if(softBookAnimation)
				softBookAnimation.dispose();
			softBookAnimation=null;
			textures = null;
			super.dispose();
		}

		internal function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
		
	}
}
