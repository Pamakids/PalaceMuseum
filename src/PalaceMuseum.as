package
{
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.utils.DPIUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	
	import controllers.MC;
	
	import starling.core.Starling;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x333333")]
	public class PalaceMuseum extends Sprite
	{
		public function PalaceMuseum()
		{
			this.scaleX=this.scaleY=DPIUtil.getDPIScale();
			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);
			
			var scale:Number=DPIUtil.getDPIScale();
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled=true;
			Starling.handleLostContext=false;
			var main:Starling=new Starling(Main, stage);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=16;
			
			MC.instance.stage=this;
		}
	}
}

