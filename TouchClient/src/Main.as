package
{
	import com.pamakids.AirProxy;

	import flash.events.TouchEvent;
	import flash.geom.Point;

	import control.Controller;

	import feathers.controls.Button;
	import feathers.controls.TextInput;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	import utils.PosVO;

	public class Main extends Sprite
	{
		private var connetBtn:Button;

		private var proxy:AirProxy;

		private var ip:TextInput;

		private var port:TextInput;

		public var info:TextField;

		private var connectContainer:Sprite;
		private var touchContainer:Sprite;

		[Embed(source="assets/gamebg.jpg")]
		private var bg:Class;

		[Embed(source="assets/craw-light.png")]
		private var craw:Class;

		public function Main()
		{
			this.scaleX=this.scaleY=PosVO.scale;
			Controller.main=this;
			addChild(Image.fromBitmap(new bg()));

			addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
		}

		private var handArr:Vector.<Image>=new Vector.<Image>(10);

		private function onTouch(e:starling.events.TouchEvent):void
		{
			var tcs:Vector.<Touch>=e.getTouches(this);
			for each (var tc:Touch in tcs)
			{
				moveHand(tc);
				sendTouch(tc);
			}
		}

		private function sendTouch(tc:Touch):void
		{
			var pt:Point=tc.getLocation(this);
			var type:String=typeTrans(tc.phase);
			if (!pt || !type)
				return;
			var e:flash.events.TouchEvent=new flash.events.TouchEvent(type, true, false, tc.id, false,
																	  Math.round(pt.x), Math.round(pt.y));
			if (Controller.app)
				Controller.app.send(e);
		}

		private function typeTrans(phase:String):String
		{
			var type:String;
			switch (phase)
			{
				case TouchPhase.BEGAN:
				{
					type=flash.events.TouchEvent.TOUCH_BEGIN
					break;
				}

				case TouchPhase.MOVED:
				{
					type=flash.events.TouchEvent.TOUCH_MOVE
					break;
				}

				case TouchPhase.ENDED:
				{
					type=flash.events.TouchEvent.TOUCH_END
					break;
				}

				default:
				{
					break;
				}
			}
			return type;
		}

		private function moveHand(tc:Touch):void
		{
			var pt:Point=tc.getLocation(this);
			if (!pt)
				return;
			var id:int=tc.id;
			var hand:Image=handArr[id];
			if (!hand)
			{
				hand=Image.fromBitmap(new craw());
				hand.pivotX=hand.width >> 1;
				hand.pivotY=hand.height >> 1;
				addChild(hand);
				hand.touchable=false;
				handArr[id]=hand;
			}
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					hand.visible=true;
					hand.x=pt.x;
					hand.y=pt.y;
					break;
				}

				case TouchPhase.MOVED:
				{
					hand.x=pt.x;
					hand.y=pt.y;
					break;
				}

				case TouchPhase.ENDED:
				{
					hand.visible=false;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function touchToOrignTouch(tc:Touch):flash.events.TouchEvent
		{
			var e:flash.events.TouchEvent;
			return e;
		}

	}
}
