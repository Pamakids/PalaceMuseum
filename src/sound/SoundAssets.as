package sound
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;

	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	import controllers.SoundManager;

	import models.SOService;

	public class SoundAssets
	{
		public function SoundAssets()
		{
		}

		public static var initArr:Array=["main", "camera", "bingo", "sad", "buttonclick", "centerflip", "gamerecord", "lionshow",
										 "getachieve", "getcard", "mapbgm", "dang", "gameBGM", "gameWin", "gameLose",
										 "kinghappy", "kinglook", "kingnaughty", "popup", "starsound"];
		[Embed(source="/sound/main.mp3")] //done
		public static var main:Class;
		[Embed(source="/sound/camera.mp3")] //done
		public static var camera:Class;
		[Embed(source="/sound/bingosound.mp3")] //done
		public static var bingo:Class;
		[Embed(source="/sound/kingsad.mp3")] //done
		public static var sad:Class;
		[Embed(source="/sound/buttonclick.mp3")] //done
		public static var buttonclick:Class;
		[Embed(source="/sound/centerflip.mp3")] //done
		public static var centerflip:Class;
		[Embed(source="/sound/gamerecord.mp3")] //done
		public static var gamerecord:Class;
		[Embed(source="/sound/lionshow.mp3")] //done
		public static var lionshow:Class;
		[Embed(source="/sound/getachieve.mp3")] //done
		public static var getachieve:Class;
		[Embed(source="/sound/getcard.mp3")] //done
		public static var getcard:Class;
		[Embed(source="/sound/mapbgm.mp3")] //done
		public static var mapbgm:Class;
		[Embed(source="/sound/gameBGM.mp3")] //done
		public static var gameBGM:Class;
		[Embed(source="/sound/dang.mp3")] //done
		public static var dang:Class;
		[Embed(source="/sound/kinghappy.mp3")] //done
		public static var kinghappy:Class;
		[Embed(source="/sound/kinglook.mp3")] //done
		public static var kinglook:Class;
		[Embed(source="/sound/kingnaughty.mp3")] //done
		public static var kingnaughty:Class;
		[Embed(source="/sound/popup.mp3")] //done
		public static var popup:Class;
		[Embed(source="/sound/starsound.mp3")] //done
		public static var starsound:Class;
		[Embed(source="/sound/gameWin.mp3")] //done
		public static var gameWin:Class;
		[Embed(source="/sound/gameLose.mp3")] //done
		public static var gameLose:Class;

		public static var module1:Array=["lighton", "opendoor", "step", "dresson", "switching", "clockmatch", "clockroll",
										 "windowwrong", "boxopen", "boxscale", "twistermatch", "twisting", "s11bgm", "blockmatch"];
		[Embed(source="/sound/11lighton.mp3")] //done
		public static var lighton:Class;
		[Embed(source="/sound/11opendoor.mp3")] //done
		public static var opendoor:Class;
		[Embed(source="/sound/11step.mp3")] //done
		public static var step:Class;
		[Embed(source="/sound/12dresson.mp3")] //---------
		public static var dresson:Class;
		[Embed(source="/sound/12switch.mp3")] //done
		public static var switching:Class;
		[Embed(source="/sound/13clockmatch.mp3")] //done
		public static var clockmatch:Class;
		[Embed(source="/sound/13clockroll.mp3")] //done
		public static var clockroll:Class;
		[Embed(source="/sound/11windowwrong.mp3")] //done
		public static var windowwrong:Class;
		[Embed(source="/sound/12boxopen.mp3")] //done
		public static var boxopen:Class;
		[Embed(source="/sound/12boxscale.mp3")] //done
		public static var boxscale:Class;
		[Embed(source="/sound/13twistermatch.mp3")] //done
		public static var twistermatch:Class;
		[Embed(source="/sound/13twisting.mp3")] //done
		public static var twisting:Class;
		[Embed(source="/sound/s11bgm.mp3")] //done
		public static var s11bgm:Class;

		public static var module2:Array=['bug', 'drum', 'shelfin', 'shelfout',
										 "flute", "scrollout", "dragonlighton", "ringblock", "ringrolling", "telescale", "blockmatch"];
		[Embed(source="/sound/21bug.mp3")] //done
		public static var bug:Class;
		[Embed(source="/sound/21drum.mp3")] //done
		public static var drum:Class;
		[Embed(source="/sound/21shelfin.mp3")] //done
		public static var shelfin:Class;
		[Embed(source="/sound/21shelfout.mp3")] //done
		public static var shelfout:Class;
		[Embed(source="/sound/21flute.mp3")] //done
		public static var flute:Class;
		[Embed(source="/sound/21scrollout.mp3")] //done
		public static var scrollout:Class;
		[Embed(source="/sound/22dragonlighton.mp3")] //done
		public static var dragonlighton:Class;
		[Embed(source="/sound/22ringblock.mp3")] //done
		public static var ringblock:Class;
		[Embed(source="/sound/22ringrolling.mp3")] //done
		public static var ringrolling:Class;
		[Embed(source="/sound/22telescale.mp3")] //done
		public static var telescale:Class;

		public static var module3:Array=['dishout', 'fly', 'kingeat', 'kingpoison',
										 "kingdragged", "blockfall", "blockhit", "blockmatch", "dishon"];
		[Embed(source="/sound/33dishout.mp3")] //done
		public static var dishout:Class;
		[Embed(source="/sound/33fly.mp3")] //done
		public static var fly:Class;
		[Embed(source="/sound/33kingeat.mp3")] //done
		public static var kingeat:Class;
		[Embed(source="/sound/33kingpoison.mp3")] //done
		public static var kingpoison:Class;
		[Embed(source="/sound/31kingdragged.mp3")] //done
		public static var kingdragged:Class;
		[Embed(source="/sound/32blockfall.mp3")] //
		public static var blockfall:Class;
		[Embed(source="/sound/32blockhit.mp3")] //
		public static var blockhit:Class;
		[Embed(source="/sound/32blockmatch.mp3")] //done
		public static var blockmatch:Class;
		[Embed(source="/sound/33dishon.mp3")] //done
		public static var dishon:Class;

		public static var module4:Array=["s41bgm", "gamebg52"];
		[Embed(source="/sound/s41bgm.mp3")] //done
		public static var s41bgm:Class;

		public static var module5:Array=['kingdragged','cough', 'sigh', 'gamebg52', 'fire', "bodyfall", "maskok", "maskwrong", "taihou"];
		[Embed(source="/sound/51cough.mp3")] //done
		public static var cough:Class;
		[Embed(source="/sound/51sigh.mp3")] //done
		public static var sigh:Class;
		[Embed(source="/sound/52gamebg.mp3")] //done
		public static var gamebg52:Class;
		[Embed(source="/sound/52fire.mp3")] //done
		public static var fire:Class;
		[Embed(source="/sound/52bodyfall.mp3")] //done
		public static var bodyfall:Class;
		[Embed(source="/sound/52maskok.mp3")] //done
		public static var maskok:Class;
		[Embed(source="/sound/52maskwrong.mp3")] //done
		public static var maskwrong:Class;
		[Embed(source="/sound/51taihou.mp3")] //done
		public static var taihou:Class;

		public static var gamescene:Array=['dishon', 'dishout', 'fly', 'kingeat', 'kingpoison',
										   'blockfall', 'blockmatch',
										   'gamebg52', 'bodyfall', 'maskok', 'maskwrong'];
		public static var loopArr:Array=["main", "gamebg52", "mapbgm", "s11bgm", "s41bgm", "fireworks", "gameBGM"];

		public static function init():void
		{
			sm=SoundManager.instance;
			addModuleSnd("initArr");
		}

		public static function initVol():void
		{
			var sv:Object=SOService.instance.getSO(SFX)
			if (sv != null)
				sfxVol=sv as Number
			else
				sfxVol=1;

			var bv:Object=SOService.instance.getSO(BGM)
			if (bv != null)
				bgmVol=bv as Number
			else
				bgmVol=.6;
//			bgmVol=.5;
		}

		public static var sm:SoundManager;

		public static function addModuleSnd(_name:String):void
		{
			var arr:Array=SoundAssets[_name];
			if (arr)
				for each (var str:String in arr)
				{
					if (loopArr.indexOf(str) >= 0)
						sm.addSound(str, SoundAssets[str], 999);
					else
						sm.addSound(str, SoundAssets[str]);
				}
		}

		public static function removeModuleSnd(_name:String):void
		{
			var arr:Array=SoundAssets[_name];
			if (arr)
				for each (var str:String in arr)
				{
					sm.clear(str);
				}
		}

		public static function playBGM(_name:String):void
		{
			if (crtBGM == _name)
				return;
			if (crtBGM)
				fadeOut(crtBGM);
			crtBGM=_name;
			fadeIn(crtBGM);
		}

		private static var scDic:Dictionary=new Dictionary();
		private static const FADEINOUTDELAY:Number=2;

		public static function fadeOut(sound:String):void
		{
			var sc:SoundChannel=scDic[sound];
			if (sc)
			{
				trace("fadeOut", sound)
				if(needFade){
					TweenLite.killTweensOf(sc);
					TweenMax.to(sc, FADEINOUTDELAY, {volume: 0, onComplete: function():void {
						sm.stop(sound);
						delete scDic[sound];
					}});
				}else{
					sm.stop(sound);
					delete scDic[sound];
				}
			}
		}

		public static var needFade:Boolean=false;

		public static function fadeIn(sound:String):void
		{
			var sc:SoundChannel=scDic[sound];
			if (!sc)
				sc=sm.play(sound, 0, 0);
			if (sc)
			{
				trace("fadeIn", sound)
				scDic[sound]=sc;
				if(needFade){
					TweenLite.killTweensOf(sc);
					TweenMax.to(sc, FADEINOUTDELAY, {volume: bgmVol});
				}else{
					sc.soundTransform=new SoundTransform(bgmVol);
				}
			}
		}

		public static function stopBGM(force:Boolean=false):void
		{
			if (crtBGM)
			{
				if (force)
					sm.stop(crtBGM);
				else
					fadeOut(crtBGM)
			}
			crtBGM="";
		}

		public static function playSFX(_name:String, forceStop:Boolean=false, forceVol:Number=0):void
		{
			if (forceStop)
				sm.stop(_name);
			sm.play(_name, 0, forceVol == 0 ? sfxVol : forceVol);
		}

		public static function stopSFX(_name:String):void
		{
			sm.stop(_name);
		}

		public static var crtBGM:String;

		private static var _bgmVol:Number;

		public static function get bgmVol():Number
		{
			return _bgmVol;
		}

		public static function set bgmVol(value:Number):void
		{
			if (_bgmVol == value)
				return;
			_bgmVol=value;
			SOService.instance.setSO(BGM, value);
			if (crtBGM)
			{
				var sc:SoundChannel=scDic[crtBGM];
				if (sc)
					sc.soundTransform=new SoundTransform(bgmVol);
				else
					scDic[crtBGM]=sm.play(crtBGM, 0, bgmVol);
			}
		}

		private static var _sfxVol:Number;

		public static function get sfxVol():Number
		{
			return _sfxVol;
		}

		public static function set sfxVol(value:Number):void
		{
			if (_sfxVol == value)
				return;
			_sfxVol=value;
			SOService.instance.setSO(SFX, value);
		}

		public static const SFX:String="SFXVOL";
		public static const BGM:String="BGMVOL";
	}
}


