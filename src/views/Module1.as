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
	import views.module1.Scene11;
	import views.module1.Scene12;
	import views.module1.Scene13;

	public class Module1 extends PalaceModule
	{
		private var sceneArr:Array=[Scene11, Scene12, Scene13];

		private var xml:XML;

		private var ta:TextureAtlas;

		private var texturePath:String;

		private var xmlPath:String;
		private var sceneIndex:int;

		public function Module1()
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
				assets.enqueue(file);
				assets.loadQueue(function(ratio:Number):void
				{
//					trace("Loading assets, progress:", ratio);
					if (ratio == 1.0)
					{
						isLoading=false;
						crtScene=new scene(assets);
						addChild(crtScene);

//						TweenLite.delayedCall(3, function():void
//						{
//							MC.instance.nextModule();
//						});
					}
				});
			}
			else
			{
				MC.instance.nextModule();
//				dispatchEvent(new Event("gotoNextModule", true));
			}
		}
	}
}

