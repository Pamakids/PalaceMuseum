package modules.module1
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Hint extends Sprite
	{
		public function Hint()
		{
			addEventListener(TouchEvent.TOUCH,onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage,TouchPhase.ENDED);
			if(tc&&isShow){
				event.stopImmediatePropagation();
				hide();
			}
		}

		private var _img:Image;
		public var isShow:Boolean=false;
		public var registration:int;

		public function get img():Image
		{
			return _img;
		}

		public function set img(value:Image):void
		{
			if(!_img){
				_img = value;
				addChild(_img);
			}else if(_img!=value){
				removeChild(_img);
				_img.dispose();
				_img = value;
				addChild(_img);
			}

			this.pivotX=(_img.width>>1)*((registration-1)%3);
			this.pivotY=(_img.height>>1)*(2-int((registration-1)/3));
		}

		public function show():void{
			isShow=false;
			this.visible=true;
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(hide);
			this.scaleX=this.scaleY=0.1;
			this.alpha=0.5;
			TweenLite.to(this,.5,{scaleX:1,scaleY:1,alpha:1,onComplete:function():void{
				isShow=true;
				TweenLite.delayedCall(2,hide);
			}});
		}

		public function hide():void{
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(hide);
			TweenLite.to(this,.5,{alpha:0,onComplete:function():void{
				isShow=false;
				this.visible=false;
			}});
		}
	}
}

