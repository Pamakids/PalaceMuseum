package
{
	public class ParticleAsset
	{
		[Embed(source="/assets/particle.pex", mimeType="application/octet-stream")]
		public static var particleXML:Class;

		[Embed(source="/assets/texture.png")]
		public static var particleTextrue:Class;
	}
}

