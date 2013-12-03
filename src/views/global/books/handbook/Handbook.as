package views.global.books.handbook
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controllers.MC;
	
	import feathers.controls.Button;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	
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
	import views.global.books.handbook.screen.BirdsScreen;
	import views.global.books.handbook.screen.HandbookScreen;
	import views.global.books.handbook.screen.HistoricalRelicScreen;
	import views.global.books.handbook.screen.MapScreen;
	import views.global.map.Map;
	
	public class Handbook extends Sprite
	{
		private static const SPEED_UP:String="speed_up";
		private static const HISTORICAL_RELIC:String="historical_relic";
		private static const BIRDS:String="birds";
		private static const MAP:String = "map";
		
		private var screenNames:Array;
		
		private const contentWidth:Number=968;
		private const contentHeight:Number=664;
		
		public function Handbook()
		{
			init();
		}
		
		private function init():void
		{
			this.screenNames=[SPEED_UP, HISTORICAL_RELIC, BIRDS, MAP];
			initBackgroud();
			initCataBtn();
			initTabBar();
			initShade();
			initBackButton();
			initNavigator();
			initAnimation();
			initRender();
		}
		
		private var cataBtn:Button;
		private function initCataBtn():void
		{
			cataBtn = new Button();
			cataBtn.defaultSkin = BooksManager.getImage("button_catalogue_up");
			cataBtn.downSkin = BooksManager.getImage("button_catalogue_down");
			this.addChild( cataBtn );
			cataBtn.x = 55;
			cataBtn.y = 4;
			cataBtn.addEventListener(Event.TRIGGERED, openCatalogue);
		}
		
		private function test():void
		{
			var cata:Catalogue = new Catalogue();
			this.addChild( cata );
			cata.x = 28;
			cata.y = 89;
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
					defaultIcon: 	BooksManager.getImage("handbook_up"),
					selectedUpIcon:	BooksManager.getImage("handbook_down")
				},
				{
					defaultIcon:	BooksManager.getImage("historical_relic_up"),
					selectedUpIcon:	BooksManager.getImage("historical_relic_down")
				},
				{
					defaultIcon:	BooksManager.getImage("birds_up"),
					selectedUpIcon:	BooksManager.getImage("birds_down")
				},
				{
					defaultIcon:	BooksManager.getImage("map_up"),
					selectedUpIcon:	BooksManager.getImage("map_down")
				}
			]);
			_tabBar.direction=TabBar.DIRECTION_HORIZONTAL;
			_tabBar.gap=1;
			_tabBar.x=200;
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
			_navigator.addScreen(SPEED_UP, new ScreenNavigatorItem(HandbookScreen,
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
			_navigator.addScreen(HISTORICAL_RELIC, new ScreenNavigatorItem(HistoricalRelicScreen,
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
			_navigator.addScreen(BIRDS, new ScreenNavigatorItem(BirdsScreen,
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
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen,
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
			var i:int=0;
			switch (_navigator.activeScreenID)
			{
				case SPEED_UP:
					i = crtPage_Handbook;
					break;
				case HISTORICAL_RELIC:
					i = crtPage_Allustion;
					break;
				case BIRDS:
					i = crtPage_Birds;
					break;
			}
			(_navigator.activeScreen as Object).initView(i);
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
			switch (_navigator.activeScreenID)
			{
				case SPEED_UP:
					crtPage_Handbook+=(pageUp) ? -1 : 1; //记录
					break;
				case HISTORICAL_RELIC:
					crtPage_Allustion += (pageUp) ? -1 : 1;
					break;
				case BIRDS:
					crtPage_Birds += (pageUp) ? -1 : 1;
					break;
			}
			getTarTexture();
			startAnimation(pageUp);
		}
		
		private function onViewUpdateFail(e:Event):void
		{
			hideAnimation();
		}
		
		private function onTriggered(e:Event):void
		{
			BooksManager.closeCtrBook();
		}
		
		private var cata:Catalogue;
		private function openCatalogue():void
		{
			if(!cata)
			{
				cata = new Catalogue();
				this.addChild( cata );
				cata.x = 93;
				cata.y = 85;
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var index:int=_tabBar.selectedIndex;
			if (animation.visible || index == 3)
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
					pageUp ? (_navigator.activeScreen as Object).pageUp() : (_navigator.activeScreen as Object).pageDown();
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
			if(_navigator.activeScreen is MapScreen)
			{
				Map.show(null, -1, -1, true, true);
				MC.instance.switchLayer( true );
			}
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
		private var crtPage_Allustion:int=0;
		private var crtPage_Birds:int=0;
		
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
			if(cataBtn)
				cataBtn.removeFromParent(true);
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
		 */
		public function turnTo(screen:int, page:int=0, closeable:Boolean=true):void
		{
			prevIndex=screen;
			if (screen == 0)
				crtPage_Handbook=page;
			else if(screen == 1)
				crtPage_Allustion = page;
			else if(screen == 2)
				crtPage_Birds = page;
			_tabBar.selectedIndex=screen;
			_navigator.showScreen(screenNames[screen]);
			this._backButton.visible=closeable;
		}
	}
}