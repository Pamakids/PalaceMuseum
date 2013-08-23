package views
{
	import com.pamakids.palace.utils.StringUtils;

	import flash.filesystem.File;

	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	import views.components.base.PalaceModule;
	import views.components.base.PalaceScene;
	import views.module1.Scene11;

	public class Module1 extends PalaceModule
	{
		private var sceneArr:Array=[Scene11];

		private var xml:XML;

		private var ta:TextureAtlas;

		private var texturePath:String;

		private var xmlPath:String;
		private var crtScene:PalaceScene;
		private var sceneIndex:int;

		public function Module1()
		{
			addEventListener("gotoNext", nextScene);
			loadScene(0);
		}

		private function nextScene(e:Event):void
		{
			sceneIndex++;
			loadScene(sceneIndex);
		}

		private function loadScene(index):void
		{

			if (index <= sceneArr.length - 1)
			{
				var scene:Class=sceneArr[index] as Class;

				var sceneName:String=StringUtils.getClassName(scene);

				var assets:AssetManager=new AssetManager();
				var file:File=File.applicationDirectory.resolvePath("assets/" + moduleName + "/" + sceneName);
				assets.enqueue(file);
				assets.loadQueue(function(ratio:Number):void
				{
//					trace("Loading assets, progress:", ratio);
					if (ratio == 1.0)
					{
						if (crtScene)
						{
							removeChild(crtScene);
							crtScene.dispose();
						}
						crtScene=new scene(assets);
						addChild(crtScene);
					}
				});
			}
			else
			{
//				removeChild(crtScene);
//				crtScene.dispose();
			}
		}
	}
}

