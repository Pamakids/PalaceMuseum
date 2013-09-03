package views.global
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import controllers.MC;

	import feathers.controls.Button;

	import models.Const;
	import models.SOService;

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
		/**
		 * 地图上不同模块或场景对应的区域
		 */
		private var areas:Array;

		public function Map(from:int=0, to:int=0)
		{
			this.from=from;
			this.to=to;
			areas=[new Rectangle(333, 476, 64, 36), new Rectangle(314, 516, 104, 38)];
			points=[new Point(365, 495), new Point(365, 535)];
			super(new AssetManager(), Const.WIDTH, Const.HEIGHT);
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
			var f:File=File.applicationDirectory.resolvePath('assets/global/map');
//			if (to || from)
//				assetManager.enqueue(f);
//			else
			assetManager.enqueue('assets/common/button_close.png', f);
			assetManager.loadQueue(function(ratio:Number):void
			{
				trace(ratio);
				if (ratio == 1)
				{
					king=getImage('king');
					king.pivotX=king.width / 2;
					king.pivotY=king.height / 2;
					initCloseButton();
				}
			});
		}

		private function initCloseButton():void
		{
			var b:Button=new Button();
			b.defaultSkin=getImage('button_close');
			addChild(b);
			b.validate();
			b.addEventListener(Event.TRIGGERED, closeTriggeredHandler);
			b.x=width - b.width - 10;
			b.y=10;
			closeButton=b;
			closeButton.visible=false;
		}

		public static var map:Map;
		public static var callback:Function;
		public static var parent:Sprite;
		public var from:int;
		public var to:int;
		public var points:Array;

		/**
		 * 显示地图
		 * @param callback 关闭后的回调函数，默认在动画播放完后调用，用以加载模块素材。如若回调函数有参数，则返回0表示动画播放完成，返回1表示直接关闭，返回2表示选择场景后自动关闭
		 * @param from 	   当前模块
		 * @param to   	   转向模块
		 */
		public static function show(callback:Function=null, from:int=0, to:int=0):void
		{
			var ec:Boolean=true;
			if (from || to || callback == null)
				ec=false;
			Map.callback=callback;
			if (map)
			{
				map.show(ec);
				parent.setChildIndex(map, parent.numChildren - 1);
			}
			else
			{
				var m:Map=new Map(from, to);
				parent.addChild(m);
				map=m;
			}
		}

		private function closeTriggeredHandler():void
		{
			trace('close');
			clear(1);
		}

		private function clear(status:int):void
		{
//			this.removeFromParent(true);
			stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			visible=false;
			changing=false;
			if (!callback)
				return;
			if (callback.length)
				callback(status);
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

		private function showKing():void
		{
			positionKing(from);
			flipAnimation.addChild(king);
		}

		private function positionKing(index:int):void
		{
			var kingPoint:Point=points[index];
			king.x=kingPoint.x;
			king.y=kingPoint.y;
		}

		public var isTask:Boolean=true;

		private function flipedHandler(e:Event):void
		{
			var kingPoint:Point=points[MC.instance.moduleIndex];
			if (king && SOService.instance.isModuleCompleted(from))
				showKing();
			if ((from || to) && !isTask)
			{
				var map:Map=this;
				var toy:Number=kingPoint.y > height / 2 ? height / 2 - kingPoint.y : 0;
				TweenLite.to(flipAnimation, 0.5, {y: toy, ease: Cubic.easeOut, onComplete: function():void
				{
					moveKing(1);
				}});
			}
			else
			{
				TweenLite.to(flipAnimation, 1.5, {x: 0, scaleX: 1, scaleY: 1, onComplete: function():void
				{
					closeButton.visible=enableClose;
					stage.addEventListener(TouchEvent.TOUCH, touchHandler);
					TweenLite.to(flipAnimation, 8, {delay: 1, y: 0, ease: Cubic.easeOut});
				}});
			}
			if (!callback)
				return;
			if (callback.length)
				callback(0);
			else
				callback();
		}

		private function moveKing(status:int):void
		{
			var top:Point=points[to];
			TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
			{
				clear(status);
				MC.instance.gotoModule(to);
			}});
		}

		private var downPoint:Point;
		private var downY:Number;
		private var king:Image;
		private var changing:Boolean;
		private var closeButton:Button;

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
					var yv:Number=downY + toy / scale;
					if (yv > 0)
						yv=0;
					else if (yv < height - flipAnimation.height)
						yv=height - flipAnimation.height;
					flipAnimation.y=yv;
					break;
				case TouchPhase.ENDED:
					var upPoint:Point=new Point(t.globalX, t.globalY);
					var distance:Number=Point.distance(downPoint, upPoint) / scale;
					if (distance < 10)
					{
						upPoint=flipAnimation.globalToLocal(upPoint);
						trace('up point:', upPoint);
						for (var i:int; i < areas.length; i++)
						{
							var r:Rectangle=areas[i];
							if (r.contains(upPoint.x, upPoint.y))
							{
								if (changing)
									return;
//								&& MC.instance.moduleIndex == i
								if (!SOService.instance.isModuleCompleted(from))
								{
									changing=true;
									from=i;
									showKing();
//									TweenPlugin.activate([TransformAroundCenterPlugin]);
//									king.scaleX=king.scaleY=1.5;
									king.alpha=0;
									TweenLite.to(king, 0.8, {alpha: 1, onComplete: function():void
									{
										TweenLite.delayedCall(0.8, function():void
										{
											clear(2);
											MC.instance.gotoModule(i);
										});
									}});
								}
								else if (i != from)
								{
									changing=true;
									to=i;
									moveKing(2);
								}
								break;
							}
						}
					}
					break;
//					if (flipAnimation.y > 0)
//					{
//						toy=0;
//						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
//					}
//					else if (flipAnimation.y < height - flipAnimation.height)
//					{
//						toy=height - flipAnimation.height;
//						TweenLite.to(flipAnimation, 0.3, {y: toy, ease: Cubic.easeOut});
//					}
//					break;
			}
		}

		private var enableClose:Boolean;

		public function show(ec:Boolean):void
		{
			visible=true;
			enableClose=ec;
//			closeButton.visible=ec;
			TweenLite.killTweensOf(flipAnimation);
			flipAnimation.y=0;
			flipAnimation.height=height;
			flipAnimation.playAnimation();
		}
	}
}
