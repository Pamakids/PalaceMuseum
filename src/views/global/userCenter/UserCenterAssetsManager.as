package views.global.userCenter
{
	import flash.filesystem.File;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 用户中心资源管理类
	 * @author Administrator
	 * 
	 */	
	public class UserCenterAssetsManager
	{
		private static var _instance:UserCenterAssetsManager;
		
		private static function getInstance():UserCenterAssetsManager
		{
			if(!_instance)
				_instance = new UserCenterAssetsManager(new MyClass());
			return _instance;
		}
		
		private var _assetsManager:AssetManager;
		
		public function UserCenterAssetsManager(myClass:MyClass)
		{
		}
		
		private var _callBack:Function;
		public function set callBakc(value:Function):void
		{
			_callBack = value;
			load();
		}
		
		//加载资源
		private function load():void
		{
			_assetsManager.enqueue(File.applicationDirectory.resolvePath("assets/global/userCenter"));
			_assetsManager.loadQueue(function(ratio:Number):void{
				if (ratio == 1.0)
				{
					if(_callBack)
						_callBack();
				}
			});
		}
		
		public function getTexture(name:String):Texture
		{
			return _assetsManager.getTexture(name);
		}

	}
}

class MyClass{}