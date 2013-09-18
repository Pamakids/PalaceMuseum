package views.module4.scene41
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class OperaBody extends Sprite
	{
		public var index:int;
		public var maskIndex:int;

		public function OperaBody()
		{
			super();
		}

		public var head:Image;
		public var body:Image;
		public var rope:Image;

		public function reset():void
		{
			rope.pivotX=rope.width >> 1;
			rope.pivotY=rope.height;
			rope.y=-head.height >> 1;
			addChild(rope);

			head.pivotX=head.width >> 1;
			head.pivotY=head.height;
			addChild(head);

			body.pivotX=body.width >> 1;
			addChild(body);

			startShakeHead(Math.PI / 36);
			startShakeBody(Math.PI / 36);
		}

		private var count:int=0;
		private var reverse:Boolean;
		private var headAngle:Number=0;
		private var bodyAngle:Number=0;
		private var dh:Number=0;
		private var db:Number=0;

		public function shake():void
		{
			if (count == 0)
				reverse=false;
			else if (count == 9)
				reverse=true;

			count+=reverse ? -1 : 1;

			head.rotation=headAngle * (count - 5) / 5;
			body.rotation=bodyAngle * (5 - count) / 5;

			headAngle=Math.max(0, headAngle - dh);
			bodyAngle=Math.max(0, bodyAngle - db);
		}

		public function startShakeHead(value:Number):void
		{
			headAngle=value;
			dh=headAngle / 1000;
		}

		public function startShakeBody(value:Number):void
		{
			bodyAngle=value;
			db=bodyAngle / 1000;

		}
	}
}
