package views.components
{
	import feathers.controls.Button;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class InfoSwitch extends Sprite
	{
		private var length:int;
		private var _index:int=-1;
		private var objArr:Array;
		private var pre:Button;
		private var next:Button;
		private var _W:Number;
		private var _H:Number;
		private var dx:Number;
		private var dy:Number;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			if (_index == value || value >= length)
				return;

			if (_index >= 0)
				objArr[_index].alpha=0;
			objArr[value].alpha=1;
			_index=value;
			if (pre)
				pre.visible=pre.touchable=value != 0;
			if (next)
				next.visible=next.touchable=value != length - 1;
		}

		public function InfoSwitch(_objArr:Array, _dx:Number=0, _dy:Number=0)
		{
			dx=_dx;
			dy=_dy;
			objArr=_objArr;
			length=objArr.length;
			for (var i:int=0; i < objArr.length; i++)
			{
				var obj:DisplayObject=objArr[i];
				addChild(obj);
				obj.x=dx;
				obj.y=dy;
				obj.alpha=0;
				_W=obj.width;
				_H=obj.height;
			}
			index=0;
		}

		public function addBtns(_pre:Image, _next:Image):void
		{
			pre=new Button()
			pre.defaultIcon=_pre;
			addChild(pre);
			pre.x=dx + _W / 2 - _pre.width / 2 * 3;
			pre.y=dy + _H - _pre.height / 2;
			pre.addEventListener(Event.TRIGGERED, onPre);
			pre.visible=pre.touchable=false;

			next=new Button()
			next.defaultIcon=_next;
			addChild(next);
			next.x=dx + _W / 2 + _next.width / 2;
			next.y=dy + _H - _next.height / 2;
			next.addEventListener(Event.TRIGGERED, onNext);
		}

		private function onNext(e:Event):void
		{
			if (index < length - 1)
				index++;
		}

		private function onPre(e:Event):void
		{
			if (index > 0)
				index--;
		}

		override public function dispose():void
		{
			super.dispose();
			objArr=[];
		}
	}
}
