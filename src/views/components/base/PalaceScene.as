/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package views.components.base
{
	import com.greensock.TweenLite;

	import feathers.core.PopUpManager;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.CollectionCard;
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
//				assets.dispose();
//				Prompt.removeAssetManager(assets);
			}
			removeChildren();
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

		protected function showCard(_cardName:String):void
		{
			if (SOService.instance.getSO(_cardName + "collected"))
				return;
			SOService.instance.setSO(_cardName + "collected", true);

			var cardShow:Sprite=new Sprite();
			cardShow.x=512;
			cardShow.y=768 / 2;
			PopUpManager.addPopUp(cardShow, true, false);

			var halo:Image=getImage("halo")
			cardShow.addChild(halo);
			halo.pivotX=halo.width >> 1;
			halo.pivotY=halo.height >> 1;

			halo.scaleX=halo.scaleY=.5;
			halo.rotation=0;
			TweenLite.to(halo, 2.5, {scaleX: 1, scaleY: 1, rotation: Math.PI, onComplete: function():void
			{
				halo.visible=false;
				TweenLite.delayedCall(.5, function():void {
					PopUpManager.removePopUp(cardShow);
					cardShow.dispose()
				});
			}});

			var card:CollectionCard=new CollectionCard();
			card.addChild(getImage(_cardName));
			card.pivotX=card.width >> 1;
			card.pivotY=card.height >> 1;
			card.show();
			cardShow.addChild(card);

		}
	}
}

