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
	import com.pamakids.manager.LoadManager;
	import com.pamakids.palace.utils.StringUtils;

	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.getTimer;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import feathers.core.PopUpManager;

	import models.AchieveVO;
	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.CollectionCard;
	import views.components.Craw;
	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.PalaceBird;
	import views.components.Prompt;
	import views.global.TailBar;
	import views.global.TopBar;

	public class PalaceScene extends Container
	{
		protected var assetManager:AssetManager;

		public var crtKnowledgeIndex:int=-1;
		private var _birdIndex:int=-1;

		protected var initTime:int=-1;
		protected var disposeTime:int=-1;
		protected var taskInitTime:int=-1;
		protected var sceneOverTime:int=-1;

		public function get birdIndex():int
		{
			return _birdIndex;
		}

		public function set birdIndex(value:int):void
		{
			if (_birdIndex == value)
				return;
			_birdIndex=value;
			if (value < 0)
				return;
			if (!checkBird())
			{
				var img:Image;
				LoadManager.instance.loadImage("assets/global/handbook/bird_collection_" + birdIndex + ".png",
											   function(b:Bitmap):void {
												   if (b)
													   img=Image.fromBitmap(b);
												   b=null;
											   });

				TweenLite.delayedCall(10, function():void {
//					var cls:Class=BirdAssets["bird" + birdIndex];
//					if (!cls)
//						return;
					if (img)
					{
						initBird(img);
						UserBehaviorAnalysis.trackEvent("collect", "bird", "", birdIndex);
					}
				});
			}
		}


		public function PalaceScene(am:AssetManager=null)
		{
			super();
			if (sceneName.indexOf("scene") == 0)
			{
				var str:String=sceneName.substr(5, 2);
				SOService.instance.setSO("lastScene", str);
			}
			Prompt.parent=this;
			assetManager=am;
			MC.instance.main.removeMask();
			SoundAssets.playBGM("main");
		}

		private function checkBird():Boolean
		{
			var b:Boolean=SOService.instance.getSO("birdCatched" + birdIndex);
			return b;
		}

		protected function addBG(src:String):void
		{
			bg=getImage(src);
			addChild(bg);
		}

		private function initBird(img:Image):void
		{
			var bird:PalaceBird=new PalaceBird();
			bird.crtIndex=birdIndex;
			bird.img=img;
			var mc:MovieClip=new MovieClip(MC.assetManager.getTextures("bird"), 18);
//			mc.scaleX=mc.scaleY=.5;
			trace(mc.numFrames)
			bird.bird=mc;
			bird.close=new ElasticButton(getImage("button_close"), getImage("button_close_down"));
			bird.fly();
			addChild(bird);
		}

		protected function addCraw(pt:Point, clickFunc:Function=null, pr:Sprite=null, index:int=0):void
		{
			var craw:Craw=new Craw(getImage("craw"), getImage("craw-light"), pr ? pr : this);
			craw.pivotX=20;
			craw.pivotY=20;
			craw.x=pt.x + 20;
			craw.y=pt.y + 20;
			craw.index=index;
			if (clickFunc != null)
				craw.addEventListener(TouchEvent.TOUCH, clickFunc);
			else
				craw.touchable=false;
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.show();
		}

		override protected function init():void
		{
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(sceneName);
		}

		override public function dispose():void
		{
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, sceneName);
				initTime=-1;
			}
			if (nextButton)
			{
				TweenLite.killDelayedCallsTo(this);
				TweenMax.killTweensOf(nextButton);
				nextButton.removeFromParent(true);
				nextButton=null;
			}
			if (assetManager)
			{
				assetManager.purge();
				assetManager=null;
			}
			removeChildren();
			TopBar.hide();
			TailBar.hide();
			LionMC.instance.clear();
			super.dispose();
		}

		protected function getImage(name:String):Image
		{
			var t:Texture
			if (MC.assetManager)
				t=MC.assetManager.getTexture(name);
			if (!t && assetManager)
				t=assetManager.getTexture(name)
			if (t)
				return new Image(t);
			else
				return null;
		}

		protected var nextButton:ElasticButton;

		private var tfSP:Sprite;

		private var tf:TextField;

		protected function sceneOver():void
		{
			removeMask();
			if (!nextButton)
			{
				nextButton=new ElasticButton(getImage("nextButton"));
				addChild(nextButton);
				nextButton.pivotX=nextButton.width >> 1;
				nextButton.pivotY=33;
				nextButton.x=1024 - 100;
				nextButton.y=768 - 100;
				nextButton.addEventListener(ElasticButton.CLICK, nextScene);
				shakeNext();
			}
			else
				nextButton.visible=true;
			TailBar.hide();
//			addLoading();
		}

		public function addLoading():void
		{
			if (nextButton)
			{
				var loading:MovieClip=new MovieClip(MC.assetManager.getTextures("loadingHalo"), 15);
				Starling.juggler.add(loading);
				loading.loop=true;
				loading.play();
				nextButton.addChild(loading);
				loading.x=8;
				loading.y=32;
				loading.scaleY=.98
			}
		}

		protected function hideNext():void
		{
			if (nextButton)
				nextButton.visible=false;
		}

		private function shakeNext():void
		{
			if (nextButton)
				TweenMax.to(nextButton, 1, {shake: {rotation: Math.PI / 12, numShakes: 4}, onComplete: function():void
				{
					TweenLite.delayedCall(5, shakeNext);
				}});
		}

		protected function nextScene(e:Event=null):void
		{
			UserBehaviorAnalysis.trackEvent("click", "next");
			TopBar.enable=false;
			if (nextButton)
				nextButton.touchable=false;
			TweenLite.killTweensOf(shakeNext);
			dispatchEvent(new Event("gotoNext", true));
		}

		protected var bg:Image;

		public function get sceneName():String
		{
			return StringUtils.getClassName(this);
		}

		protected function showAchievement(_achieveIndex:int, _callback:Function=null):void
		{
			if (SOService.instance.getSO(_achieveIndex.toString() + "_achieve"))
			{
				if (_callback != null)
					_callback();
				return;
			}
			UserBehaviorAnalysis.trackEvent("collect", "achievement", "", _achieveIndex);
			SoundAssets.playSFX("getachieve");
			SOService.instance.setSO(_achieveIndex.toString() + "_achieve", true);
//			var txt:String="xxx";
			var txt:String="恭喜您获得成就: " + AchieveVO.achieveList[_achieveIndex][0];
			addMask(0);
			if (!tfSP)
			{
				tfSP=new Sprite();
				addChild(tfSP);
				tfSP.touchable=false;

				var bar:Image=getImage("acheivebar");
				bar.pivotX=bar.width >> 1;
				tfSP.addChild(bar);
				tf=new TextField(400, 80, txt, FontVo.PALACE_FONT, 32, 0xfbf4cb);
				tfSP.addChild(tf);
				tf.x=-200;
				tf.y=15;
				tfSP.x=512;
				tfSP.y=-170;
			}
			else
			{
				TweenLite.killTweensOf(resetTFSP, true);
				TweenLite.killTweensOf(tfSP);
				tf.text=txt;
				tfSP.y=-170;
				setChildIndex(tfSP, numChildren - 1);
			}
			TweenLite.to(tfSP, .5, {y: 0});
			TweenLite.delayedCall(2.5, resetTFSP, [_callback]);
		}

		private function resetTFSP(cb:Function):void
		{
			TweenLite.to(tfSP, .5, {y: -170, onComplete: function():void {
				removeMask();
				if (cb != null)
					cb();
			}})
		}

		protected function showCard(_cardName:String, callback:Function=null):void
		{
			if (SOService.instance.getSO("collection_card_" + _cardName + "collected"))
			{
				if (callback != null)
					callback();
				return;
			}
			UserBehaviorAnalysis.trackEvent("collect", "card", "", int(_cardName));
			SoundAssets.playSFX("getcard");
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
				TweenLite.delayedCall(.5, function():void
				{
					PopUpManager.removePopUp(cardShow);
					cardShow.dispose()
				});
			}});

			var card:CollectionCard=new CollectionCard(callback);
			card.addChild(getImage("collection_card_" + _cardName));
			card.pivotX=card.width >> 1;
			card.pivotY=card.height >> 1;
			card.show();
			cardShow.addChild(card);

		}
	}
}

