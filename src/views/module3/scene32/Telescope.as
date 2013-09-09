package views.module3.scene32
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class Telescope extends PalaceGame
	{

		private var view:ViewHolder;
		private var index:int;

		public function Telescope(am:AssetManager=null)
		{
			super(am);

			addChild(getImage("tele-bg"));

			view=new ViewHolder();
			addChild(view);
			view.img1=getImage("view1");
			view.img2=getImage("view2");
			view.viewPortHeight=view.viewPortWidth=440;
			view.x=view.pivotX=90 + 474 / 2;
			view.y=view.pivotY=46 + 474 / 2;

			var mask:Image=getImage("tele-mask");
			mask.x=90;
			mask.y=46;
			addChild(mask);

			addEventListener(TouchEvent.TOUCH, onTouch);

			var king:Image=getImage("tele-king");
			king.x=742;
			king.y=439;

			addTele();

		}

		private function addTele():void
		{
			// TODO Auto Generated method stub

		}

		protected function onTimer(event:TimerEvent):void
		{
			view.scale=1 - index % 100 / 100;
			view.blur(int(index % 15))
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.MOVED);
			if (tc)
			{
				var move:Point=tc.getMovement(this);
				view.pivotX-=move.x;
				view.pivotY-=move.y;
			}
		}
	}
}
