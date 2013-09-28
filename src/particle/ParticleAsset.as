package particle
{

	public class ParticleAsset
	{
		[Embed(source="/particle/particle.pex", mimeType="application/octet-stream")]
		public static var particleXML:Class;

		[Embed(source="/particle/texture.png")]
		public static var particleTextrue:Class;
	}
}

