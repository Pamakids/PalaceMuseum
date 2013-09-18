/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package views.components.base
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.Prompt;
	import views.global.TopBar;

	public class PalaceScene extends Container
	{
		protected var assets:AssetManager;
		public var crtKnowledgeIndex:int=-1;

		public function PalaceScene(am:AssetManager=null)
		{
			Prompt.parent=this;
			Prompt.addAssetManager(am);
			this.assets=am;
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.show();
		}

		override protected function init():void
		{
		}

		override public function dispose():void
		{
			if (assets)
			{
				removeChildren();
				assets.dispose();
				Prompt.removeAssetManager(assets);
			}
			super.dispose();
			TopBar.hide();
		}

		protected function getImage(name:String):Image
		{
			if (assets)
			{
				var t:Texture=assets.getTexture(name);
				if (t)
					return new Image(t);
				else
					return null;
			}
			return null;
		}

		protected var nextButton:ElasticButton;

		protected function sceneOver():void
		{
			if (!nextButton)
			{
				nextButton=new ElasticButton(getImage("nextButton"));
				addChild(nextButton);
				nextButton.x=1024 - 100;
				nextButton.y=768 - 100;
				nextButton.addEventListener(ElasticButton.CLICK, nextScene);
			}
		}

		protected function nextScene(e:Event=null):void
		{
			nextButton.removeEventListener(ElasticButton.CLICK, nextScene);
			dispatchEvent(new Event("gotoNext", true));
		}
	}
}

