/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package views.components.base
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.pamakids.palace.utils.StringUtils;

	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import feathers.core.PopUpManager;

	import models.AchieveVO;
	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
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
				var birdUrl:String="bird_collection_" + birdIndex;
				var t:Texture=assetManager.getTexture(birdUrl);
				trace(birdUrl,t)
				img =getImage(birdUrl);
				bbg = getImage("background_2");
				bbg.scaleX=bbg.scaleY=2;
//				LoadManager.instance.loadImage("assets/global/handbook/bird_collection_" + birdIndex + ".png",
//											   function(b:Bitmap):void {
//												   if (b)
//													   img=Image.fromBitmap(b);
//												   b=null;
//											   });
//
//				LoadManager.instance.loadImage("assets/global/handbook/mainUI/background_2.png",
//											   function(b:Bitmap):void {
//												   if (b)
//													   bg=Image.fromBitmap(b);
//												   b=null;
//											   });
				timer=new Timer(birdDelay,10);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
				addEventListener("pauseTimer",pauseTimer);
				addEventListener("resumeTimer",resumeTimer);

				timer.start();

//				TweenLite.delayedCall(10, function():void {
//					if (img && bg)
//					{
//						initBird(img, bg);
//						UserBehaviorAnalysis.trackEvent("collect", "bird", "", birdIndex);
//					}
//				});
			}
		}

		protected var birdDelay:Number=1000;
		protected var pause:Boolean=true;

		private function resumeTimer(e:Event):void
		{
			if(timer)
				timer.start();
		}

		private function pauseTimer(e:Event):void
		{
			if(timer)
				timer.stop();
		}

		protected function onComplete(event:TimerEvent):void
		{
			if (img && bbg)
			{
				initBird(img, bbg);
				UserBehaviorAnalysis.trackEvent("collect", "bird", "", birdIndex);
			}

			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
			timer=null;
		}

		private var timer:Timer;


		public function PalaceScene(am:AssetManager=null)
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			if (sceneName.indexOf("scene") == 0)
			{
				var str:String=sceneName.substr(5, 2);
				SOService.instance.setSO("lastScene", str);
			}
			Prompt.parent=this;
			assetManager=am;
			MC.instance.main.removeMask();
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

		private function initBird(img:Image, bg:Image):void
		{
			var bird:PalaceBird=new PalaceBird();
			bird.pause=pause;
			bird.crtIndex=birdIndex;
			bird.bg=bg;
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
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			TopBar.show();
			init();
		}

		override protected function init():void
		{
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(sceneName);
			SoundAssets.playBGM("main");
		}

		override public function dispose():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onComplete);
				timer=null;
			}
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, sceneName);
				initTime=-1;
			}
//			if (nextButton)
//			{
//				TweenLite.killDelayedCallsTo(this);
//				TweenMax.killTweensOf(nextButton);
//				nextButton.removeFromParent(true);
//				nextButton=null;
//			}
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

//		protected var nextButton:ElasticButton;

		private var tfSP:Sprite;

		private var tf:TextField;

		protected function sceneOver():void
		{
			trace("sceneover");
			dispatchEvent(new Event("sceneover",true));
			removeMask();
//			if (!nextButton)
//			{
//				nextButton=new ElasticButton(getImage("nextButton"));
//				addChild(nextButton);
//				nextButton.pivotX=nextButton.width >> 1;
//				nextButton.pivotY=33;
//				nextButton.x=1024 - 100;
//				nextButton.y=768 - 100;
//				nextButton.addEventListener(ElasticButton.CLICK, nextScene);
//				shakeNext();
//			}
//			else
//				nextButton.visible=true;
//			TailBar.hide();
		}

//		public function addLoading():void
//		{
//			if (nextButton)
//			{
//				var loading:MovieClip=new MovieClip(MC.assetManager.getTextures("loadingHalo"), 15);
//				Starling.juggler.add(loading);
//				loading.loop=true;
//				loading.play();
//				nextButton.addChild(loading);
//				loading.x=8;
//				loading.y=32;
//				loading.scaleY=.98
//			}
//		}

//		protected function hideNext():void
//		{
//			if (nextButton)
//				nextButton.visible=false;
//		}
//
//		private function shakeNext():void
//		{
//			if (nextButton)
//				TweenMax.to(nextButton, 1, {shake: {rotation: Math.PI / 12, numShakes: 4}, onComplete: function():void
//				{
//					TweenLite.delayedCall(5, shakeNext);
//				}});
//		}

