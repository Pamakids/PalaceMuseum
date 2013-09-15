package
{
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import controllers.MC;

	import starling.core.Starling;

	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0x333333")]
	public class PalaceMuseum extends Sprite
	{
		public function PalaceMuseum()
		{
			TweenPlugin.activate([ShakeEffect]);

			var scale:Number=DPIUtil.getDPIScale();
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			Starling.multitouchEnabled=true;
			Starling.handleLostContext=false;
			var main:Starling=new Starling(Main, stage);
			main.start();
			main.showStats=true;
			main.antiAliasing=16;

			MC.instance.stage=stage;
		}
	}
}

