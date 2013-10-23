/**
 * 故宫项目
 * 模块
 * starling
 *
 * */

package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;
	
	import controllers.MC;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	import views.components.ElasticButton;

	public class PalaceModule extends Container
	{
		public function get moduleName():String
		{
			return StringUtils.getClassName(this);;
		}

		protected var assetManager:AssetManager;
		public var crtScene:PalaceScene;
		protected var tfHolder:Sprite;
		protected var skipIndex:int=-1;

		[Embed(source="/assets/common/loading.png")]
		public static var loading:Class

		[Embed(source="/assets/common/gamebg.jpg")]
		protected static var loadingBG:Class

		public function PalaceModule(am:AssetManager=null, width:Number=0, height:Number=0)
		{
			assetManager=am;
			super(width, height);
//			LionMC.instance.hide();
		}

		protected var load:Sprite;
		protected var isLoading:Boolean;

		protected var Q1:String=""
		protected var A1:String=""
		protected var Q2:String=""
		protected var A2:String=""

		protected function addQAS():void
		{
			var isSingle:Boolean=(Q2 == "");
			tfHolder=new Sprite();
			addChild(tfHolder);
			tfHolder.touchable=false;
			var bg:Image=Image.fromBitmap(new loadingBG());
			tfHolder.addChild(bg);

			var tfQ1:TextField=new TextField(600, 100, Q1, FontVo.PALACE_FONT, 32, 0xffffff, true);
			tfQ1.x=200;
			tfQ1.y=isSingle ? 200 : 100;
			tfQ1.hAlign="left";
			tfQ1.vAlign="top";
			tfHolder.addChild(tfQ1);
			var tfA1:TextField=new TextField(600, 150, A1, FontVo.PALACE_FONT, 28, 0xffffff, true);
			tfA1.x=220;
			tfA1.y=isSingle ? 350 : 180;
			tfA1.hAlign="left";
			tfA1.vAlign="top";
			tfHolder.addChild(tfA1);
			var tfQ2:TextField=new TextField(600, 100, Q2, FontVo.PALACE_FONT, 32, 0xffffff, true);
			tfQ2.x=200;
			tfQ2.y=400;
			tfQ2.hAlign="left";
			tfQ2.vAlign="top";
			tfHolder.addChild(tfQ2);
			var tfA2:TextField=new TextField(600, 150, A2, FontVo.PALACE_FONT, 28, 0xffffff, true);
			tfA2.x=220;
			tfA2.y=480;
			tfA2.hAlign="left";
			tfA2.vAlign="top";
			tfHolder.addChild(tfA2);

			isLoading=true;
		}

		protected function addNext():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (load)
				load.removeFromParent(true);
			if (skipIndex < 0)
			{
				var next:ElasticButton=new ElasticButton(getImage("nextButton"));
				addChild(next);
				next.x=1024 - 100;
				next.y=768 - 100;
				next.addEventListener(ElasticButton.CLICK, initScene);
			}
			else
			{
				sceneIndex=skipIndex;
				loadScene(sceneIndex);
			}
		}

		protected function initScene(e:Event):void
		{
			tfHolder.removeFromParent(true);
			var next:ElasticButton=e.currentTarget as ElasticButton;
			next.removeFromParent(true);
			sceneIndex=skipIndex < 0 ? 0 : skipIndex;
			loadScene(sceneIndex);
		}

		protected function addLoading():void
		{
			load=new Sprite();
			addChild(load);
			load.x=1024 - 100;
			load.y=768 - 100;
			load.scaleX=load.scaleY=.5;
			load.addChild(Image.fromBitmap(new loading()));
			load.pivotX=load.pivotY=64;

			isLoading=true;

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener("gotoNext", nextScene);
		}

		protected function getImage(name:String):Image
		{
			return new Image(assetManager.getTexture(name));
		}

		protected function onEnterFrame(e:Event):void
		{
			if (isLoading)
				load.rotation+=.2;
		}

		protected var sceneArr:Array=[];
		protected var sceneIndex:int;

		protected function nextScene(e:Event):void
		{
			sceneIndex++;
			loadScene(sceneIndex);
		}

		protected function loadScene(index:int):void
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

				crtScene=new scene(assetManager);
				addChild(crtScene);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				removeEventListener("gotoNext", nextScene);
				if (load)
					load.removeFromParent(true);
				MC.instance.nextModule();
			}
		}

		override public function dispose():void
		{
			if (assetManager)
				assetManager.purge();
			assetManager=null;
			super.dispose();
		}
	}
}

