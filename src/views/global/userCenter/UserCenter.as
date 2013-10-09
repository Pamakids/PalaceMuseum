package views.global.userCenter
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.components.SoftPaperAnimation;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.map.MapScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;

	/**
	 * 用户中心
	 * @author Administrator
	 * 
	 */	
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

		public function UserCenter()
		{
			init();
		}

//initialize--------------------------------------------------------------------------------------

		private var aniable:Boolean = false;
		private function init():void
		{
			this.screenNames=[MAP, USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION];

			initBackgroud();
			initTabBar();
			initBackButton();
			initContainer();
			initNavigator();
			initAnimation();
			initRender();
		}
		
		//render
		private var crtRender:RenderTexture;
		private var targetRender:RenderTexture;
		private function initRender():void
		{
			crtRender = new RenderTexture(this.contentWidth, this.contentHeight);
			targetRender = new RenderTexture(this.contentWidth, this.contentHeight);
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
			this.addChild(_tabBar);
			_tabBar.gap=2;
			_tabBar.x=45;
			_tabBar.y=36;
			_tabBar.selectedIndex=2;
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
					viewWidth: contentWidth, viewHeight: contentHeight,
					loadAssetsComplete: loadComplete
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
			_container.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private function initAnimation():void
		{
			animation = new SoftPaperAnimation(contentWidth, contentHeight);
			animation.setFixPageTexture(UserCenterManager.getTexture("content_page_1"), UserCenterManager.getTexture("content_page_2"));
			this.addChild( animation );
			animation.addEventListener(Event.COMPLETE, animationCompleted);
			animation.visible = false;
			animation.touchable = false;
			animation.x = 28;
			animation.y = 89;
		}
		
//logical----------------------------------------------------------------------------

		private var animation:SoftPaperAnimation;
		private var prevIndex:int = 2;

		//初始页纹理
		private var textureL:Texture;
		private var textureR:Texture;
		//目标页纹理
		private var targetL:Texture;
		private var targetR:Texture;
		
		private function tabs_changeHandler():void
		{
			if(!aniable)
			{
				aniable = true;
				return;
			}
			if(animation.isRunning())
			{
				_tabBar.selectedIndex = prevIndex;
				return;
			}
			
			var target:int = _tabBar.selectedIndex;
			//从原场景中获取纹理
			(_navigator.activeScreen as BaseScreen).getScreenTexture(crtRender);
			textureL = Texture.fromTexture(crtRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			textureR = Texture.fromTexture(crtRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			animation.setFixPageTexture(textureL, textureR);
			animation.visible = true;
			//使动画可见以遮挡目标页面
			_navigator.showScreen(screenNames[target]);
			//将目标场景加载至舞台，加载完成后获取纹理
			(_navigator.activeScreen as BaseScreen).getScreenTexture(targetRender);
			targetL = Texture.fromTexture(targetRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			targetR = Texture.fromTexture(targetRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			
			pageUp = prevIndex > target;
			//根据动画方向重新设置四个纹理顺序
			if(pageUp)
				animation.setSoftPageTexture(targetL, targetR, textureL, textureR);
			else
				animation.setSoftPageTexture(textureL, textureR, targetL, targetR);
			animation.start( pageUp );
			//修改prevIndex
			prevIndex = target;
			if(prevIndex == 3)		//成就
			{
				crtPage_Achieve = 0;
			}
		}
		
		private function animationCompleted():void
		{
			animation.visible = false;
		}
		
		private function onTriggered(e:Event):void
		{
			UserCenterManager.closeUserCenter();
		}
		
		private var pageUp:Boolean = false;
		
		//子场景翻页控制
		private var beginX:Number;
		private const standardLength:Number = 400;	//翻页有效拖拽距离
		//用户手册场景
		private var crtPage_Handbook:int = 0;
		private const maxPage_Handbook:int = 13;
		//成就场景
		private var crtPage_Achieve:int = 0;
		
		private function onTouch(e:TouchEvent):void
		{
			var index:int = _tabBar.selectedIndex;
			if(index != 2 && index != 3)		//速成手册 or 成就
				return;
			if(animation.isRunning())
				return;
			var touch:Touch = e.getTouch(this);
			var point:Point;
			if(touch)
			{
				point = touch.getLocation(this);
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						beginX = point.x;
						break;
					case TouchPhase.ENDED:
						if( Math.abs( point.x - beginX ) < standardLength )
							return;
						//方向
						pageUp = (beginX < point.x);
						if(index==2)					//用户手册页面
						{
							//检测页面范围
							if(pageUp && crtPage_Handbook == 0)
								return;
							if(!pageUp && crtPage_Handbook >= maxPage_Handbook-1)
								return;
							crtPage_Handbook += (pageUp?-1:1);
							handbookTurnToPage(crtPage_Handbook);
						}
						else if(index == 3)				//成就页面
						{
							var maxPage_Achieve:int = (_navigator.activeScreen as AchievementScreen).maxPage;
							//检测页面范围
							if(pageUp && crtPage_Achieve == 0)
								return;
							if(!pageUp && crtPage_Achieve >= maxPage_Achieve-1)
								return;
							crtPage_Achieve += (pageUp?-1:1);
							achieveTurnToPage(crtPage_Achieve);
						}
						break;
				}
			}
		}
		
		//速成手册翻页
		private function handbookTurnToPage(pageIndex:int):void
		{
			//从原场景中获取纹理
			(_navigator.activeScreen as BaseScreen).getScreenTexture(crtRender);
			textureL = Texture.fromTexture(crtRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			textureR = Texture.fromTexture(crtRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			animation.setFixPageTexture(textureL, textureR);
			animation.visible = true;
			
			if(!(_navigator.activeScreen as HandbookScreen).hasAssets(pageIndex))
			{
				return;
			}else
			{
				loadComplete()
			}
		}
		
		
		private function loadComplete():void
		{
			(_navigator.activeScreen as HandbookScreen).updateView(crtPage_Handbook);
			//将目标场景加载至舞台，加载完成后获取纹理
			(_navigator.activeScreen as BaseScreen).getScreenTexture(targetRender);
			targetL = Texture.fromTexture(targetRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			targetR = Texture.fromTexture(targetRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			
			if(pageUp)		//pageUp
				animation.setSoftPageTexture(targetL, targetR, textureL, textureR);
			else						//pageDown
				animation.setSoftPageTexture(textureL, textureR, targetL, targetR);
			animation.start( pageUp );
		}

		
		//成就翻页
		private function achieveTurnToPage(pageIndex:int):void
		{
			(_navigator.activeScreen as BaseScreen).getScreenTexture(crtRender);
			textureL = Texture.fromTexture(crtRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			textureR = Texture.fromTexture(crtRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			animation.setFixPageTexture(textureL, textureR);
			animation.visible = true;
			
			(_navigator.activeScreen as AchievementScreen).updateView(crtPage_Achieve);
			(_navigator.activeScreen as BaseScreen).getScreenTexture(targetRender);
			targetL = Texture.fromTexture(targetRender, new Rectangle(0, 0, contentWidth/2, contentHeight));
			targetR = Texture.fromTexture(targetRender, new Rectangle(contentWidth/2, 0, contentWidth/2, contentHeight));
			if(pageUp)		//pageUp
				animation.setSoftPageTexture(targetL, targetR, textureL, textureR);
			else			//pageDown
				animation.setSoftPageTexture(textureL, textureR, targetL, targetR);
			animation.start( pageUp );
		}
		
		/**
		 * 指定显示速成手册内页码
		 * @param index
		 */
		public function showIndex(index:int=-1):void
		{
			if(index <= 0 || index >= maxPage_Handbook)
				return;
			pageUp = false;
			crtPage_Handbook = index;
			handbookTurnToPage(index);
		}

		override public function dispose():void
		{
			if (_tabBar)
				_tabBar.removeFromParent(true);
			if (backgroundImage)
				backgroundImage.removeFromParent(true);
			if (bookBackground)
				bookBackground.removeFromParent(true);
			if (_navigator)
				_navigator.removeFromParent(true);
			if (_backButton)
				_backButton.removeFromParent(true);
			if (_container)
				_container.removeFromParent(true);
			if(animation)
				animation.removeFromParent(true);
			if(crtRender)
				crtRender.dispose();
			if(targetRender)
				targetRender.dispose();
			super.dispose();
		}
	}
}
