package sound
{
	import com.pamakids.manager.SoundManager;

	public class SoundAssets
	{
		public function SoundAssets()
		{
		}

		public static var initArr:Array=["main", "camera", "happy", "sad", "buttonclick", "centerflip", "gamerecord", "lionshow"];
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
		[Embed(source="/sound/centerflip.mp3")]
		public static var centerflip:Class;
		[Embed(source="/sound/gamerecord.mp3")] //done
		public static var gamerecord:Class;
		[Embed(source="/sound/lionshow.mp3")] //done
		public static var lionshow:Class;

		public static var module1:Array=["lighton", "opendoor", "step", "dresson", "switching", "clockmatch", "clockroll"];
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

		public static var module2:Array=['bug', 'drum', 'shelfin', 'shelfout'];
		[Embed(source="/sound/21bug.mp3")] //done
		public static var bug:Class;
		[Embed(source="/sound/21drum.mp3")] //done
		public static var drum:Class;
		[Embed(source="/sound/21shelfin.mp3")] //done
		public static var shelfin:Class;
		[Embed(source="/sound/21shelfout.mp3")] //done
		public static var shelfout:Class;

		public static var module3:Array=['dishout', 'fly', 'kingeat', 'kingpoison'];
		[Embed(source="/sound/33dishout.mp3")] //done
		public static var dishout:Class;
		[Embed(source="/sound/33fly.mp3")] //done
		public static var fly:Class;
		[Embed(source="/sound/33kingeat.mp3")] //done
		public static var kingeat:Class;
		[Embed(source="/sound/33kingpoison.mp3")] //done
		public static var kingpoison:Class;

		public static var module4:Array=[];

		public static var module5:Array=['cough', 'sigh', 'gamebg52', 'fire'];
		[Embed(source="/sound/51cough.mp3")] //done
		public static var cough:Class;
		[Embed(source="/sound/51sigh.mp3")] //done
		public static var sigh:Class;
		[Embed(source="/sound/52gamebg.mp3")] //done
		public static var gamebg52:Class;
		[Embed(source="/sound/52fire.mp3")] //done
		public static var fire:Class;

		public static var gamescene:Array=['dishout', 'fly', 'kingeat', 'kingpoison', 'gamebg52'];
		public static var loopArr:Array=["main", "gamebg52"];

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
