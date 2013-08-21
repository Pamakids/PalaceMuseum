package modules.module1
{
	import com.greensock.TweenLite;

	import feathers.controls.renderers.DefaultListItemRenderer;

	import starling.display.DisplayObject;
	import starling.display.Image;

	public class BoxCellRenderer extends DefaultListItemRenderer
	{
		public var cloth:Cloth;

		public function BoxCellRenderer()
		{
			super();
			width=284;
			height=223;
		}

		override public function set defaultIcon(value:DisplayObject):void
		{
			if(value){
				if(!cloth){
					cloth=new Cloth(label);
					cloth.img=value as Image;
					cloth.scaleX=cloth.scaleY=.5;
				}
			}
			super.defaultIcon=cloth;
		}

		public function iconVisible(value:Boolean):void{
			TweenLite.to(defaultIcon,.5,{alpha:(value?0:1)});
		}
	}
}

