package events
{
	import starling.events.Event;

	public class OperaSwitchEvent extends Event
	{
		public static const EVENT_ID:String="OperaSwitchEvent";

		public static const OPEN:String="curtain-open"
		public static const CLOSE:String="curtain-close"

		public static const OPEN_CLOSE:String="curtain-open-close"
		public static const CLOSE_OPEN:String="curtain-close-open"

		public var action:String;
		public var openCallback:Function;
		public var closeCallback:Function;
		public var delay:Number;

		/**
		 * @param _action OPEN:打开,CLOSE:关闭,2:先开再关,3,先关再开
		 * @param _openCallback 幕布打开的回调
		 * @param _closeCallback 幕布关上的回调
		 */
		public function OperaSwitchEvent(_action:String, _openCallback:Function=null, _closeCallback:Function=null, _delay:Number=1.5)
		{
			super(EVENT_ID, true);
			action=_action;
			openCallback=_openCallback;
			closeCallback=_closeCallback;
			delay=_delay;
		}
	}
}
