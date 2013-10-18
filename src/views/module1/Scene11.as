package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.palace.utils.SPUtils;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import controllers.MC;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;

	/**
	 * 早起模块
	 * 找房间场景
	 * @author Administrator
	 */
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

		private var windowStrArr:Array=[];

		private var hint0:String="皇帝寝室是哪一间呢？";
		private var hint1:String="皇贵妃还在休息，不要打扰";
		private var hint2:String="皇帝的休息室，他不在这里";
		private var hint3:String="皇帝寝室，但他今天在另一间休息";
		private var hint4:String="皇后在自己的寝宫，不在这里";

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

		private var eunuch:MovieClip;

		/**
		 *
		 * @param am
		 */
		public function Scene11(am:AssetManager)
		{
			super(am);
			windowStrArr=[hint3, hint2, hint2, hint3];
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

		/**
		 *
		 */
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

			onAutoMove(2000);
			_offsetX=-10;
			TweenLite.to(this, 5, {offsetX: -10, onComplete:
					function():void
					{
						showHint(50, 50, hint0, 3, king, 3);
					}});
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
		}

		private function onKingTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			if (dpt && Point.distance(dpt, pt) < 15)
				showHint(50, 50, hint0, 3, king, 3);
		}

		private function onFGTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			if (dpt && Point.distance(dpt, pt) < 15)
				checkFG(tc.getLocation(fg));
		}

		private function showShadow():void
		{
			if (!isShadowShow)
				TweenLite.to(w0s, 1, {alpha: 1, onComplete: function():void
				{
					showHint(hotzone1.x + hotzone1.width / 2, hotzone1.y + hotzone1.height / 2, hint1, 1, fg);
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
			if (hotzone1.containsPoint(pt))
			{
				if (!effComplete)
					return;
				effComplete=false;
				if (!isShadowShow)
					TweenLite.to(w0l, 1, {alpha: 1, onComplete: showShadow});
				else
					TweenLite.to(w0s, 1, {alpha: 0, onComplete: showShadow});
			}
			else if (hotzone2.containsPoint(pt))
			{
				showHint(hotzone2.x + hotzone2.width / 2, hotzone2.y + hotzone2.height / 2, hint2, 1, fg);
			}
			else if (hotzone3.containsPoint(pt))
			{
				showHint(hotzone3.x + hotzone3.width / 2, hotzone3.y + hotzone3.height / 2, hint4, 3, fg, 3);
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

		private function onWindowTouch(e:TouchEvent):void
		{
			var w:Sprite=e.currentTarget as Sprite;
			if (!w)
				return;
			var tc:Touch=e.getTouch(w);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					crtTarget=w;
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
				showAchievement(1);
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
				eunuch=new Eunuch();
				eunuch.x=1024;
				eunuch.y=350;

				MC.instance.addChild(eunuch);
				eunuch.play();
				eunuch.addEventListener(Event.FRAME_CONSTRUCTED, onPlayMC);
				TweenLite.to(eunuch, 6, {x: 780, onComplete: sceneOver});
//				sceneOver();
			}});
		}

		protected function onPlayMC(event:Event):void
		{
			if (eunuch.currentFrame == eunuch.totalFrames)
			{
				eunuch.stop();
				eunuch.removeEventListener(Event.FRAME_CONSTRUCTED, onPlayMC);
			}
		}

		override public function dispose():void
		{
			super.dispose();
			if (eunuch)
			{
				eunuch.stop();
				MC.instance.removeChild(eunuch);
				eunuch=null;
			}
		}

		//显示提示气泡
		private function showWindowHint(sp:Sprite):void
		{
			var index:int=windowXPosArr.indexOf(sp.x);
			showHint(sp.x, sp.y, windowStrArr[index], 1, fg);
		}

		private var p:Prompt;
//		private var hintCount:int=0;

		private var checkDic:Dictionary=new Dictionary();

		private function showHint(_x:Number, _y:Number, _src:String, reg:int, _parent:Sprite, align:int=1):void
		{

			if (crtWinSelected)
				return;

			checkDic[_src + _x.toFixed(1)]=true;
			var b:Boolean;
			var hintCount:int=0;
			for each (b in checkDic)
			{
				if (b)
					hintCount++;
			}

			if (hintCount > 5)
				showAchievement(0);

			if (p)
				p.playHide();
			p=Prompt.showTXT(_x, _y, _src, 20, null, _parent, align)
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
					if (_offsetX != 0)
					{
						_offsetX == 0;
						TweenLite.killTweensOf(this, true);
					}
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
					dpt=null;
					break;
				}
				default:
				{
					break;
				}
			}
		}

		private var _offsetX:Number;

		public function get offsetX():Number
		{
			return _offsetX;
		}

		public function set offsetX(value:Number):void
		{
			_offsetX=value;
			onAutoMove(value);
		}


		private function onAutoMove(dx:Number):void
		{
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

