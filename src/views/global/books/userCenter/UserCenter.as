package views.global.books.userCenter
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controllers.MC;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	
	import org.agony2d.utils.getClassName;
	
	import sound.SoundAssets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.components.ElasticButton;
	import views.components.SoftPaperAnimation;
	import views.global.books.BooksManager;
	import views.global.books.components.Catalogue;
	import views.global.books.userCenter.screen.AchievementScreen;
	import views.global.books.userCenter.screen.CollectionScreen;
	import views.global.books.userCenter.screen.GameCenterScreen;
	import views.global.books.userCenter.screen.UserInfoScreen;

	/**
	 * 用户中心
	 * @author Administrator
	 */
	public class UserCenter extends Sprite
	{
		private static const GAMECENTER:String="GameCenterScreen";
		private static const ACHIEVEMENT:String="AchievementScreen";
		private static const COLLECTION:String="CollectionScreen";
//		private static const HANDBOOK:String="HandbookScreen";
		private static const USERINFO:String="UserInfoScreen";
//		private static const BIRDS:String = "BirdScreen";

		private var screenNames:Array;

		private const contentWidth:Number=968;
		private const contentHeight:Number=664;

		public function UserCenter()
		{
			init();
		}


//initialize--------------------------------------------------------------------------------------
		private function init():void
		{
//			this.screenNames=[USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION, GAMECENTER, BIRDS];
			this.screenNames=[USERINFO, ACHIEVEMENT, COLLECTION, GAMECENTER];

			initBackgroud();
			initTabBar();
			initShade();
			initBackButton();
			initNavigator();
			initAnimation();
			initRender();
			
//			this.addChild( new Catalogue() );
		}
		
		private function initShade():void
		{
			var image:Image = BooksManager.getImage("shade");
			this.addChild( image );
			image.x = 22;
			image.y = 70;
			image.touchable = false;
		}
		
		private function initBackgroud():void
		{
			var image:Image=BooksManager.getImage("main_background");
			this.addChild(image);
			image.touchable=false;
		}
		private var _tabBar:TabBar;

		private function initTabBar():void
		{
			_tabBar=new TabBar();
			_tabBar.dataProvider=new ListCollection([
				{
					defaultIcon: 	BooksManager.getImage("userinfo_up"),
					selectedUpIcon:	BooksManager.getImage("userinfo_down")
				},
//				{
//					defaultIcon:	UserCenterManager.getImage("handbook_up"),
//					selectedUpIcon:	UserCenterManager.getImage("handbook_down")
//				},
				{
					defaultIcon:	BooksManager.getImage("achievement_up"),
					selectedUpIcon:	BooksManager.getImage("achievement_down")
				},
				{
					defaultIcon:	BooksManager.getImage("collection_up"),
					selectedUpIcon:	BooksManager.getImage("collection_down")
				},
				{
					defaultIcon:	BooksManager.getImage("games_up"),
					selectedUpIcon:	BooksManager.getImage("games_down")
				},
//				{
//					defaultIcon:	UserCenterManager.getImage("bird_up"),
//					selectedUpIcon:	UserCenterManager.getImage("bird_down")
//				}
				]);
			_tabBar.direction=TabBar.DIRECTION_HORIZONTAL;
			_tabBar.gap=1;
			_tabBar.x=43;
			_tabBar.y=15;
			this.addChild(_tabBar);
			_tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
		}
		private var _backButton:ElasticButton;

		private function initBackButton():void
		{
			_backButton=new ElasticButton(new Image(MC.assetManager.getTexture("button_close")));
			_backButton.shadow=new Image(MC.assetManager.getTexture("button_close_down"));
			addChild(_backButton);
			_backButton.x=960;
			_backButton.y=60;
			_backButton.addEventListener(ElasticButton.CLICK, onTriggered);
		}
		private var _navigator:ScreenNavigator;

		private function initNavigator():void
		{
			_navigator=new ScreenNavigator();
//			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen,
//				{
//					initialized: onInitialized,
//					viewUpdated: onViewUpdated,
//					viewUpdateFail: onViewUpdateFail,
//					initViewPlayed: onInitViewPlayed
//				},
//				{
//					width: contentWidth, height: contentHeight,
//					viewWidth: contentWidth, viewHeight: contentHeight
//				}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen,
				{
					initialized: onInitialized,
					initViewPlayed: onInitViewPlayed
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen,
				{
					viewUpdated: onViewUpdated,
					viewUpdateFail: onViewUpdateFail,
					initViewPlayed: onInitViewPlayed
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen,
				{
					initViewPlayed: onInitViewPlayed
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(GAMECENTER, new ScreenNavigatorItem(GameCenterScreen,
				{
					initViewPlayed: onInitViewPlayed
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
//			_navigator.addScreen(BIRDS, new ScreenNavigatorItem(BirdScreen,
//				{
//					initialized: onInitialized,
//					viewUpdated: onViewUpdated,
//					viewUpdateFail: onViewUpdateFail,
//					initViewPlayed: onInitViewPlayed
//				},
//				{
//					width: contentWidth, height: contentHeight,
//					viewWidth: contentWidth, viewHeight: contentHeight
//				}));
			_navigator.x=28;
			_navigator.y=89;
			this.addChild(_navigator);
			_navigator.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		private var animation:SoftPaperAnimation;

		private function initAnimation():void
		{
			animation=new SoftPaperAnimation(contentWidth, contentHeight);
			this.addChild(animation);
			animation.addEventListener(Event.COMPLETE, playedAnimation);
			animation.visible=false;
			animation.touchable=false;
			animation.x=28;
			animation.y=89;
		}
		private var textureL:Texture; //初始页左侧纹理
		private var textureR:Texture; //初始页右侧纹理
		private var targetL:Texture; //目标页左侧纹理
		private var targetR:Texture; //目标页右侧纹理
		private var crtRender:RenderTexture; //当前页纹理数据源
		private var targetRender:RenderTexture; //当前页纹理数据源

		private function initRender():void
		{
			crtRender=new RenderTexture(this.contentWidth, this.contentHeight, false);
			targetRender=new RenderTexture(this.contentWidth, this.contentHeight, false);
		}

//eventListener----------------------------------------------------------------------------

		private function onInitialized(e:Event):void
		{
			switch (getClassName(e.currentTarget))
			{
//				case HANDBOOK:
//					(_navigator.activeScreen as HandbookScreen).initView(crtPage_Handbook);
//					break;
//				case USERINFO:
//					(_navigator.activeScreen as UserInfoScreen).setMapVisible(mapVisible);
//					break;
//				case BIRDS:
//					(_navigator.activeScreen as BirdScreen).initView(0);
//					break;
			}
		}

		private function onInitViewPlayed(e:Event):void
		{
			if (!animation.visible)
				return;
			getTarTexture();
			startAnimation(pageUp);
			prevIndex=tarIndex;
		}

		private function onViewUpdated(e:Event):void
		{
			switch (getClassName(e.currentTarget))
			{
//				case HANDBOOK:
//					crtPage_Handbook+=(pageUp) ? -1 : 1; //记录
//				case BIRDS:
				case ACHIEVEMENT:
					getTarTexture();
					startAnimation(pageUp);
					break;
			}
		}

		private function onViewUpdateFail(e:Event):void
		{
			switch (getClassName(e.currentTarget))
			{
//				case HANDBOOK:
				case ACHIEVEMENT:
//				case BIRDS:
					hideAnimation();
					break;
			}
		}

		private function onTriggered(e:Event):void
		{
			BooksManager.closeCtrBook();
		}

		private function onTouch(e:TouchEvent):void
		{
			var index:int=_tabBar.selectedIndex;
//			if ((index != 1 && index != 2 && index != 5) || animation.visible) //速成手册 or 成就 or小鸟
			if (index != 1 || animation.visible)
				return;
			var touch:Touch=e.getTouch(this);
			var point:Point;
			if (!touch)
				return;
			point=touch.getLocation(this);
			switch (touch.phase)
			{
				case TouchPhase.BEGAN:
					beginX=point.x;
					break;
				case TouchPhase.ENDED:
					if (Math.abs(point.x - beginX) < standardLength)
						return;
					pageUp=(beginX < point.x); //方向
					showAnimation();
					/*if (_navigator.activeScreen is HandbookScreen) //用户手册页面
					{
						pageUp ? (_navigator.activeScreen as HandbookScreen).pageUp() : (_navigator.activeScreen as HandbookScreen).pageDown();
					}
					else */if (_navigator.activeScreen is AchievementScreen) //成就页面
					{
						pageUp ? (_navigator.activeScreen as AchievementScreen).pageUp() : (_navigator.activeScreen as AchievementScreen).pageDown();
					}/*else if( _navigator.activeScreen is BirdScreen )
					{
						pageUp ? (_navigator.activeScreen as BirdScreen).pageUp() : (_navigator.activeScreen as BirdScreen).pageDown();
					}*/
					break;
			}
		}

		private function tabs_changeHandler():void
		{
			if (animation.visible)
			{
				_tabBar.selectedIndex=prevIndex;
				return;
			}
			tarIndex=_tabBar.selectedIndex;
			if (tarIndex == prevIndex)
				return;
			pageUp=prevIndex > tarIndex;
			showAnimation();
			_navigator.showScreen(screenNames[tarIndex]);
		}

		private function showAnimation():void
		{
			getCrtTexture();
			animation.setFixPageTexture(textureL, textureR);
			animation.visible=true;
		}

		private function hideAnimation():void
		{
			animation.visible=false;
		}

		private function startAnimation(pageUp:Boolean):void
		{
			if (pageUp) //pageUp
				animation.setSoftPageTexture(targetL, targetR, textureL, textureR);
			else //pageDown
				animation.setSoftPageTexture(textureL, textureR, targetL, targetR);
			animation.start(pageUp);
			SoundAssets.playSFX("centerflip");
		}

		private function playedAnimation():void
		{
			hideAnimation();
		}

		/**
		 * 用来屏蔽第一次tabBar的Change事件
		 */
		private var prevIndex:int=2;
		private var tarIndex:int;
		private var pageUp:Boolean=false;

		//子场景翻页控制
		private var beginX:Number;
		private const standardLength:Number=50; //翻页有效拖拽距离
		private var crtPage_Handbook:int=0;

		private function getCrtTexture():void
		{
			crtRender.draw(_navigator.activeScreen);
			textureL=Texture.fromTexture(crtRender, new Rectangle(0, 0, contentWidth / 2, contentHeight));
			textureR=Texture.fromTexture(crtRender, new Rectangle(contentWidth / 2, 0, contentWidth / 2, contentHeight));
		}

		private function getTarTexture():void
		{
			//从原场景中获取纹理
			targetRender.draw(_navigator.activeScreen);
			targetL=Texture.fromTexture(targetRender, new Rectangle(0, 0, contentWidth / 2, contentHeight));
			targetR=Texture.fromTexture(targetRender, new Rectangle(contentWidth / 2, 0, contentWidth / 2, contentHeight));
		}

		override public function dispose():void
		{
			if (_tabBar)
				_tabBar.removeFromParent(true);
			if (_navigator)
				_navigator.removeFromParent(true);
			if (_backButton)
				_backButton.removeFromParent(true);
			if (animation)
				animation.removeFromParent(true);
			if (crtRender)
				crtRender.dispose();
			if (targetRender)
				targetRender.dispose();
			super.dispose();
		}

		/**
		 * 手册默认显示某一页
		 * @param screen
		 * @param page
		 *
		 */
		public function turnTo(screen:int, page:int=0, closeable:Boolean=true, mapVisible:Boolean=true):void
		{
			prevIndex=screen;
			if (screen == 1)
				crtPage_Handbook=page;
			_tabBar.selectedIndex=screen;
			_navigator.showScreen(screenNames[screen]);
			this._backButton.visible=closeable;
			this.mapVisible=mapVisible;
		}
		private var mapVisible:Boolean=true;
	}
}
