package views.components.base
{
	import com.pamakids.utils.DPIUtil;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Container extends Sprite
	{
		protected var scale:Number;

		public function Container(width:Number=0, height:Number=0)
		{
			super();
			this.width=width;
			this.height=height;
			scale=DPIUtil.getDPIScale();
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		protected function onStage(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			init();
		}

		protected var autoDisposed:Boolean=true;

		private function onRemoved(e:Event):void
		{
			if (autoDisposed)
				dispose();
		}

		protected function init():void
		{

		}

		private var _width:Number;

		override public function get height():Number
		{
			return _height ? _height : super.height;
		}

		override public function set height(value:Number):void
		{
			_height=value;
		}

		override public function get width():Number
		{
			return _width ? _width : super.width;
		}

		override public function set width(value:Number):void
		{
			_width=value;
		}

		private var _height:Number;
		private var mask:Quad;

		public function addMask(_alpha:Number=.4):void
		{
			mask=new Quad(1024, 768, 0, true);
			mask.alpha=_alpha;
			addChild(mask);
		}

		public function removeMask():void
		{
			if (mask)
			{
				mask.removeFromParent(true);
				mask=null;
			}
		}
	}
}
