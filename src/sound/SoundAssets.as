package sound
{

	public class SoundAssets
	{
		public function SoundAssets()
		{
		}

		[Embed(source="/sound/main.mp3")]
		public static var main:Class;

		[Embed(source="/sound/camera.mp3")]
		public static var camera:Class;
	}
}
