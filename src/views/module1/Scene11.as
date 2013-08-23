package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module1.scene2.Hint;

	public class Scene11 extends PalaceScene
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
		private var windowXPosArr:Array=[415, 630, 1040, 1250];
		private var windowY:int=250;
		private var windowArr:Vector.<Sprite>=new Vector.<Sprite>();

		private var windowStrArr:Array=["hint3", "hint2", "hint2", "hint3"];

		private var hotzone1:Rectangle=new Rectangle(48, 209, 140, 134); //窗-左
		private var hotzone2:Rectangle=new Rectangle(746, 177, 158, 168); //门-中
		private var hotzone3:Rectangle=new Rectangle(1481, 216, 128, 128); //窗-右
		private var crtWinSelected:Boolean=false;

		private var hint:Hint;

		private var w0l:Sprite;
		private var w0s:Sprite;
		private var isShadowShow:Boolean;
		private var effComplete:Boolean=true;

		private var king:Sprite;

		private var okEff:Sprite;

		private var eunuch:Sprite;

		public function Scene11()
		{
		}

		override public function init():void
		{
			windowIndex=Math.random() > .5 ? 0 : 3;
			TweenPlugin.activate([ShakeEffect]);

			bg=new Sprite();
			bg.x=512;
			addChild(bg);

			bg.addChild(getImage("background11"));
			bg_width=bg.width;
			bg.pivotX=bg_width >> 1;

			mg=new Sprite();
			mg.x=512;
			mg.y=12;
			addChild(mg);

			mg.addChild(getImage("middleground11"));
			mg_width=mg.width;
			mg.pivotX=mg_width >> 1;

			fg=new Sprite();
			fg.x=512;
			addChild(fg);

			onFGLoaded();
		}

		protected function onFGLoaded():void
		{
			fg.addChild(getImage("frontground11"));
			fg_width=fg.width;
			fg.x=(1024 - fg_width) / 2;
			fg.y=768 - fg.height;

			addEventListener(TouchEvent.TOUCH, onTouch);
			fg.addEventListener(TouchEvent.TOUCH, onFGTouch);
			addWindows();
			addKing();
		}

		private function addKing():void
		{
			king=new Sprite();
			king.addChild(getImage("king11"));
			SPUtils.registSPCenter(king, 2);
			addChild(king);
			king.x=512;
			king.y=768;
			king.addEventListener(TouchEvent.TOUCH, onKingTouch);

			showHint(50, 50, "hint0", 3, king);
		}

		private function onKingTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(stage);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if (dpt && Point.distance(dpt, pt) < 10)
						showHint(50, 50, "hint0", 3, king);
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
			if (!tc)
				return;
			var pt:Point=tc.getLocation(stage);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					if (dpt && Point.distance(dpt, pt) < 10)
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

		private function showShadow():void
		{
			if (!isShadowShow)
				TweenLite.to(w0s, 1, {alpha: 1, onComplete: function():void
				{
					showHint(hotzone1.x + hotzone1.width / 2, hotzone1.y + hotzone1.height / 2, "hint1", 1, fg);
					isShadowShow=true;
					effComplete=true;
				}});
			else
				TweenLite.to(w0l, 1, {alpha: 0, onComplete: function():void
				{
					isShadowShow=false;
					effComplete=true;
				}});
		}

		private function checkFG(pt:Point):void
		{
			var lp:Point=fg.globalToLocal(pt);

			if (hotzone1.containsPoint(lp))
			{
				if (!effComplete)
					return;
				effComplete=false;
				if (!isShadowShow)
					TweenLite.to(w0l, 1, {alpha: 1, onComplete: showShadow});
				else
					TweenLite.to(w0s, 1, {alpha: 0, onComplete: showShadow});
			}
			else if (hotzone2.containsPoint(lp))
			{
				showHint(hotzone2.x + hotzone2.width / 2, hotzone2.y + hotzone2.height / 2, "hint2", 1, fg);
			}
			else if (hotzone3.containsPoint(lp))
			{
				showHint(hotzone3.x + hotzone3.width / 2, hotzone3.y + hotzone3.height / 2, "hint4", 3, fg);
			}
		}

		private function addWindows():void
		{
			w0l=new Sprite();
			w0l.x=hotzone1.x;
			w0l.y=hotzone1.y;
			fg.addChild(w0l);
			w0l.alpha=0;
			w0l.addChild(getImage("window0-light"));

			w0s=new Sprite();
			w0s.x=hotzone1.x;
			w0s.y=hotzone1.y;
			fg.addChild(w0s);
			w0s.alpha=0;
			w0s.addChild(getImage("window0-shadow"));

			for (var i:int=0; i < 4; i++)
			{
				var w:Sprite=new Sprite();
				var path:String="window" + (i + 1).toString() + "";
				w.addChild(getImage(path));
				fg.addChild(w);
				w.x=windowXPosArr[i];
				w.y=windowY;
				SPUtils.registSPCenter(w, 5);

				w.addEventListener(TouchEvent.TOUCH, onWindowTouch);
				windowArr.push(w);
			}
		}

		private function onWindowTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(stage);
			trace('window touch', pt);

			switch (tc.phase)
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
					if (dpt && crtTarget && Point.distance(dpt, pt) < 10)
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

		private function shake(sp:Sprite):void
		{
			if (crtWinSelected)
				return;

			sp.touchable=false;
			if (sp.x == windowXPosArr[windowIndex])
			{
				crtWinSelected=true;

				okEff=new Sprite();
				okEff.addChild(getImage("ok-effect"));
				SPUtils.registSPCenter(okEff, 5);
				okEff.x=sp.x;
				okEff.y=sp.y;
				fg.addChild(okEff);
				okEff.alpha=0;
				var targetPt:Point=fg.localToGlobal(new Point(sp.x, 0));
				var minPt:Point=fg.localToGlobal(new Point(0, 0));
				TweenLite.to(okEff, 2, {alpha: 1});
//				var tx:Number=512-targetPt.x;
//				trace(this.x)
//				trace(targetPt.x)
				TweenLite.to(this, 2, {scaleX: 1.2, scaleY: 1.2, onComplete: function():void
				{
					TweenLite.to(king, 1, {alpha: 0});
					TweenLite.delayedCall(2, resetView);
				}});
			}
			else
			{
				TweenMax.to(sp, 1, {shake: {rotation: .05, numShakes: 4}, onComplete: function():void
				{
					sp.touchable=true;
					showWindowHint(sp);
				}});
			}
		}

		private function resetView():void
		{
			TweenLite.to(this, 2, {scaleX: 1, scaleY: 1, x: 0, onComplete: addEunuch});
		}

		private function addEunuch():void
		{
			TweenLite.to(okEff, 1, {alpha: 0, onComplete: function():void
			{
				eunuch=new Sprite();
				eunuch.addChild(getImage("eunuch11"));
				SPUtils.registSPCenter(eunuch, 5);
				addChild(eunuch);
				eunuch.x=1150;
				eunuch.y=530;

				TweenLite.to(eunuch, 1, {x: 800});

//				eunuch.addEventListener(TouchEvent.TOUCH, nextScene);

				setTimeout(function():void
				{
					dispatchEvent(new Event("gotoNext", true));
				}, 5000);
			}});
		}

		private function nextScene(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
			{
				eunuch.removeEventListener(TouchEvent.TOUCH, nextScene);
				dispatchEvent(new Event("gotoNext", true));
			}
		}

		//显示提示气泡
		private function showWindowHint(sp:Sprite):void
		{
			var index:int=windowXPosArr.indexOf(sp.x);
			showHint(sp.x, sp.y, windowStrArr[index], 1, fg);
		}

		private function showHint(_x:Number, _y:Number, _src:String, reg:int, _parent:Sprite):void
		{
			if (crtWinSelected)
				return;

//			Prompt.hideAll();
			Prompt.show(_x, _y, _src, '', reg, 2, _parent);

//			var _img:Image=getImage(_src);
//
////			var hint:Sprite=new Sprite();
////			hint.addChild(img);
////			SPUtils.registSPCenter(hint,reg);
////			hint.x=_x;
////			hint.y=_y;
////			_parent.addChild(hint);
//			if (!hint)
//				hint=new Hint();
//			hint.registration=reg;
//			hint.img=_img;
//			hint.x=_x;
//			hint.y=_y;
//			_parent.addChild(hint);
//			hint.show();
		}

		private function onTouch(event:TouchEvent):void
		{
			if (crtWinSelected)
				return;
			event.stopImmediatePropagation();
			var touches:Vector.<Touch>=event.getTouches(stage, TouchPhase.MOVED);
			//如果只有一个点在移动，是单点触碰
			if (touches.length == 1)
			{
				var delta:Point=touches[0].getMovement(stage);
				var dx:Number=delta.x;
				var tx:Number=fg.x + dx / 2;
				if (tx < (1024 - fg_width))
					dx=(1024 - fg_width - fg.x) * 2;
				else if (tx > 0)
					dx=(0 - fg.x) * 2;

				bg.x+=dx / 5;
				mg.x+=dx / 3;
				fg.x+=dx / 2;
				king.x-=dx / 8;
			}
		}
	}
}

