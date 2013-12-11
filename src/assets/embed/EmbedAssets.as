package assets.embed
{

	public class EmbedAssets
	{
		public function EmbedAssets()
		{
		}

		[Embed(source="loading1.png")]
		public static var module1Loading:Class;

		[Embed(source="loading2.png")]
		public static var module2Loading:Class;

		[Embed(source="messageBG.png")]
		public static var messageBG:Class;
	}
}
