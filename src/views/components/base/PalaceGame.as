package views.components.base
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Quad;
	import com.pamakids.palace.utils.StringUtils;

	import flash.utils.getTimer;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.SOService;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;

	/**
	 *
	 * @author Administrator
	 */
	public class PalaceGame extends Container
	{

		protected var initTime:int=-1;
		protected var disposeTime:int=-1;

		/**
		 *
		 * @default
		 */
		public static const GAME_OVER:String="gameOver";
		/**
		 *
		 * @default
		 */
		public static const GAME_RESTART:String="gameRestart";

		/**
		 *
		 * @default
		 */
		protected var assetManager:AssetManager;
		/**
		 *
		 * @default
		 */
		public var fromCenter:Boolean=false;
		private var _isWin:Boolean;

		/**
		 *
		 * @return
		 */
		public function get isWin():Boolean
		{
			return _isWin;
		}

		/**
		 *
		 * @param value
		 */
		public function set isWin(value:Boolean):void
		{
			if (_isWin == value)
				return;
			_isWin=value;
			if (value)
				end();
		}


		/**
		 *
		 * @return
		 */
		public function get gameName():String
		{
			return StringUtils.getClassName(this);
		}

		/**
		 *
		 * @param am
		 */
		public function PalaceGame(am:AssetManager=null)
		{
			SOService.instance.setSO(gameName, true);
			assetManager=am;
			super();
		}

		/**
		 *
		 */
		protected function addBG():void
		{
			bg=Image.fromBitmap(new PalaceModule.gameBG());
			addChild(bg);
		}

		/**
		 *
		 * @return
		 */
		public function get gameResult():String
		{
			return gameName + "gameresult";
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			MC.instance.topBarLayer.visible=false;
			MC.instance.hideMC();
		}

		protected var lastBGM:String;

		override protected function init():void
		{
			if (bigGame)
			{
				lastBGM=SoundAssets.crtBGM
				SoundAssets.playBGM("gameBGM");
			}
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(gameName);

			dispatchEvent(new Event("pauseTimer",true));
			dispatchEvent(new Event("hideNext",true));
		}

		/**
		 *
		 * @default
		 */
		protected var closeBtn:ElasticButton;

		/**
		 *
		 * @default
		 */
		protected var bg:Image;

		/**
		 *
		 * @param _x
		 * @param _y
		 */
		protected function addClose(_x:Number=950, _y:Number=60):void
		{
			closeBtn=new ElasticButton(getImage("button_close"));
			closeBtn.shadow=getImage("button_close_down");
			closeBtn.x=_x;
			closeBtn.y=_y;
			addChild(closeBtn);
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseClick);
		}

		/**
		 *
		 * @param e
		 */
		protected function onCloseClick(e:Event):void
		{
			UserBehaviorAnalysis.trackEvent("click", "close");
			dispatchEvent(new Event(PalaceGame.GAME_OVER));
		}

		protected var bigGame:Boolean;

		/**
		 *
		 */
		protected function end():void
		{
			if (closeBtn)
				closeBtn.changeSkin(getImage("button_next"), getImage("button_next_down"));
		}

		override public function dispose():void
		{
			dispatchEvent(new Event("resumeTimer",true));
			resumeBGM();
			if (lastBGM && bigGame)
				SoundAssets.playBGM(lastBGM);
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, gameName);
				initTime=-1;
			}
			if (fromCenter)
				assetManager.dispose()
			else
			{
				assetManager=null;
				MC.instance.topBarLayer.visible=true;
				MC.instance.showMC();
			}
			super.dispose();

			dispatchEvent(new Event("showNext",true));
		}

		protected function lowerBGM():void
		{
			lastBGMVol=SoundAssets.bgmVol;
			var vol:Number=lastBGMVol * .2;
			if (vol)
				SoundAssets.bgmVol=vol;
		}

		protected function resumeBGM():void
		{
			if (lastBGMVol)
				SoundAssets.bgmVol=lastBGMVol;
			lastBGMVol=0;
		}

		private var lastBGMVol:Number;

		/**
		 *
		 * @param name
		 * @return
		 */
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

		/**
		 *
		 * @param type -1:失败, 0: 时间, 1:得分
		 * @param result 结果
		 * @param gamelevel 游戏难度 -1:无难度
		 * @param numStars 星星个数
		 */
		protected function showResult(type:int=-1, result:Number=0, record:Number=0, gamelevel:int=-1, numStars:int=0, pr:Sprite=null):void
		{
			pr=pr ? pr : this;
			if (type < 0)
				initLosePanel(pr);
			else
				initWinPanel(type, result, record, gamelevel, numStars, pr);
			initRsBtn(type >= 0, pr);
		}

		private function initLosePanel(pr:Sprite):void
		{
			var panel:Image=getImage("lose-panel");
			panel.x=1024 - panel.width >> 1;
			panel.y=768 - panel.height >> 1;
			pr.addChild(panel);
		}

		/**
		 *
		 * @param type 0: 时间, 1:得分
		 * @param result 结果
		 * @param gamelevel 游戏难度 -1:无难度
		 */
		private function initWinPanel(type:int=0, result:Number=0, record:Number=0, gamelevel:int=-1, numStars:int=0, pr:Sprite=null):void
		{
			var panel:Image=getImage("win-panel");
			addChild(panel);

			addStars(gamelevel == 1 ? numStars : -1, pr, 0);

			var txt1:String=type == 0 ? "时间" : "得分";
			var txt2:String=type == 0 ? "最快" : "最高";
			var resultTxt:String=type == 0 ? getStringFormTime(result) : result.toString();
			var recordTxt:String=type == 0 ? getStringFormTime(record) : record.toString();
		}

		protected function addStars(num:int, pr:Sprite, _y:Number=214):void
		{
			if (num <= 0)
				return;

			var ns:int=SOService.instance.getSO(gameName + "NumStars") as int;
			if (!ns || ns < num)
				SOService.instance.setSO(gameName + "NumStars", num);

			for (var i:int=0; i < num; i++)
			{
				var starR:Image=getImage("star-red")
				pr.addChild(starR);
				starEff(starR, i, _y);
			}

			for (var j:int=num; j < 3; j++)
			{
				var starG:Image=getImage("star-grey")
				pr.addChild(starG);
				starEff(starG, j, _y);
			}
		}

		private function starEff(star:Image, index:int, _y:Number):void
		{
			star.x=412 + 38 + index * 76;
			star.y=_y + 36;
			star.pivotX=star.width >> 1;
			star.pivotY=star.height >> 1;
			star.scaleX=star.scaleY=.1;
			star.visible=false;
			TweenLite.delayedCall(index * .3 + .3, function():void {
				star.visible=true;
				TweenLite.to(star, .5, {scaleX: 1, scaleY: 1, ease: Back.easeOut});
			});
		}

		private function initRsBtn(win:Boolean, pr:Sprite):void
		{
			var rsBtn:ElasticButton=new ElasticButton(getImage("restart"), getImage("restart-light"));
			pr.addChild(rsBtn);
//			rsBtn.x=win?
			rsBtn.addEventListener(ElasticButton.CLICK, onRestartClick);
		}

		/**
		 *
		 * @param e
		 */
		protected function onRestartClick(e:Event):void
		{

		}

		/**
		 *
		 * @param _count
		 * @return
		 */
		public function getStringFormTime(_count:int):String
		{
			var sectime:int=_count / 30;

			var mm:int=(_count % 30);
			var min:int=sectime % 3600 / 60;
			var sec:int=sectime % 60;
			var hour:int=sectime / 3600;

			var mmStr:String=mm.toString();
			var minStr:String=min.toString();
			var secStr:String=sec.toString();
			var hourStr:String=hour.toString();

			if (mm < 10)
				mmStr="0" + mmStr;
			if (min < 10)
				minStr="0" + minStr;
			if (sec < 10)
				secStr="0" + secStr;

			var txt:String=hour == 0 ? (minStr + ":" + secStr) : "59:59";
			txt+=":" + mmStr;
			return txt;
		}

		private function showRecord(cb:Function=null):void
		{
			var recordIcon:Image=getImage("record");
			addChild(recordIcon);
			recordIcon.x=536;
			recordIcon.y=282;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut, onComplete: cb});
		}
	}
}


