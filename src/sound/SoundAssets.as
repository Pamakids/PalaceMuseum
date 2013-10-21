package sound
{
	import com.pamakids.manager.SoundManager;

	public class SoundAssets
	{
		public function SoundAssets()
		{
		}
		
		[Embed(source="/sound/main.mp3")]
		public static var main:Class;
		
		[Embed(source="/sound/camera.mp3")]
		public static var camera:Class;
		
		[Embed(source="/sound/fire.mp3")]
		public static var fire:Class;
		
		[Embed(source="/sound/happy.mp3")]
		public static var happy:Class;
		
		[Embed(source="/sound/lighton.mp3")]
		public static var lighton:Class;
		
		[Embed(source="/sound/opendoor.mp3")]
		public static var opendoor:Class;
		
		[Embed(source="/sound/sad.mp3")]
		public static var sad:Class;
		
		public static function init():void
		{
			SoundManager.instance.addSound('main', main, 999, .5);
			SoundManager.instance.addSound('camera', camera);
			SoundManager.instance.addSound('fire', fire);
			SoundManager.instance.addSound('happy', happy);
			SoundManager.instance.addSound('lighton', lighton);
			SoundManager.instance.addSound('opendoor', opendoor);
			SoundManager.instance.addSound('sad', sad);
		}
	}
}
