package views.components.base
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.DPIUtil;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;

	public class Container extends Sprite
	{
		public function Container(width:Number=0, height:Number=0)
		{
			super();
			this.width=width;
			this.height=height;
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		protected function onStage(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			init();
		}

		protected var autoDisposed:Boolean=true;

		protected function onRemoved(e:Event):void
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

		public function addMask(_alpha:Number=.6, stopTouch:Boolean=true):void
		{
			removeMask();
			mask=new Quad(1024, 768, 0, true);
			mask.alpha=_alpha;
			addChild(mask);
			if (stopTouch)
				mask.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void {e.stopImmediatePropagation()});
		}

		public function removeMask():void
		{
			if (mask)
			{
				mask.removeFromParent(true);
				mask=null;
			}
		}

		public function restart():void
		{
			// TODO Auto Generated method stub

		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			super.dispose();
		}
	}
}
