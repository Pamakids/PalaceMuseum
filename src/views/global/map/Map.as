package views.global.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import controllers.MC;

	import models.Const;
	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.FlipAnimation;
	import views.components.base.PalaceModule;

	/**
	 * 热点数据格式用map.json的应该就能满足所有需求
	 * "hotspots": [
		{
		  "id": "1", 				//用以记录什么热区被点击，数据分析用
		  "rect":[333,476,64,36],	//热区的矩形区域，皇帝头像默认居其中
		  "tip":"这里是乾清宫",		//点击热区后出现的提示文字
		  "goto":[0,0]  			//点击热区跳转，数组[0]为模块索引MC.instance.moduleIndex，数组[1]为场景索引
		},
		{
		  "id": "2",
		  "rect":[314,516,104,38],
		  "tip":"这里是乾清宫2",
		  "goto":[1,0]
		}
	  ],
	  "path": { 					//路径集合需要包含所有最远点通行的路径，可能几条路径即可涵盖所有点到点，类似地铁路线
		"p1":[[1,2], [3,4], [5, 6]],//地图上的行动路径，不同最远两点间需要经过的点的集合，所有点是热区矩形的中心
		"p2":[[2,3], [3,4], [7,8]]  //移动时：1.先判断路径里是否存在两个点;2.如果只有一条路径存在，则直接使用该路径，如果两条路径都存在，则自动选择最近路线
	  }
	 * @author mani
	 */
	public class Map extends PalaceModule
	{
		/*
		 * 需求：
		 * 1. 打开地图时需要了解地图打开的通道：剧情打开 or 手册中打开
		 * 2. 在剧情过场中打开地图
		 * 		隐藏标签，
		 * 		显示小皇帝头像及其所在位置，
		 * 		有寻路功能
		 * 		只在第一次打开地图时有翻页动画，其他时间翻页动画省略
		 * 3. 在手册中打开地图时
		 * 		小皇帝头像隐藏
		 * 		无寻路动画
		 * 		有翻页动画
		 * 		有已解锁的标签
		 */

		private var viewContainer:Sprite;
		private var mapData:Object;

		private var flipAnimation:FlipAnimation;
		/**
		 * 地图上不同模块或场景对应的区域
		 */
		private var hotspots:Array;

		public function Map(from:int=0, to:int=0)
		{
			this.viewContainer=new Sprite();
			this.from=from;
			this.to=to;
//			hotspots=[new Rectangle(333, 476, 64, 36), new Rectangle(314, 516, 104, 38)];
//			points=[new Point(365, 495), new Point(365, 535)];
			super(new AssetManager(), Const.WIDTH, Const.HEIGHT);
			var f:File=File.applicationDirectory.resolvePath('assets/global/map');
			assetManager.enqueue('assets/common/button_close.png', f, "json/map.json", "assets/global/userCenter/page_left.png");
			assetManager.loadQueue(function(ratio:Number):void
			{
				trace(ratio);
				if (ratio == 1)
				{
					LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
					mapData=assetManager.getObject("map");
					parseData();
					king=getImage('king');
					king.pivotX=king.width / 2;
					king.pivotY=king.height / 2;
					initCloseButton();
				}
			});
		}

		private function parseData():void
		{
			hotspots=[];
			points=[];
			var hp:Array=mapData.hotspots;
			for each (var hotspot:Object in hp)
			{
				var rect:Rectangle=getRectFromArray(hotspot.rect as Array);
				hotspots.push(rect);
				points.push(getCenterFromRect(rect));
			}
		}

		private function getCenterFromRect(rect:Rectangle):Point
		{
			return new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
		}

		private function getRectFromArray(arr:Array):Rectangle
		{
			return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
		}

		private function initCloseButton():void
		{
			var b:ElasticButton=new ElasticButton(getImage('button_close'));
			addChild(b);
			b.addEventListener(ElasticButton.CLICK, closeTriggeredHandler);
			b.x=width - b.width / 2 - 10;
			b.y=b.height / 2 + 10;
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
				map.show(ec, !(from && to));
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
			flipAnimation=new FlipAnimation(b, 4, 3);
			flipAnimation.backcover=assetManager.getTexture('page_left');
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
		private var closeButton:ElasticButton;

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
						for (var i:int; i < hotspots.length; i++)
						{
							var r:Rectangle=hotspots[i];
							if (r.contains(upPoint.x, upPoint.y))
							{
								if (changing)
									return;
								if (!SOService.instance.isModuleCompleted(from))
								{
									changing=true;
									from=i;
									showKing();
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
			}
		}

		private var enableClose:Boolean;

		/**
		 * 地图初始化后再次显示地图
		 * @param ec EnableClose显示关闭按钮
		 * @param ea EnableAnimation播放动画
		 */
		public function show(ec:Boolean, ea:Boolean):void
		{
			visible=true;
			enableClose=ec;
			TweenLite.killTweensOf(flipAnimation);
			flipAnimation.y=0;
			flipAnimation.height=height;
			if (ea)
				flipAnimation.playAnimation();
			else
				flipAnimation.animationPlayed();
		}
	}
}

