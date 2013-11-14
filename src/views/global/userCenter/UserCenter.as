package views.global.userCenter
{
	import com.pamakids.manager.SoundManager;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controllers.MC;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	
	import org.agony2d.utils.getClassName;
	
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
	import views.global.TopBar;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.gameCenter.GameCenterScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;

	/**
	 * 用户中心
	 * @author Administrator
	 */
	public class UserCenter extends Sprite
	{
		/**
		 * 子场景初始化完成后派发该事件
		 */
		public static const Initialized:String="initialized";
		/**
		 * 子场景初始化显示完成，此事件在Initialized之后派发，用以确定场景所有元素及素材加载工作完成，主要用于场景之间的切换
		 */
		public static var InitViewPlayed:String="initViewPlayed";
		/**
		 * 在当前Tab场景内部显示内容更新后派发（如页码变更）
		 */
		public static const ViewUpdated:String="viewUpdated";
		/**
		 * 场景内纹理更新失败，通常原因为已经达到最后一页或处于第一页
		 */
		public static const ViewUpdateFail:String="viewUpdateFail";

		private static const GAMECENTER:String="GameCenterScreen";
		private static const ACHIEVEMENT:String="AchievementScreen";
		private static const COLLECTION:String="CollectionScreen";
		private static const HANDBOOK:String="HandbookScreen";
		private static const USERINFO:String="UserInfoScreen";

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
			MC.isTopBarShow=false;
			TopBar.hide();
			this.screenNames=[USERINFO, HANDBOOK, ACHIEVEMENT, COLLECTION, GAMECENTER];

			initBackgroud();
			initTabBar();
			initBackButton();
			initNavigator();
			initAnimation();
			initRender();
		}

		private function initBackgroud():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("main_background"));
			this.addChild(image);
			image.touchable=false;
		}
		private var _tabBar:TabBar;

		private function initTabBar():void
		{
			_tabBar=new TabBar();
			_tabBar.dataProvider=new ListCollection([
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
				},
				{
					defaultIcon: new Image(UserCenterManager.getTexture("map_up")),
					selectedUpIcon: new Image(UserCenterManager.getTexture("map_down"))
				}
				]);
			_tabBar.direction=TabBar.DIRECTION_HORIZONTAL;
			_tabBar.gap=2;
			_tabBar.x=45;
			_tabBar.y=36;
			this.addChild(_tabBar);
			_tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
		}
		private var _backButton:ElasticButton;

		private function initBackButton():void
		{
			_backButton=new ElasticButton(new Image(MC.assetManager.getTexture("button_close")));
			_backButton.shadow=new Image(MC.assetManager.getTexture("button_close_down"));
			addChild(_backButton);
			_backButton.x=950;
			_backButton.y=60;
			_backButton.addEventListener(ElasticButton.CLICK, onTriggered);
		}
		private var _navigator:ScreenNavigator;

		private function initNavigator():void
		{
			_navigator=new ScreenNavigator();
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen,
				{
					initialized: onInitialized,
					viewUpdated: onViewUpdated,
					viewUpdateFail: onViewUpdateFail,
					initViewPlayed: onInitViewPlayed
				},
				{
					width: contentWidth, height: contentHeight,
					viewWidth: contentWidth, viewHeight: contentHeight
				}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen,
				{
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
				case HANDBOOK:
					(_navigator.activeScreen as HandbookScreen).initView(crtPage_Handbook);
					break;
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
				case HANDBOOK:
					crtPage_Handbook+=(pageUp) ? -1 : 1; //记录
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
				case HANDBOOK:
					hideAnimation();
					break;
				case ACHIEVEMENT:
					hideAnimation();
					break;
			}
		}

		private function onTriggered(e:Event):void
		{
			UserCenterManager.closeUserCenter();
		}

		private function onTouch(e:TouchEvent):void
		{
			var index:int=_tabBar.selectedIndex;
			if ((index != 1 && index != 2) || animation.visible) //速成手册 or 成就
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
					if (_navigator.activeScreen is HandbookScreen) //用户手册页面
					{
						pageUp ? (_navigator.activeScreen as HandbookScreen).pageUp() : (_navigator.activeScreen as HandbookScreen).pageDown();
					}
					else if (_navigator.activeScreen is AchievementScreen) //成就页面
					{
						pageUp ? (_navigator.activeScreen as AchievementScreen).pageUp() : (_navigator.activeScreen as AchievementScreen).pageDown();
					}
					break;
			}
		}

		private function tabs_changeHandler():void
		{
			if (!aniable)
			{
				aniable=true;
				return;
			}
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
			SoundManager.instance.play("");
		}

		private function playedAnimation():void
		{
			hideAnimation();
		}

		/**
		 * 用来屏蔽第一次tabBar的Change事件
		 */
		public var aniable:Boolean=false;
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
		public function turnTo(screen:int, page:int=0):void
		{
			aniable=false;
			prevIndex=screen;
			if (screen == 1)
				crtPage_Handbook=page;
			_tabBar.selectedIndex=screen;
			_navigator.showScreen(screenNames[screen]);
		}
	}
}