//		protected function nextScene(e:Event=null):void
//		{
//			UserBehaviorAnalysis.trackEvent("click", "next");
//			TopBar.enable=false;
//			if (nextButton)
//				nextButton.touchable=false;
//			TweenLite.killTweensOf(shakeNext);
//			dispatchEvent(new Event("gotoNext", true));
//		}

		protected var bg:Image;

		private var img:Image;

		private var bbg:Image;

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
			dispatchEvent(new Event("pauseTimer",true));
			UserBehaviorAnalysis.trackEvent("collect", "achievement", "", _achieveIndex);
			SoundAssets.playSFX("getachieve");
			SOService.instance.setSO(_achieveIndex.toString() + "_achieve", true);

			isFirstAchieve=!SOService.instance.getSO('isFirstAchieve');
			SOService.instance.setSO('isFirstAchieve', true);

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
				addChildAt(tfSP, numChildren - 1);
			}

			if(isFirstAchieve)
			{
				TweenLite.to(tfSP, .5, {y: 0,onComplete:function():void{
					firstAchievementAction(function():void{
						resetTFSP(_callback);
					});
				}});
			}else{
				TweenLite.to(tfSP, .5, {y: 0});
				TweenLite.delayedCall(2.5, resetTFSP, [_callback]);
			}
		}

		private function resetTFSP(cb:Function):void
		{
			TweenLite.to(tfSP, .5, {y: -170, onComplete: function():void {
				removeMask();
				dispatchEvent(new Event("resumeTimer",true));
				if (cb != null)
					cb();
			}})
		}

		private function firstAchievementAction(cb:Function):void
		{
			msk2=new starling.display.Quad(1024,768,0);
			msk2.alpha=.6;
			addChild(msk2);
			firstCB=cb;
			TopBar.instance.visible=true;
			firstHint=getImage('firstAchieve');
			firstHint.x=79;
			firstHint.y=82;
			addChild(firstHint);
			stage.addEventListener(TouchEvent.TOUCH,onClearTouch);
		}

		private var firstCB:Function;
		private var firstHint:Image;
		private var msk2:starling.display.Quad;

		private function onClearTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage,TouchPhase.ENDED);
			if(tc)
			{
				removeEventListener(TouchEvent.TOUCH,onClearTouch);
				if(msk2)
					msk2.removeFromParent(true);
				msk2=null;
				if(firstHint)
					firstHint.removeFromParent(true);
				firstHint=null;
				if(firstCB!=null)
					firstCB();
				firstCB=null;
			}
		}

		private var isFirstAchieve:Boolean;

		protected function showCard(_cardName:String, callback:Function=null):void
		{
			if (SOService.instance.getSO("collection_card_" + _cardName + "collected"))
			{
				if (callback != null)
					callback();
				return;
			}
			dispatchEvent(new Event("pauseTimer",true));
			UserBehaviorAnalysis.trackEvent("collect", "card", "", int(_cardName));
			SoundAssets.playSFX("getcard");
			SOService.instance.setSO("collection_card_" + _cardName + "collected", true);

			var firstCard:Boolean=!SOService.instance.getSO('firstCard');
			SOService.instance.setSO('firstCard',true);

			var cardShow:Sprite=new Sprite();
			cardShow.x=512;
			cardShow.y=768 / 2;
			PopUpManager.addPopUp(cardShow, true, false);

			var haloSP:Sprite=new Sprite();

			cardShow.addChild(haloSP);
			haloSP.scaleX=1.25;
			haloSP.scaleY=.8;

			var halo:Image=getImage("halo")
			halo.pivotX=halo.width >> 1;
			halo.pivotY=halo.height >> 1;
			haloSP.addChild(halo);

			halo.rotation=0;

			function clearShow():void
			{
				halo.visible=false;
				TweenLite.delayedCall(.5, function():void
				{
					dispatchEvent(new Event("resumeTimer",true));
					PopUpManager.removePopUp(cardShow);
					cardShow.dispose()
				});
			}

			TweenLite.to(halo, 2.5, {rotation: Math.PI, ease: com.greensock.easing.Quad.easeOut,
							 onComplete: firstCard?addHint:clearShow});

			var card:CollectionCard=new CollectionCard(callback);
			card.addChild(getImage("collection_card_" + _cardName));
			card.pivotX=card.width >> 1;
			card.pivotY=card.height >> 1;
			card.show(!firstCard);
			cardShow.addChild(card);

			var hint:Image;
			function addHint():void
			{
				var rimg:Image=getImage("ribbon");
				cardShow.addChild(rimg);
				rimg.x=-45-512;
				rimg.y=38-768/2;
				rimg.addEventListener(TouchEvent.TOUCH,onImgTouch);

				hint=getImage("firstCard");
				cardShow.addChild(hint);
				hint.x=79-512;
				hint.y=82-768/2;
			}

			function onImgTouch(e:TouchEvent):void
			{
				var img:Image=e.currentTarget as Image;
				var tc:Touch=e.getTouch(img,TouchPhase.ENDED);
				if(tc)
				{
					img.removeFromParent(true);
					if(hint)
						hint.removeFromParent(true);
					card.hide();
					clearShow();
					TweenLite.delayedCall(.5,TopBar.instance.showBookAndAvatar);
				}
			}

		}
	}
}

