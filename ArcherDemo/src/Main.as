package
{
	import flash.geom.Point;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Main extends Sprite
	{
		[Embed(source="assets/mountain.png")]
		private var bg:Class;

		private var fieldArr:Vector.<FieldBlock>=new Vector.<FieldBlock>();

		private var fieldHolder:Sprite;
		private var isDragging:Boolean;
		private var crtPt:Point;

		private var bow:Bow;

		private var arrow:Arrow;
		private var strength:Number;
		private var ifFlying:Boolean;

		private var target:Target;

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,inits);
		}

		private function inits(e:Event):void	
		{
			initBG();
			initField();
			initShooter();
			initTargets();
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			addEventListener(TouchEvent.TOUCH,onTouch);
		}

		private function initTargets():void
		{
			target=new Target();
			addChild(target);
			target.x=350;
			target.y=250;
			target.scaleX=target.scaleY=.4;
		}

		private function initBG():void
		{
			var bgHolder:Sprite=new Sprite();
			bgHolder.addChild(Image.fromBitmap(new bg()));
			addChild(bgHolder);
			bgHolder.y=-100;
		}

		private function initField():void
		{
			fieldHolder=new Sprite();
			fieldHolder.y=200;
			addChild(fieldHolder);

			for (var i:int = 0; i < 10; i++) 
			{
				var fb:FieldBlock=new FieldBlock();
				fb.index=i;
				fieldArr.push(fb);
				fieldHolder.addChild(fb);
				fb.x=512;
				fb.scaleX=.1;
				fb.scaleY=.1;
				fieldArr.push(fb);
			}
		}

		private function onEnterFrame(e:Event):void
		{
			for each (var fb:FieldBlock in fieldArr) 
			{
				fb.update();
			}

			if(crtPt&&isDragging){
				var dx:Number=crtPt.x-512;
				var dy:Number=crtPt.y-568;
				var angle:Number=Math.atan2(dy,dx);
				bow.rotation=Math.PI+angle;
				arrow.rotation=Math.PI+angle;
				strength=Point.distance(crtPt,new Point(512,568));
				arrow.dx=strength;
//				trace(dx,dy,int(strength));
			}

			if(ifFlying){
				arrow.update();
				checkHit();
			}
		}

		private function checkHit():void
		{
			if(Math.abs(arrow.scaleX-target.scaleX)<.02){
			}
		}

		private function initShooter():void
		{
			bow=new Bow();
			addChild(bow);
			bow.x=512;
			bow.y=568;
			bow.rotation=-Math.PI/2;

			arrow=new Arrow();
			addChild(arrow);
			arrow.x=512;
			arrow.y=568;
			arrow.rotation=-Math.PI/2;
//			arrow.scaleX=.8;
		}

		private function onTouch(e:TouchEvent):void{
			var tc:Touch=e.getTouch(stage);
			if(!tc)return;

			var pt:Point=tc.getLocation(stage);

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					isDragging=true;
					break;
				}

				case TouchPhase.ENDED:
				{
					if(isDragging)
						releaseArrow();
					break;
				}

				case TouchPhase.MOVED:
				{
					if(isDragging){
						crtPt=pt;
					}
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function releaseArrow():void
		{
			Starling.juggler.tween(arrow,.05,{dx:0,onComplete:completeFunction});
		}

		private function completeFunction():void
		{
			isDragging=false;
			var dx:Number=512-crtPt.x;
			var dy:Number=568-crtPt.y;
			arrow.speedX=dx/10;
			arrow.speedY=dy/10;
			ifFlying=true;
		}
	}
}

