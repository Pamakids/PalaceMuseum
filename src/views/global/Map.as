package views.global
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Point;

	import controllers.MC;

	import feathers.controls.Button;

	import models.Const;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.FlipAnimation;
	import views.components.base.PalaceModule;

	public class Map extends PalaceModule
	{
		private var flipAnimation:FlipAnimation;

		public function Map(from:int=0, to:int=0)
		{
			this.from=from;
			this.to=to;
			points=[new Point(365, 495), new Point(365, 535)];
			super(new AssetManager(), Const.WIDTH, Const.HEIGHT);
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
			var f:File=File.applicationDirectory.resolvePath('assets/global/map');
			if (to || from)
				assetManager.enqueue(f);
			else
				assetManager.enqueue('assets/common/button_close.png', f);
			assetManager.loadQueue(function(ratio:Number):void
			{
				trace(ratio);
				if (ratio == 1)
				{
					if (!to && !from)
					{
						var b:Button=new Button();
						b.defaultSkin=getImage('button_close');
						addChild(b);
						b.validate();
						b.addEventListener(Event.TRIGGERED, triggeredHandler);
						b.x=width - b.width - 10;
						b.y=10;
					}

					king=getImage('king');
					king.pivotX=king.width / 2;
					king.pivotY=king.height / 2;
				}
			});
		}

		public static var map:Map;
		public static var callback:Function;
		public static var parent:Sprite;
		public var from:int;
		public var to:int;
		public var points:Array;

		/**
		 * 显示地图
		 * @param callback 关闭后的回调函数，默认在动画播放完后调用，用以加载模块素材。如若回调函数有参数，则返回0表示动画播放完成，返回1表示关闭
		 * @param from 转场起点
		 * @param to   转场终点
		 */
		public static function show(callback:Function=null, from:int=0, to:int=0):void
		{
			var m:Map=new Map(from, to);
			Map.callback=callback;
			parent.addChild(m);
		}

		private function triggeredHandler():void
		{
			trace('close');
			this.removeFromParent(true);
			if (!callback)
				return;
			if (callback.length)
				callback(1);
			else
				callback();
			callback=null;
		}

		private function bgLoadedHandler(b:Bitmap):void
		{
			flipAnimation=new FlipAnimation(b, 4, 2);
			flipAnimation.addEventListener('completed', flipedHandler);
			flipAnimation.width=width;
			flipAnimation.height=height;
			addChild(flipAnimation);
		}

		override public function dispose():void
		{
			if (stage)
				stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			super.dispose();
			trace('disposed');
		}

		private function flipedHandler(e:Event):void
		{
			var kingPoint:Point=points[MC.instance.moduleIndex];
			if (king)
			{
				king.x=kingPoint.x;
				king.y=kingPoint.y;
				flipAnimation.addChild(king);
			}
			if (from || to)
			{
				var map:Map=this;
				var toy:Number=kingPoint.y > height / 2 ? height / 2 - kingPoint.y : 0;
				TweenLite.to(flipAnimation, 0.5, {y: toy, ease: Cubic.easeOut, onComplete: function():void
				{
					var top:Point=points[to];
					TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
					{
						map.removeFromParent(true);
						if (callback && callback.length)
							callback(1);
						else
							callback();
						callback=null;
					}});
				}});
			}
			else
			{
				stage.addEventListener(TouchEvent.TOUCH, touchHandler);
				TweenLite.to(flipAnimation, 8, {y: 0});
			}
			if (!callback)
				return;
			if (callback.length)
				callback(0);
			else
				callback();
			callback=null;
		}

		private var downPoint:Point;
		private var downY:Number;
		private var king:Image;

		private function touchHandler(e:TouchEvent):void
		{
			var t:Touch=e.getTouch(stage);
			if (!t)
				return;
			var p:Point=new Point(t.globalX, t.globalY);
			var toy:Number;
			switch (t.phase)
			{
				case TouchPhase.BEGAN:
					TweenLite.killTweensOf(flipAnimation);
					downPoint=new Point(t.globalX, t.globalY);
					downY=flipAnimation.y;
					break;
				case TouchPhase.MOVED:
					toy=p.y - downPoint.y;
					flipAnimation.y=downY + toy / scale;
					break;
				case TouchPhase.ENDED:
					if (flipAnimation.y > 0)
					{
						toy=0;
						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
					}
					else if (flipAnimation.y < height - flipAnimation.height)
					{
						toy=height - flipAnimation.height;
						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
					}
					break;
			}
		}
	}
}
