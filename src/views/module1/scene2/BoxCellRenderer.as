package views.module1.scene2
{
	import com.greensock.TweenLite;

	import feathers.controls.renderers.DefaultListItemRenderer;

	import starling.display.DisplayObject;

	public class BoxCellRenderer extends DefaultListItemRenderer
	{
		public function BoxCellRenderer()
		{
			super();
			width=284;
			height=223;
		}

		override public function set defaultIcon(value:DisplayObject):void
		{
			if(value)
				value.scaleX=value.scaleY=.5;
			super.defaultIcon=value;
			if(defaultIcon)
				trace(defaultIcon.alpha)
		}

		public function setIconVisible(value:Boolean):void{
			TweenLite.to(defaultIcon,.5,{alpha:(value?1:0)});
		}
	}
}

