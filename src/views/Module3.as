package views
{
	import com.pamakids.palace.utils.StringUtils;

	import flash.filesystem.File;

	import controllers.MC;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.module3.Scene31;
	import views.module3.Scene32;

	public class Module3 extends PalaceModule
	{
		private var sceneArr:Array=[Scene31, Scene32];

		private var xml:XML;

		private var ta:TextureAtlas;

		private var texturePath:String;

		private var xmlPath:String;
		private var sceneIndex:int;

		public function Module3(am:AssetManager=null)
		{
			load=new Sprite();
			addChild(load);
			load.x=1024 - 100;
			load.y=768 - 100;
			load.scaleX=load.scaleY=.5;
			load.addChild(Image.fromBitmap(new loading()));
			load.pivotX=load.pivotY=50;

			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			addEventListener("gotoNext", nextScene);
			sceneIndex=0;
			loadScene(sceneIndex);
		}

		private function onEnterFrame(e:Event):void
		{
			if (isLoading)
				load.rotation+=.2;
		}

		private function nextScene(e:Event):void
		{
			sceneIndex++;
			loadScene(sceneIndex);
		}

		[Embed(source="/assets/module1/loading.png")]
		private var loading:Class

		private var load:Sprite;
		private var isLoading:Boolean;

		private function loadScene(index:int):void
		{
			if (crtScene)
			{
				removeChild(crtScene);
				crtScene.dispose();
			}

			if (index <= sceneArr.length - 1)
			{
				var scene:Class=sceneArr[index] as Class;
				var sceneName:String=StringUtils.getClassName(scene);

				isLoading=true;
				var assets:AssetManager=new AssetManager();
				var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/" + sceneName);
				assets.enqueue(file,
					"assets/common/button_close.png", "assets/common/game-start-down.png",
					"assets/common/game-start.png", "assets/common/gamebg.jpg", "assets/common/lion.png");
				assets.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1.0)
					{
						isLoading=false;
						crtScene=new scene(assets);
						addChild(crtScene);
					}
				});
			}
			else
			{
				MC.instance.nextModule();
			}
		}
	}
}
