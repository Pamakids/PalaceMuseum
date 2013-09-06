package views.global.userCenter
{
	import flash.filesystem.File;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 用户中心管理类
	 * @author Administrator
	 */
	public class UserCenterManager
	{
		[Embed(source="/assets/module1/loading.png")]
		private static const Loading:Class

		private static var loaded:Boolean=false;
		private static var _instance:UserCenterManager;

		private static var _assetsManager:AssetManager;

		public static function get assetsManager():AssetManager
		{
			return _assetsManager;
		}

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
			}
			else
			{
				if (!_userCenter)
					initUserCenter();
				_userCenterContainer.addChild(_userCenter);
				_userCenter.showIndex((_index) ? _index : index);
				_index=NaN;
			}
		}

		/**关闭方法*/
		public static function closeUserCenter():void
		{
			_userCenter.removeFromParent(true);
			_userCenter=null;
		}


		private static var _userCenter:UserCenter;

		private static function initUserCenter():void
		{
			_userCenter=new UserCenter();
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
			_loadImage.x=_userCenterContainer.width >> 1;
			_loadImage.y=_userCenterContainer.height >> 1;
			_loadImage.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				_loadImage.rotation+=0.2;
			});
		}

		private static function loadFunc():void
		{
			_assetsManager=new AssetManager();
			_assetsManager.enqueue(File.applicationDirectory.resolvePath("assets/global/userCenter"));
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

		public static function setUserCenterSize(width:Number, height:Number):void
		{
			_userCenter.setSize(width, height);
		}
	}
}

class MyClass
{
}
