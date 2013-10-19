package views.global.userCenter
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import controllers.MC;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.components.LionMC;
	import views.global.TopBar;
	import views.global.map.Map;

	/**
	 * 用户中心管理类
	 * @author Administrator
	 */
	public class UserCenterManager
	{
		[Embed(source="/assets/common/loading.png")]
		private static const Loading:Class

		private static var loaded:Boolean=false;
		private static var _instance:UserCenterManager;

		private static var _assetsManager:AssetManager;

		public function UserCenterManager(myClass:MyClass)
		{
		}

		private static var _index:Number=NaN;

		public static function showUserCenter(index:int=-1):void
		{
			if (!loaded)
			{
				loadAssets();
				_index=index;
				
				//加载地图资源
				Map.loadAssets();
			}
			else
			{
				if (_userCenter && _userCenter.parent)
					return;
				if (!_userCenter)
					_userCenter=new UserCenter(index);
				_userCenterContainer.addChild(_userCenter);
				MC.instance.hideMC();
				LionMC.instance.hide();
			}
		}

		/**关闭方法*/
		public static function closeUserCenter():void
		{
			if (_userCenter)
				_userCenter.removeFromParent(true);
			_userCenter=null;
			MC.instance.showMC();
			TopBar.enable=true;
		}


		private static var _userCenter:UserCenter;

		public static function getCrtUserCenter():UserCenter
		{
			return _userCenter;
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
			_loadImage=new Image(Texture.fromBitmap(new Loading()));
			_loadImage.pivotX=_loadImage.width >> 1;
			_loadImage.pivotY=_loadImage.height >> 1;
			_userCenterContainer.addChild(_loadImage);
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
				"assets/global/mapBG.jpg",
				"assets/global/userCenter/content_page_1.png",
				"assets/global/userCenter/content_page_2.png",
				"json/collection.json"
				);
			_assetsManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					removeLoadImage();
					loaded=true;
					showUserCenter(_index);
				}
			});
		}


		private static function removeLoadImage():void
		{
			_loadImage.removeFromParent(true);
			_loadImage=null;
		}

		private static var _userCenterContainer:DisplayObjectContainer;

		public static function set userCenterContainer(value:DisplayObjectContainer):void
		{
			if (_userCenterContainer && _userCenterContainer == value)
				return;
			_userCenterContainer=value;
		}


		public static function getAssetsManager():AssetManager
		{
			return _assetsManager;
		}

		public static function getTexture(name:String):Texture
		{
			return _assetsManager.getTexture(name);
		}
		
	}
}

class MyClass
{
}
