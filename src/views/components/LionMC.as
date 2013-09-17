package views.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import controllers.MC;

	public class LionMC extends Sprite
	{
		public function LionMC()
		{
			var mc:MovieClip=new MovieClip();
			addChild(mc);
			mcWidth=mc.width;
		}

		private static var _instance:LionMC;

		public static function get instance():LionMC
		{
			if (!_instance)
				_instance=new LionMC();
			return _instance;
		}

		private var p:Prompt;
		private var mcWidth:Number;

		public function say(content:String, fontSize:int=20, callBack:Function=null):void
		{
			p=Prompt.showTXT(this.x + this.mcWidth, this.y, content, fontSize, callBack, MC.instance.main);
		}

	}
}
