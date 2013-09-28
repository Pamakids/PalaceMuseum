package particle
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class SmokeParticle extends Sprite
	{

		private var particleSystem:PDParticleSystem;

		public function SmokeParticle()
		{
			var config:XML=XML(new ParticleAsset.particleXML());
			var texture:Texture=Texture.fromBitmap(new ParticleAsset.particleTextrue());

			particleSystem=new PDParticleSystem(config, texture);
			particleSystem.start();

			addChild(particleSystem);
			Starling.juggler.add(particleSystem);
		}

		override public function dispose():void
		{
			super.dispose();
			if (particleSystem)
			{
				particleSystem.stop(true);
				removeChild(particleSystem);
				Starling.juggler.remove(particleSystem);
				particleSystem=null;
			}
		}
	}
}

