package modules.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.base.PalaceScene;

	import feathers.controls.List;
	import feathers.layout.VerticalLayout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Scene12 extends PalaceScene
	{
		private var bg:Sprite;

		private var kingHolder:Sprite;
		private var boxHolder:Sprite;

		private var box:Image;

		private var boxCover:Sprite;
		private var opened:Boolean;
		public function Scene12()
		{

		}

		override public function init():void{
			bg=new Sprite();
			addChild(bg);

			bg.addChild(getImage("background12"));

			addKing();
			addBox();
		}

		private function addBox():void
		{
			boxHolder=new Sprite();
			addChild(boxHolder);
			boxHolder.x=686;
			boxHolder.y=572;

			box=getImage("box.png");
			box.addEventListener(TouchEvent.TOUCH,onClickBox);
			boxCover=new Sprite();
			boxCover.addChild(getImage("boxcover.png"));
			boxCover.pivotX=boxCover.width>>1;
			boxCover.x=box.width/2;
			boxCover.y=-4;

			boxHolder.addChild(box);
			boxHolder.addChild(boxCover);

			addShelf();
		}

		private function addShelf():void
		{
			var li:List=new List();

			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			layout.padding = 20;
			li.layout=layout;

		}

		private function onClickBox(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage,TouchPhase.ENDED);
			if(tc){
				opened=!opened;
				TweenLite.to(boxCover,1,{y:(opened?-544:-4)});
			}
//			box.removeEventListener(TouchEvent.TOUCH,onClickBox);
		}

		private function addKing():void
		{
			kingHolder=new Sprite();
			kingHolder.addChild(getImage("king12.png"));
			addChild(kingHolder);
			kingHolder.x=268;
			kingHolder.y=38;
		}
	}
}

