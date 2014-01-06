package com.pamakids
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.Socket;

	public class AirProxy
	{
		public function AirProxy()
		{
		}

		private static var _instance:AirProxy;
		private var socket:Object;

		public static function getInstance():AirProxy
		{
			if (!_instance)
				_instance=new AirProxy();
			return _instance;
		}

		/**
		 * 0:"连接成功"
		 * 1:"连接断开"
		 * 2:"连接错误"
		 * */
		private var statusHandler:Function

		public function init(handler:Function):void
		{
			statusHandler=handler;
			socket=new Socket();

			socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
		}

		public function send(o:Object):void
		{
			socket.writeObject(o);
			socket.flush();
		}

		public function connect(ip:String, port:String="1234"):void
		{
			socket.connect(ip, int(port));
		}

		private function connectHandler(event:Event):void
		{
			statusHandler(0);
		}

		private function closeHandler(event:Event):void
		{
			statusHandler(1);
		}

		protected function onError(event:IOErrorEvent):void
		{
			statusHandler(2);
		}
	}
}
