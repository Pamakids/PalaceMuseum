package modules.module1
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.manager.LoadManager;
	import com.pamakids.palace.base.PalaceScean;
	import com.pamakids.palace.utils.SPUtils;

	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Scean11 extends PalaceScean
	{
		private var bg_width:Number;
		private var mg_width:Number;
		private var fg_width:Number;

		private var bg:Sprite;
		private var mg:Sprite;
		private var fg:Sprite;

		private var crtTarget:Sprite;

		private var dpt:Point;
		private var windowXPosArr:Array=[415,630,1040,1250];
		private var windowArr:Vector.<Sprite>=new Vector.<Sprite>();

		private var hotzone1:Rectangle=new Rectangle(48,214,140,134);//窗-左
		private var hotzone2:Rectangle=new Rectangle(746,177,158,168);//门-中
		private var hotzone3:Rectangle=new Rectangle(1481,216,128,128);//窗-右

		public function Scean11()
		{
			TweenPlugin.activate([ShakeEffect]);

			bg=new Sprite();
			bg.x=512;
			addChild(bg);

			mg=new Sprite();
			mg.x=512;
			mg.y=12;
			addChild(mg);

			fg=new Sprite();
			fg.x=512;
			addChild(fg);

			LoadManager.instance.loadImage("/assets/module1/background.jpg",onBGLoaded);
			LoadManager.instance.loadImage("/assets/module1/middleground.png",onMGLoaded);
			LoadManager.instance.loadImage("/assets/module1/frontground.png",onFGLoaded);
		}

		protected function onError(event:IOErrorEvent):void
		{
			trace("error")
		}

		protected function onBGLoaded(b:Object):void
		{
			bg.addChild(Image.fromBitmap(b as Bitmap));
			bg_width=bg.width;
			trace(bg_width)
			bg.pivotX=bg_width>>1;
		}

		protected function onMGLoaded(b:Object):void
		{
			mg.addChild(Image.fromBitmap(b as Bitmap));
			mg_width=mg.width;
			mg.pivotX=mg_width>>1;
		}

		protected function onFGLoaded(b:Object):void
		{
			fg.addChild(Image.fromBitmap(b as Bitmap));
			fg_width=fg.width;
			fg.x=(1024-fg_width)/2;
			fg.y=768-fg.height;

			addEventListener(TouchEvent.TOUCH, onTouch);
			fg.addEventListener(TouchEvent.TOUCH, onFGTouch);
			addWindows();
		}

		private function onFGTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage);
			if(!tc)return;
			var pt:Point=tc.getLocation(stage);

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if(dpt&&Point.distance(dpt,pt)<1)
						checkFG(pt);
					dpt=null;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkFG(pt:Point):void
		{
			var lp:Point=fg.globalToLocal(pt);

			if(hotzone1.containsPoint(lp)){

			}
			else if(hotzone2.containsPoint(lp)){

			}
			else if(hotzone3.containsPoint(lp)){

			}
		}

		private function addWindows():void
		{
			for (var i:int = 0; i < 4; i++) 
			{
				var w:Sprite=new Sprite();
				var path:String="window"+(i+1).toString()+".png";
				w.addChild(getImage(path));
				fg.addChild(w);
				w.x=windowXPosArr[i];
				w.y=250;
				SPUtils.registSPCenter(w,5);

				w.addEventListener(TouchEvent.TOUCH,onWindowTouch);
				windowArr.push(w);
			}
		}

		private function onWindowTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage);
			if(!tc)return;
			var pt:Point=tc.getLocation(stage);

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var img:Image=event.target as Image;
					crtTarget=img.parent as Sprite;
					dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if(dpt&&crtTarget&&Point.distance(dpt,pt)<1)
						shake(crtTarget);
					crtTarget=null;
					dpt=null;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function shake(sp:Sprite):void{
			sp.touchable=false;
			TweenMax.to(sp, 1, {shake: {rotation: .05, numShakes: 4},onComplete:function():void{
				sp.touchable=true;
			}});
		}

		private function onTouch(event:TouchEvent):void
		{
			event.stopImmediatePropagation();
			var touches:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
			//如果只有一个点在移动，是单点触碰
			if (touches.length == 1)
			{
				var delta:Point = touches[0].getMovement(stage);
				var dx:Number = delta.x;
				var tx:Number=fg.x+dx/2;
				if(tx<(1024-fg_width))
					dx=(1024-fg_width-fg.x)*2;
				else if(tx>0)
					dx=(0-fg.x)*2;

				bg.x+=dx/5;
				mg.x+=dx/3;
				fg.x+=dx/2;
			}
		}
	}
}

