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
		
		public static function init():void
		{
			SoundManager.instance.addSound('main', main, 999, .5);
			SoundManager.instance.addSound('camera', camera);
		}
	}
}
