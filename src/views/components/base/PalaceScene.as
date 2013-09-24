/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package views.components.base
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import feathers.core.PopUpManager;

	import models.FontVo;
	import models.SOService;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
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

			if (nextButton)
			{
				TweenLite.killDelayedCallsTo(this);
				TweenMax.killTweensOf(nextButton);
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

		private var tfSP:Sprite;

		private var tf:TextField;

		protected function sceneOver():void
		{
			if (!nextButton)
			{
				nextButton=new ElasticButton(getImage("nextButton"));
				addChild(nextButton);
				nextButton.x=1024 - 100;
				nextButton.y=768 - 100;
				nextButton.addEventListener(ElasticButton.CLICK, nextScene);
				shakeNext();
			}
		}

		private function shakeNext():void
		{
			TweenMax.to(nextButton, 1, {shake: {x: 5, numShakes: 4}, onComplete: function():void
			{
				setChildIndex(nextButton, numChildren - 1);
				TweenLite.delayedCall(5, shakeNext);
			}});
		}

		protected function nextScene(e:Event=null):void
		{
			nextButton.removeEventListener(ElasticButton.CLICK, nextScene);
			dispatchEvent(new Event("gotoNext", true));
		}

		private var delayIndex:int;

		protected function showAchievement(_achieveIndex:int):void
		{
			if (SOService.instance.getSO(_achieveIndex.toString() + "_achieve"))
				return;
			SOService.instance.setSO(_achieveIndex.toString() + "_achieve", true);
			var txt:String="xxx";
//			txt="恭喜您获得成就: " + AchieveVO.achieveList[_achieveIndex][0];
			if (!tfSP)
			{
				tfSP=new Sprite();
				addChild(tfSP);
				tfSP.touchable=false;
				var quad:Quad=new Quad(400, 80, 0);
				quad.alpha=.5;
				tfSP.addChild(quad);
				tf=new TextField(400, 80, txt, FontVo.PALACE_FONT, 28, 0xffffff);
				tfSP.addChild(tf);
				tfSP.x=512 - 200;
				tfSP.y=-80;
			}
			else
			{
				if (delayIndex)
					clearTimeout(delayIndex);
				TweenLite.killTweensOf(tfSP);
				tf.text=txt
				tfSP.y=-80;
			}
			TweenLite.to(tfSP, .5, {y: 0});
			delayIndex=setTimeout(function():void {
				TweenLite.to(tfSP, .5, {y: -80})}, 2500);
		}

		protected function showCard(_cardName:String):void
		{
			if (SOService.instance.getSO("collection_card_" + _cardName))
				return;
			SOService.instance.setSO("collection_card_" + _cardName + "collected", true);

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
			card.addChild(getImage(_cardName + "collectCard"));
			card.pivotX=card.width >> 1;
			card.pivotY=card.height >> 1;
			card.show();
			cardShow.addChild(card);

		}
	}
}

