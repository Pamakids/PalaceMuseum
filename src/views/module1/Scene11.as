package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.palace.utils.SPUtils;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;

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

		private var w0l:Sprite;
		private var w0s:Sprite;
		private var isShadowShow:Boolean;
		private var effComplete:Boolean=true;

		private var king:Sprite;

		private var okEff:Sprite;

		private var eunuch:Sprite;

		public function Scene11(am:AssetManager)
		{
			super(am);
		}

		override protected function init():void
		{
			crtKnowledgeIndex=1;
			windowIndex=Math.random() > .5 ? 0 : 3;

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

			TweenLite.delayedCall(1.5, function():void
			{
				showHint(50, 50, "hint0", 3, king);
			});
		}

		private function onKingTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			if (dpt && Point.distance(dpt, pt) < 15)
				showHint(50, 50, "hint0", 3, king);
		}

		private function onFGTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			if (dpt && Point.distance(dpt, pt) < 15)
				checkFG(pt);
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
			var tc:Touch=event.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var img:Image=event.target as Image;
					crtTarget=img.parent as Sprite;
					break;
				}
				case TouchPhase.ENDED:
				{
					if (dpt && crtTarget && Point.distance(dpt, pt) < 15)
						shake(crtTarget);
					crtTarget=null;
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
				TweenLite.to(okEff, 2, {alpha: 1});
				var tx:Number;
				if (sp.x > width / 2)
					tx=1024 - bg.width;
				else
					tx=0;

				var dx:Number=(tx - fg.x) * 2;

				TweenLite.to(bg, 2, {x: bg.x + dx / 5});
				TweenLite.to(mg, 2, {x: mg.x + dx / 3});
				TweenLite.to(fg, 2, {x: tx});

				TweenLite.to(this, 2, {scaleX: 1.2, scaleY: 1.2, onComplete: function():void
				{
					TweenLite.to(king, 1, {alpha: 0});
					TweenLite.delayedCall(1.5, resetView);
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

				sceneOver();

			}});
		}

		//显示提示气泡
		private function showWindowHint(sp:Sprite):void
		{
			var index:int=windowXPosArr.indexOf(sp.x);
			showHint(sp.x, sp.y, windowStrArr[index], 1, fg);
		}

		private var p:Prompt;

		private function showHint(_x:Number, _y:Number, _src:String, reg:int, _parent:Sprite):void
		{
			if (crtWinSelected)
				return;

			if (p)
				p.playHide();
			p=Prompt.show(_x, _y, _src, '', reg, 2, null, _parent);
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
			var tc:Touch=event.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					break;
				}

				case TouchPhase.MOVED:
				{
					var delta:Point=tc.getMovement(this);
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
					break;
				}
				case TouchPhase.ENDED:
				{
//					var point:Point = tc.getLocation(this);
//					Prompt.show(point.x, point.y, "hint3", "位图字体位图字体", 5);

					dpt=null;
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}

