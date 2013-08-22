package
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class Particle extends Sprite
	{

		private var particleSystem:PDParticleSystem;
		public function Particle()
		{
			var config:XML = XML(new ParticleAsset.particleXML());
			var texture:Texture = Texture.fromBitmap(new ParticleAsset.particleTextrue());

			particleSystem = new PDParticleSystem(config, texture);
			particleSystem.start();

			addChild(particleSystem);
			particleSystem.scaleX=particleSystem.scaleY=.5;
			Starling.juggler.add(particleSystem);
		}

		override public function dispose():void{
			super.dispose();
			if(particleSystem){
				particleSystem.stop(true);
				removeChild(particleSystem);
				Starling.juggler.remove(particleSystem);
				particleSystem=null;
			}
		}
	}
}

