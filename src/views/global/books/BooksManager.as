package views.global.books
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.filesystem.File;
	
	import controllers.MC;
	
	import models.AchieveVO;
	import models.FontVo;
	import models.SOService;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import views.components.LionMC;
	import views.components.base.PalaceModule;
	import views.global.TopBar;
	import views.global.books.handbook.Handbook;
	import views.global.books.userCenter.UserCenter;
	import views.global.map.Map;

	/**
	 * 用户中心管理类
	 * @author Administrator
	 */
	public class BooksManager
	{
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
			_book=book;
			_screen=screen;
			_page=page;
			_closeable=closeable;
			_mapVisible=mapVisible;
			loadAssets();
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
			if (_book == 0)
			{
				if (!_userCenter)
				{
					TweenMax.pauseAll();
					LionMC.instance.playHide();
					_userCenter=new UserCenter();
				}
				_userCenter.turnTo(_screen, _page, _closeable, _mapVisible);
				container.addChild(_userCenter);
			}
			else
			{
				if (!_handbook)
				{
					TweenMax.pauseAll();
					_handbook=new Handbook();
				}
				_handbook.turnTo(_screen, _page, _closeable);
				container.addChild(_handbook);
			}

			MC.instance.hideMC();
			LionMC.instance.hide();

			MC.instance.switchLayer(false);
		}

		/**关闭方法*/
		public static function closeCtrBook():void
		{
			TweenMax.resumeAll();
			if (_userCenter)
				_userCenter.removeFromParent(true);
			if (_handbook)
				_handbook.removeFromParent(true);
			MC.instance.showMC();
			LionMC.instance.show();
			TopBar.enable=true;
			MC.instance.topBarLayer.visible=true;
			TopBar.show();
			_userCenter=null;
			_handbook=null;
//			MC.instance.switchLayer(true);
			if (_assetsManager)
				_assetsManager.purge();
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

		private static var _loadImage:Object;

		private static var _loadBG:Image;

		private static function initLoadImage():void
		{
			if (!MC.instance.currentModule && (!Map.map || !Map.map.visible))
			{
				_loadBG=Image.fromBitmap(new PalaceModule.gameBG());
				MC.instance.main.addChildAt(_loadBG, 0);
				_loadImage=new LoadingMC();
				MC.instance.addMC(_loadImage as MovieClip);
				_loadImage.x=1024 - 172;
				_loadImage.y=768 - 126;
				_loadImage.play();
			}
			else
			{
				_loadImage=new Image(Texture.fromBitmap(new PalaceModule.loading()));
				_loadImage.pivotX=_loadImage.width >> 1;
				_loadImage.pivotY=_loadImage.height >> 1;
				container.addChild(_loadImage as Image);
				_loadImage.x=1024/2;
				_loadImage.y=768/2;
				_loadImage.scaleX=_loadImage.scaleY=.5;
				_loadImage.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					_loadImage.rotation+=0.2;
				});
			}
		}

		private static function loadFunc():void
		{
			if (!_assetsManager)
				_assetsManager=new AssetManager();
			_assetsManager.purge();
			_assetsManager=new AssetManager();
			if (!_book) //用户中心
				_assetsManager.enqueue(
					File.applicationDirectory.resolvePath("assets/global/userCenter/mainUI"),
					"json/collection.json"
					);
			else //手册
				_assetsManager.enqueue(
					File.applicationDirectory.resolvePath("assets/global/handbook/mainUI"),
					"json/catalogue.json"
					);
			_assetsManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1.0)
				{
					removeLoadImage();
					showHandler();
				}
			});
		}


		private static function removeLoadImage():void
		{
			if (_loadImage is MovieClip)
			{
				MC.instance.removeMC(_loadImage as MovieClip);
				_loadImage.stop();
				_loadImage=null;
			}
			else
			{
				_loadImage.removeFromParent(true);
				_loadImage=null;
			}

			if (_loadBG)
			{
				_loadBG.removeFromParent(true);
				_loadBG=null;
			}
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
		
		public static function showAchieve(index:int):void
		{
			if(SOService.instance.getSO(index + "_achieve"))
				return;
			SOService.instance.setSO(index+"_achieve", true);
			var txt:String="恭喜您获得成就: " + AchieveVO.achieveList[index][0];
			var sprite:Sprite = new Sprite();
			var screen:Sprite = _handbook ? _handbook : _userCenter;
			screen.addChild( sprite );
			var image:Image = new Image( MC.assetManager.getTexture("acheivebar") );
			image.pivotX=image.width >> 1;
			sprite.addChild(image);
			var tf:TextField = new TextField(400, 80, txt, FontVo.PALACE_FONT, 32, 0xfbf4cb);
			sprite.addChild(tf);
			tf.x=-200;
			tf.y=15;
			sprite.x=512;
			sprite.y=-170;
			TweenLite.to(sprite, .5, {y: 0});
			TweenLite.delayedCall(2.5, function():void{
				TweenLite.to(sprite, .5, {y: -170, onComplete: function():void{
					sprite.removeFromParent(true);
				}});
			});
		}

	}
}

class MyClass
{
}


