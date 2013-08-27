package views.global.userCenter
{
	import flash.filesystem.File;
	
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.components.base.PalaceModule;
	import views.global.userCenter.achievement.AchievementScreen;
	import views.global.userCenter.collection.CollectionScreen;
	import views.global.userCenter.handbook.HandbookScreen;
	import views.global.userCenter.map.MapScreen;
	import views.global.userCenter.userInfo.UserInfoScreen;
	
	public class UserCenter extends PalaceModule
	{
		[Embed(source="/assets/module1/loading.png")]
		private var loading:Class
		
		private static const MAP:String = "map";
		private static const ACHIEVEMENT:String = "achievement";
		private static const COLLECTION:String = "collection";
		private static const HANDBOOK:String = "handbook";
		private static const USERINFO:String = "userinfo";
		
		private var _index:int;
		private var _loadImage:Image;
		/**
		 * 导航
		 */		
		private var _navigator:ScreenNavigator;
		private var _container:Sprite;
		private var _backButton:Button;
		private var _isLoading:Boolean = false;
//		private const _buttonStyles:Array = [
//			{name: MAP,			x: 67,		y: 11},
//			{name: USERINFO,	x: 231,		y: 11},
//			{name: HANDBOOK,	x: 384,		y: 11},
//			{name: ACHIEVEMENT,	x: 543,		y: 11},
//			{name: COLLECTION,	x: 708,		y: 11}
//		];
		private var _buttons:ButtonGroup;
		
		/**
		 * 背景
		 */
		private var backgroundImage:Image;
		private var bookGround:Image;
		
		public function UserCenter(am:AssetManager=null, index:int = -1)
		{
			if(!this.assetManager)
			{
				(am)?super(new AssetManager()):super(am);
				loadAssets();
			}else
			{
				init();
			}
			
			//根据用户当前所处的场景，在速成手册页面显示指定内容
			this._index = index;
		}
		/**
		 * 资源加载
		 */		
		private function loadAssets():void
		{
			initLoadImage();
			loadFunc();
		}
		
		private function initLoadImage():void
		{
			_loadImage = new Image(Texture.fromBitmap(new loading()));
			_loadImage.pivotX = _loadImage.width >> 1;
			_loadImage.pivotY = _loadImage.height >> 1;
			this.addChild( _loadImage );
			_loadImage.x = stage.stageWidth >> 1;
			_loadImage.y = stage.stageHeight >> 1;
			_loadImage.addEventListener(Event.ENTER_FRAME, onEventFrame);
		}
		
		private function loadFunc():void
		{
			_isLoading=true;
			this.assetManager.enqueue(File.applicationDirectory.resolvePath("assets/global/userCenter"));
			this.assetManager.loadQueue(function(ratio:Number):void{
				//trace("Loading assets, progress:", ratio);
				if (ratio == 1.0)
				{
					removeLoadImage();
					init();
				}
			});
		}
		
		private function removeLoadImage():void
		{
			_loadImage.removeEventListener(Event.ENTER_FRAME, onEventFrame);
			_loadImage.removeFromParent(true);
			_loadImage = null;
		}
		
		private function onEventFrame(e:Event):void
		{
			_loadImage.rotation += 0.2;
		}
		
		private function init():void
		{
			initContainer();
			initBackGroud();
			initButtons();
			initNavigator();
		}
		
		private function initBackGroud():void
		{
		}
		
		private function initButtons():void
		{
			_buttons = new ButtonGroup();
			_buttons.dataProvider = new ListCollection([
				{name:MAP, x:67, y:11, defaultSkin: new Image(this.assetManager.getTexture(MAP+"_up")), defaultSelectedSkin:new Image(this.assetManager.getTexture(MAP+"_down")), selected: changeScreen},
				{name:USERINFO, x:231, y:11, defaultSkin: new Image(this.assetManager.getTexture(USERINFO+"_up")), defaultSelectedSkin:new Image(this.assetManager.getTexture(USERINFO+"_down")), selected: changeScreen},
				{name:HANDBOOK, x:384, y:11, defaultSkin: new Image(this.assetManager.getTexture(HANDBOOK+"_up")), defaultSelectedSkin:new Image(this.assetManager.getTexture(HANDBOOK+"_down")), selected: changeScreen},
				{name:ACHIEVEMENT, x:643, y:11, defaultSkin: new Image(this.assetManager.getTexture(ACHIEVEMENT+"_up")), defaultSelectedSkin:new Image(this.assetManager.getTexture(ACHIEVEMENT+"_down")), selected: changeScreen},
				{name:COLLECTION, x:708, y:11, defaultSkin: new Image(this.assetManager.getTexture(COLLECTION+"_up")), defaultSelectedSkin:new Image(this.assetManager.getTexture(COLLECTION+"_down")), selected: changeScreen}
			]);
			this.addChild( _buttons );
			
			_backButton = new Button();
			_backButton.defaultSkin =  new Image(this.assetManager.getTexture("backButton_up"));
			_backButton.defaultSkin =  new Image(this.assetManager.getTexture("backButton_up"));
			addChild(_backButton);
			_backButton.addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		private function onTriggered(e:Event):void
		{
			//需要一个单独的素材管理单例类，用来在结束时保存素材
			//退出用户中心
		}
		
		private function initNavigator():void
		{
			_navigator = new ScreenNavigator();
			_navigator.addScreen(MAP, new ScreenNavigatorItem(MapScreen, {}, {}));
			_navigator.addScreen(ACHIEVEMENT, new ScreenNavigatorItem(AchievementScreen, {}, {}));
			_navigator.addScreen(COLLECTION, new ScreenNavigatorItem(CollectionScreen, {}, {}));
			_navigator.addScreen(HANDBOOK, new ScreenNavigatorItem(HandbookScreen, {}, {}));
			_navigator.addScreen(USERINFO, new ScreenNavigatorItem(UserInfoScreen, {}, {}));
			this.addChild( _navigator );
			_navigator.showScreen( HANDBOOK );
		}
		
		private function initContainer():void
		{
			_container = new Sprite();
			this.addChild( _container );
			_container.x = 42;
			_container.y = 72;
		}
		
		private function changeScreen(e:Event):void
		{
			
		}
		
		override public function dispose():void
		{
			//...
			//...
			super.dispose();
		}
	}
}