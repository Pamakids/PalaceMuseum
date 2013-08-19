package modules.module1
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.manager.LoadManager;
	import com.pamakids.palace.base.PalaceScean;
	import com.pamakids.palace.utils.SPUtils;
	
	import dragonBones.core.dragonBones_internal;
	
	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
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
		private var windowIndex:uint;
		private var windowXPosArr:Array=[415,630,1040,1250];
		private var windowY:int=250;
		private var windowArr:Vector.<Sprite>=new Vector.<Sprite>();
		
		private var windowStrArr:Array=["hint3.png","hint2.png","hint2.png","hint3.png"];
		
		private var hotzone1:Rectangle=new Rectangle(48,214,140,134);//窗-左
		private var hotzone2:Rectangle=new Rectangle(746,177,158,168);//门-中
		private var hotzone3:Rectangle=new Rectangle(1481,216,128,128);//窗-右
		private var crtWinSelected:Boolean=false;

		private var hint:Hint;

		private var w0l:Sprite;
		private var w0s:Sprite;
		private var isShadowShow:Boolean;
		private var effComplete:Boolean=true;

		private var king:Sprite;

		private var okEff:Sprite;
		
		public function Scean11()
		{
			windowIndex=Math.random()>.5?0:3;
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
			addKing();
		}
		
		private function addKing():void
		{
			king=new Sprite();
			king.addChild(getImage("king.png"));
			SPUtils.registSPCenter(king,2);
			addChild(king);
			king.x=512;
			king.y=768;
			king.addEventListener(TouchEvent.TOUCH,onKingTouch);
			
			showHint(512,600,"hint0.png",3,this);
		}
		
		private function onKingTouch(event:TouchEvent):void
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
						showHint(512,600,"hint0.png",3,this);
					dpt=null;
					break;
				}
					
				default:
				{
					break;
				}
			}
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
		
		private function showShadow():void{
			if(!isShadowShow)
				TweenLite.to(w0s,1,{alpha:1,onComplete:function():void{
					showHint(hotzone1.x+hotzone1.width/2,hotzone1.y+hotzone1.height/2,"hint1.png",1,fg);
					isShadowShow=true;
					effComplete=true;
				}});
			else
				TweenLite.to(w0l,1,{alpha:0,onComplete:function():void{
					isShadowShow=false;
					effComplete=true;
				}});
		}
		
		private function checkFG(pt:Point):void
		{
			var lp:Point=fg.globalToLocal(pt);
			
			if(hotzone1.containsPoint(lp)){
				if(!effComplete)
					return;
				effComplete=false;
				if(!isShadowShow)
					TweenLite.to(w0l,1,{alpha:1,onComplete:showShadow});
				else
					TweenLite.to(w0s,1,{alpha:0,onComplete:showShadow});
			}
			else if(hotzone2.containsPoint(lp)){
				showHint(hotzone2.x+hotzone2.width/2,hotzone2.y+hotzone2.height/2,"hint2.png",1,fg);
			}
			else if(hotzone3.containsPoint(lp)){
				showHint(hotzone3.x+hotzone3.width/2,hotzone3.y+hotzone3.height/2,"hint4.png",3,fg);
			}
		}
		
		private function addWindows():void
		{
			w0l=new Sprite();
			w0l.x=hotzone1.x;
			w0l.y=hotzone1.y;
			fg.addChild(w0l);
			w0l.alpha=0;
			w0l.addChild(getImage("window0-light.png"));
			
			w0s=new Sprite();
			w0s.x=hotzone1.x;
			w0s.y=hotzone1.y;
			fg.addChild(w0s);
			w0s.alpha=0;
			w0s.addChild(getImage("window0-shadow.png"));
			
			for (var i:int = 0; i < 4; i++) 
			{
				var w:Sprite=new Sprite();
				var path:String="window"+(i+1).toString()+".png";
				w.addChild(getImage(path));
				fg.addChild(w);
				w.x=windowXPosArr[i];
				w.y=windowY;
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
			if(crtWinSelected)
				return;
			
			sp.touchable=false;
			if(sp.x==windowXPosArr[windowIndex]){
				crtWinSelected=true;
				
				okEff=new Sprite();
				okEff.addChild(getImage("ok-effect.png"));
				SPUtils.registSPCenter(okEff,5);
				okEff.x=sp.x;
				okEff.y=sp.y;
				fg.addChild(okEff);
				okEff.alpha=0;
				var targetPt:Point=fg.localToGlobal(new Point(sp.x,0));
				TweenLite.to(okEff,2,{alpha:1});
				TweenLite.to(this,2,{scaleX:1.2,scaleY:1.2,x:(512-targetPt.x),
					onComplete:function():void{
						TweenLite.to(king,1,{alpha:0});
						TweenLite.delayedCall(2,resetView);
					}});
			}
			else{
			TweenMax.to(sp, 1, {shake: {rotation: .05, numShakes: 4},onComplete:function():void{
				sp.touchable=true;
				showWindowHint(sp);
			}});
			}
		}
		
		private function resetView():void{
			TweenLite.to(this,2,{scaleX:1,scaleY:1,x:0,onComplete:addEunuch});
		}
		
		private function addEunuch():void{
			TweenLite.to(okEff,1,{alpha:0,onComplete:function():void{
				var eunuch:Sprite=new Sprite();
				eunuch.addChild(getImage("eunuch.png"));
				SPUtils.registSPCenter(eunuch,5);
				addChild(eunuch);
				eunuch.x=1150;
				eunuch.y=500;
				
				TweenLite.to(eunuch,1,{x:850});
				
			}});
		}
		
		//显示提示气泡
		private function showWindowHint(sp:Sprite):void
		{
			var index:int=windowXPosArr.indexOf(sp.x);
			showHint(sp.x,sp.y,windowStrArr[index],1,fg);
		}
		
		private function showHint(_x:Number,_y:Number,_src:String,reg:int,_parent:Sprite):void
		{
			if(crtWinSelected)
				return;
			
			var _img:Image=getImage(_src);
			
//			var hint:Sprite=new Sprite();
//			hint.addChild(img);
//			SPUtils.registSPCenter(hint,reg);
//			hint.x=_x;
//			hint.y=_y;
//			_parent.addChild(hint);
			if(!hint)
				hint=new Hint();
			hint.registration=reg;
			hint.img=_img;
			hint.x=_x;
			hint.y=_y;
			_parent.addChild(hint);
			hint.show();
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

