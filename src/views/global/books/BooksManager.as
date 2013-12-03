package views.global.books
{
	import com.greensock.TweenMax;
	
	import flash.filesystem.File;
	
	import controllers.MC;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.components.LionMC;
	import views.components.base.PalaceModule;
	import views.global.TopBar;
	import views.global.books.handbook.Handbook;
	import views.global.books.userCenter.UserCenter;

	/**
	 * 用户中心管理类
	 * @author Administrator
	 */
	public class BooksManager
	{
		private static var loaded:Boolean=false;
		private static var _instance:BooksManager;

		private static var _assetsManager:AssetManager;

		public function BooksManager(myClass:MyClass)
		{
		}

		private static var _book:int;
		private static var _page:int;
		private static var _screen:int;
		private static var _closeable:Boolean;
		private static var _mapVisible:Boolean;
		
		/**
		 * @param book			0 用户中心/ 1 手册
		 * @param screen
		 * @param page
		 * @param closeable时
		 * @param mapVisible	地图按钮是否可见
		 */
		public static function showBooks(book:int, screen:int=1, page:int=0, closeable:Boolean=true, mapVisible=true):void
		{
			MC.instance.topBarLayer.visible=false;
			_book = book;
			_screen=screen;
			_page=page;
			_closeable=closeable;
			_mapVisible=mapVisible;
			if (!loaded)
				loadAssets();
			else
				showHandler();
		}

		private static function showHandler():void
		{
//			MC.instance.switchLayer(false);
//			if (_userCenter && _userCenter.parent)
//			{
//				MC.instance.main.removeMask();
//				enable();
//				MC.instance.hideMC();
//				LionMC.instance.hide();
//				return;
//			}
			MC.instance.main.removeMask();
			if(_book == 0)
			{
				if (!_userCenter)
				{
					TweenMax.pauseAll();
					_userCenter=new UserCenter();
				}
				_userCenter.turnTo(_screen, _page, _closeable, _mapVisible);
				container.addChild( _userCenter );
			}else
			{
				if(!_handbook)
				{
					TweenMax.pauseAll();
					_handbook = new Handbook();
				}
				_handbook.turnTo(_screen, _page, _closeable);
				container.addChild( _handbook );
			}
			
			MC.instance.hideMC();
			LionMC.instance.hide();
		}

		/**关闭方法*/
		public static function closeCtrBook():void
		{
			TweenMax.resumeAll();
			if (_userCenter)
				_userCenter.removeFromParent(true);
			if(_handbook)
				_handbook.removeFromParent( true );
			MC.instance.showMC();
			LionMC.instance.show();
			TopBar.enable=true;
			MC.instance.topBarLayer.visible=true;
			TopBar.show();
			_userCenter=null;
			_handbook = null;
//			MC.instance.switchLayer(true);
		}

		private static var _handbook:Handbook;
		private static var _userCenter:UserCenter;

		public static function getCrtUserCenter():UserCenter
		{
			return _userCenter;
		}
		public static function getCrtHandbook():Handbook
		{
			return _handbook;
		}

		public static function enable():void
		{
			if (_userCenter)
				_userCenter.touchable=true;
		}

		public static function disable():void
		{
			if (_userCenter)
				_userCenter.touchable=false;
		}

		/**
		 * 资源加载
		 */
		private static function loadAssets():void
		{
			initLoadImage();
			loadFunc();
		}

		private static var _loadImage:Image;

		private static function initLoadImage():void
		{
			_loadImage=new Image(Texture.fromBitmap(new PalaceModule.loading()));
			_loadImage.pivotX=_loadImage.width >> 1;
			_loadImage.pivotY=_loadImage.height >> 1;
			container.addChild(_loadImage);
			_loadImage.x=1024 - 100;
			_loadImage.y=768 - 100;
			_loadImage.scaleX=_loadImage.scaleY=.5;
			_loadImage.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				_loadImage.rotation+=0.2;
			});
		}

		private static function loadFunc():void
		{
			_assetsManager=new AssetManager();
			_assetsManager.enqueue(
				File.applicationDirectory.resolvePath("assets/global/userCenter/mainUI"),
				"json/collection.json",
				"json/catalogue.json"
				);
			_assetsManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					removeLoadImage();
					loaded=true;
					showHandler();
				}
			});
		}


		private static function removeLoadImage():void
		{
			_loadImage.removeFromParent(true);
			_loadImage=null;
		}

		private static var container:DisplayObjectContainer;

		public static function set userCenterContainer(value:DisplayObjectContainer):void
		{
			if (container && container == value)
				return;
			container=value;
		}


		public static function getAssetsManager():AssetManager
		{
			return _assetsManager;
		}

		public static function getTexture(name:String):Texture
		{
			return _assetsManager.getTexture(name);
		}

		public static function getImage(name:String):Image
		{
			return new Image(_assetsManager.getTexture(name));
		}

	}
}

class MyClass
{
}
