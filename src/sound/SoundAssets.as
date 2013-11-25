package sound
{
	import com.pamakids.manager.SoundManager;

	public class SoundAssets
	{
		public function SoundAssets()
		{
		}

		public static var initArr:Array=["main", "camera", "happy", "sad", "buttonclick", "centerflip", "gamerecord", "lionshow",
										 "getachieve", "getcard", "mapbgm"];
		[Embed(source="/sound/main.mp3")] //done
		public static var main:Class;
		[Embed(source="/sound/camera.mp3")] //done
		public static var camera:Class;
		[Embed(source="/sound/kinghappy.mp3")] //done
		public static var happy:Class;
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

		public static var module1:Array=["lighton", "opendoor", "step", "dresson", "switching", "clockmatch", "clockroll",
										 "windowwrong", "boxopen", "boxscale", "twistermatch", "twisting", "s11bgm"];
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
										 "flute", "scrollout", "dragonlighton", "ringblock", "ringrolling", "telescale"];
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

		public static var module4:Array=["s41bgm"];
		[Embed(source="/sound/s41bgm.mp3")] //done
		public static var s41bgm:Class;

		public static var module5:Array=['cough', 'sigh', 'gamebg52', 'fire', "bodyfall", "maskok", "maskwrong"];
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

		public static var gamescene:Array=['dishon', 'dishout', 'fly', 'kingeat', 'kingpoison',
										   'blockfall', 'blockmatch',
										   'gamebg52', 'bodyfall', 'maskok', 'maskwrong'];
		public static var loopArr:Array=["main", "gamebg52", "mapbgm", "s11bgm", "s41bgm"];

		public static function init():void
		{
			addModuleSnd("initArr");
		}

		public static function addModuleSnd(_name:String):void
		{
			var arr:Array=SoundAssets[_name];
			if (arr)
				for each (var str:String in arr)
				{
					if (loopArr.indexOf(str) >= 0)
						SoundManager.instance.addSound(str, SoundAssets[str], 999, .3);
					else
						SoundManager.instance.addSound(str, SoundAssets[str]);
				}
		}

		public static function removeModuleSnd(_name:String):void
		{
			var arr:Array=SoundAssets[_name];
			if (arr)
				for each (var str:String in arr)
				{
					SoundManager.instance.clear(str);
				}
		}
	}
}
