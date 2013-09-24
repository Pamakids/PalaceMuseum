package views.global.userCenter
{
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import models.SOService;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.global.userCenter.achievement.AchieveIcon;

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
				_userCenter.showIndex(index);
			}
		}

		/**关闭方法*/
		public static function closeUserCenter():void
		{
			if (_userCenter)
				_userCenter.removeFromParent(true);
			_userCenter=null;
		}


		private static var _userCenter:UserCenter;
		private static var _userDatas:Dictionary;

		private static function initUserCenter():void
		{
			//获取用户相关数据
			_userDatas=new Dictionary(true);
			_userCenter=new UserCenter();
		}
		
		public static function getCrtUserCenter():UserCenter
		{
			return _userCenter;
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
			_assetsManager.enqueue(File.applicationDirectory.resolvePath("assets/global/userCenter"));
			_assetsManager.enqueue("assets/global/mapBG.jpg");
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

		/**
		 * 获取用户中心Tab场景相关数据
		 * @param screen
		 * @return
		 */
		public static function getDatas(screen:String):Array
		{
			if (!_userDatas[screen] || testNeedUpdate(screen))
				_userDatas[screen]=SOService.instance.getSO(screen);
			if (!_userDatas[screen])
			{
				_userDatas[screen]=[];
				SOService.instance.setSO(screen, _userDatas[screen]);
			}
			return _userDatas[screen];
		}

		/**
		 * 检测指定场景数据是否需重新获取
		 * @param screen
		 * @return
		 */
		private static var needUpdateScreens:Array=[];

		private static function testNeedUpdate(screen:String):Boolean
		{
			return !(needUpdateScreens.indexOf(screen) == -1);
		}

		public static function setNeedUpdate(screen:String):void
		{
			if ((needUpdateScreens.indexOf(screen) == -1))
				needUpdateScreens.push(screen);
		}


		public static function getAssetsManager():AssetManager
		{
			return _assetsManager;
		}
		public static function getTexture(name:String):Texture
		{
			return _assetsManager.getTexture(name);
		}

		private static var textures:Dictionary=new Dictionary();

		public static function getScreenTexture(screen:String):Vector.<Texture>
		{
			if (textures[screen])
				return textures[screen];
			return null;
		}

		public static function setScreenTextures(screen:String, value:Object):void
		{
			if(textures[screen] && textures[screen] == value)
				return;
			textures[screen]=value;
		}

		private static const NumPages:int = 26;
		
		public static function getHandbookTextures():Vector.<Texture>
		{
			if (!textures["handbook_textures"])
			{
				var vecTexture:Vector.<Texture>=new Vector.<Texture>();
				var tx1:Texture = _assetsManager.getTexture("page_left");
				var tx2:Texture = Texture.fromTexture(tx1, new Rectangle(0,0,tx1.width,tx1.height));
				trace(tx1 == tx2);
				var leftImage:Image=new Image(_assetsManager.getTexture("page_left"));
				var rightImage:Image=new Image(_assetsManager.getTexture("page_right"));
				for (var i:int=0; i < NumPages; i++)
				{
					var render:RenderTexture=new RenderTexture(484, 664, true);
					var image:Image=new Image(UserCenterManager.getTexture("content_page_" + String(i + 1)));
					image.width=484;
					image.height=664;

					if (i % 2 == 0) //左
						render.draw(leftImage);
					else //右
						render.draw(rightImage);
					render.draw(image)
					vecTexture.push(render);
				}

				textures["handbook_textures"]=vecTexture;
			}
			return textures["handbook_textures"];
		}
	}
}

class MyClass
{
}
