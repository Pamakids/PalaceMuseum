package utils
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;

	public class TouchEventUtils
	{
		public function TouchEventUtils()
		{
		}

		public static function objToTouch(o:Object, pr:DisplayObject):TouchEvent
		{
			var pt:Point=new Point(o.x, o.y);
			if (pr)
				pt=pr.localToGlobal(pt);
			var e:TouchEvent=new TouchEvent(o.type, true, false, o.id, false, pt.x, pt.y, o.sizeX, o.sizeY, o.pressure);
//			trace("++++++++", o.id)
			return e;
		}

		private static var lastMD:MouseEvent;

		public static function objToMouse(o:Object, pr:DisplayObject):MouseEvent
		{
			if (o.id != 0)
				return null;
			var type:String=touchToMouse(o.type);
			if (!type)
				return null;
			var pt:Point=new Point(o.x, o.y);
			if (pr)
				pt=pr.localToGlobal(pt);
			var clickCount:int=0;
			if (type == MouseEvent.MOUSE_DOWN)
				clickCount=1;
			else if (type == MouseEvent.MOUSE_UP)
			{
				if (lastMD)
				{
					if (Point.distance(pt, new Point(lastMD.localX, lastMD.localY)) < 3)
						clickCount=1;
				}
				lastMD=null;
			}
			var e:MouseEvent=new MouseEvent(type, true, false, pt.x, pt.y, null, false, false, false, false, 0, false, false, clickCount);
			if (type == MouseEvent.MOUSE_DOWN)
				lastMD=e;
			return e;
		}

		public static function touchToMouse(_type:String):String
		{
			var type:String;
			switch (_type)
			{
				case TouchEvent.TOUCH_BEGIN:
				{
					type=MouseEvent.MOUSE_DOWN
					break;
				}

				case TouchEvent.TOUCH_MOVE:
				{
					type=MouseEvent.MOUSE_MOVE
					break;
				}

				case TouchEvent.TOUCH_END:
				{
					type=MouseEvent.MOUSE_UP
					break;
				}

				default:
				{
					break;
				}
			}

			return type;
		}

		public static function touchToObj(type:String, _x:Number, _y:Number, id:int, sizeX:Number=NaN, sizeY:Number=NaN, pressure:Number=NaN):Object
		{
			var o:Object={type: type, x: _x, y: _y, id: id, sizeX: sizeX, sizeY: sizeY, pressure: pressure};
			return o;
		}

	}
}
