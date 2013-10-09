package views.global.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import controllers.MC;

	import models.Const;
	import models.SOService;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;
	import starling.utils.formatString;

	import views.components.ElasticButton;
	import views.components.FlipAnimation;
	import views.components.LionMC;
	import views.components.Prompt;
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

		public function Map(from:int=-1, to:int=-1)
		{
			this.viewContainer=new Sprite();
			this.from=from;
			this.to=to;
//			hotspots=[new Rectangle(333, 476, 64, 36), new Rectangle(314, 516, 104, 38)];
//			points=[new Point(365, 495), new Point(365, 535)];
			super(new AssetManager(), Const.WIDTH, Const.HEIGHT);
			var f:File=File.applicationDirectory.resolvePath('assets/global/map');
			var f2:File=File.applicationDirectory.resolvePath("assets/common");
			assetManager.enqueue(f2, f, "json/map.json", "assets/global/userCenter/page_left.png");
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
					king.visible=false;
				}
			});
			sos=SOService.instance;
			mc=MC.instance;
		}

		private var centerPoint:Dictionary;
		private var tasks:Dictionary;

		private function parseData():void
		{
			hotspots=[];
			points=[];
			labels=[];
			centerPoint=new Dictionary();
			tasks=new Dictionary();
			var hp:Array=mapData.hotspots;

			for each (var hotspot:Object in hp)
			{
				var rect:Rectangle=getRectFromArray(hotspot.rect as Array);
				hotspots.push(rect);
				var p:Point=getCenterFromRect(rect);
				points.push(p);
				var gt:Array=hotspot['goto'];
				if (gt)
				{
					centerPoint[gt[0]]=p;
					tasks[gt[0]]=hotspot.task;
				}
				var type:int=hotspot.type;
				if (type)
					typeArr[type - 1].push(p);
			}
		}

		private var typeArr:Array=[[], [], [], [], []];

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
			closeButton.visible=showFromCenter;
		}

		public static var map:Map;
		public static var callback:Function;
		public static var parent:Sprite;
		public var from:int;
		public var to:int;
		public var points:Array;
		private var labels:Array;

		/**
		 * 显示地图
		 * @param callback 关闭后的回调函数，默认在动画播放完后调用，用以加载模块素材。如若回调函数有参数，则返回0表示动画播放完成，返回1表示直接关闭，返回2表示选择场景后自动关闭
		 * @param from 	   当前模块
		 * @param to   	   转向模块
		 */
		public static function show(callback:Function=null, from:int=-1, to:int=-1, fromCenter:Boolean=false):void
		{
			MC.instance.hideMC();
			showFromCenter=fromCenter;
			var ec:Boolean=true;
			if (from || to || callback == null)
				ec=false;
			Map.callback=callback;
			if (map)
			{
				map.from=from;
				map.to=to;
				map.show(ec, !(from || to), fromCenter);
				parent.setChildIndex(map, parent.numChildren - 1);
			}
			else
			{
				var m:Map=new Map(from, to);
				parent.addChild(m);
				map=m;
			}
		}

		private static var showFromCenter:Boolean;

		private function closeTriggeredHandler():void
		{
			trace('close');
			clear(1);
		}

		private function clear(status:int):void
		{
//			this.removeFromParent(true);
//			stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			visible=false;
			closeButton.visible=false;
			changing=false;
			if (!callback)
				return;
			if (callback.length)
				callback(status);
			else
				callback();
			callback=null;
			king.visible=false;
			for (var key:* in showingHint)
			{
				delete showingHint[key];
			}
		}

		private function bgLoadedHandler(b:Bitmap):void
		{
			flipAnimation=new FlipAnimation(b, 4, 3);
			flipAnimation.backcover=assetManager.getTexture('page_left');
			flipAnimation.addEventListener('completed', flipedHandler);
			flipAnimation.width=width;
			flipAnimation.height=height;
			addChild(flipAnimation);

			flipAnimation.addChild(king);
			initCloseButton();
		}

		override public function dispose():void
		{
			if (stage)
				stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			super.dispose();
			trace('disposed');
		}

		private function positionKing(kingPoint:Point):void
		{
//			var kingPoint:Point=points[index];
			if (!king.parent)
				flipAnimation.addChild(king);
			king.parent.setChildIndex(king, king.parent.numChildren - 1);
			trace(king.parent.numChildren);
			king.visible=true;
			king.x=kingPoint.x;
			king.y=kingPoint.y;
		}

		public var isTask:Boolean=true;
		private var sunPosArr:Array=[new Point(949, 39), new Point(863, 22), new Point(713, 7), new Point(554, 0), new Point(217, 10), new Point(-200, 50)];

		private function flipedHandler(e:Event):void
		{
			if (king && centerPoint[from])
				positionKing(centerPoint[from]);
			TweenLite.to(flipAnimation, 1.5, {x: 0, scaleX: 1, scaleY: 1, onComplete: function():void
			{
				closeButton.visible=showFromCenter;
				addEventListener(TouchEvent.TOUCH, touchHandler);
				resetSun();
				TweenLite.to(flipAnimation, 8, {delay: 1, y: 0, ease: Cubic.easeOut});
			}});
			var i:int=to == -1 ? 0 : to;
			if (hasTask || mc.moduleIndex == -1)
			{
				trace('开始任务：' + tasks[i]);
				LionMC.instance.say(tasks[i], int(Math.random() * 4));
				if (!sos.isModuleCompleted(i))
					showTaskHint(i);
			}

			if (!lockHolder)
			{
				lockHolder=new Sprite();
				flipAnimation.addChild(lockHolder);
				lockHolder.touchable=false;
			}
			resetLockHolder();

			if (!callback)
				return;
			if (callback.length)
				callback(0);
			else
				callback();
		}

		/**
		 * 模块未完成,现实任务位置提示
		 * 分睡觉,读书,上朝等
		 * */
		private function showTaskHint(i:int):void
		{
			if (!typeHolder)
			{
				typeHolder=new Sprite();
				flipAnimation.addChild(typeHolder);
				typeHolder.touchable=false;
			}
			resetTypeHolder(i);
		}

		private function clearTaskHint():void
		{
			for each (var i:Image in tashHintArr)
			{
				i.removeFromParent(true);
			}
		}

		private var tashHintArr:Array=[];

		private var downPoint:Point;
		private var downY:Number;
		private var king:Image;
		private var changing:Boolean;
		private var closeButton:ElasticButton;

		private function touchHandler(e:TouchEvent):void
		{
			var t:Touch=e.getTouch(stage);
			var item:Object;
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
					if (!downPoint)
						return;
					toy=p.y - downPoint.y;
					var yv:Number=downY + toy / scale;
					if (yv > 0)
						yv=0;
					else if (yv < height - flipAnimation.height)
						yv=height - flipAnimation.height;
					flipAnimation.y=yv;
					break;
				case TouchPhase.ENDED:
					if (!downPoint)
						return;
					var upPoint:Point=new Point(t.globalX, t.globalY);
					var distance:Number=Point.distance(downPoint, upPoint) / scale;
					if (distance < 10)
					{
						if (changing)
							return;
						upPoint=flipAnimation.globalToLocal(upPoint);
						trace('up point:', upPoint);
						for (var i:int; i < hotspots.length; i++)
						{
							var r:Rectangle=hotspots[i];
							if (r.contains(upPoint.x, upPoint.y))
							{
								drawRect(r);

								item=mapData.hotspots[i];
								trace('Contains:', item);

								var moduleIndex:int=item['goto'] ? item['goto'][0] : -1;
								var mcModuleIndex:int=MC.instance.moduleIndex;
								var top:Point=centerPoint[moduleIndex];
								if (moduleIndex != -1)
									resetSun(mcModuleIndex, moduleIndex)
								if (moduleIndex != -1 && mcModuleIndex == moduleIndex)
								{
									if (!hasTask)
									{
										showKing(getCenterFromRect(r), function():void
										{
											clear(2);
										});
									}
									else
									{
										TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
										{
											clear(2);
											MC.instance.gotoModule(moduleIndex);
										}});
									}
								}
								else
								{
									if (showingHint[item.tip])
										return;
									if (moduleIndex != -1)
										changing=true;
									showHint(upPoint.x, upPoint.y, item.tip, 1, flipAnimation, upPoint.x > 900 ? 3 : 1, function():void
									{
										delete showingHint[item.tip];
//										if (sos.isModuleCompleted(moduleIndex))
										if (moduleIndex != -1)
										{
//											if (mcModuleIndex != -1 && mcModuleIndex != moduleIndex)
//												return;
											if (king.visible)
											{
												TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
												{
													clear(2);
													MC.instance.gotoModule(moduleIndex);
												}});
											}
											else
											{
												showKing(getCenterFromRect(r), function():void
												{
													TweenLite.delayedCall(0.8, function():void
													{
														clear(2);
														MC.instance.gotoModule(moduleIndex);
													});
												});
											}
										}
									});
								}
								break;
							}
						}
					}
					break;
			}
		}

		private function drawRect(r:Rectangle):void
		{
			if (!rectHolder)
			{
				rectHolder=new Shape();
				flipAnimation.addChild(rectHolder);
				rectHolder.touchable=false;
			}
			TweenLite.killTweensOf(rectHolder);
			rectHolder.alpha=1;
			rectHolder.graphics.clear();
			rectHolder.graphics.lineStyle(2, 0xccff66);
			rectHolder.graphics.drawRoundRect(r.x, r.y, r.width, r.height, 10);
			TweenLite.to(rectHolder, 5, {alpha: 0});
		}

		private function showKing(point:Point, callback:Function):void
		{
			positionKing(point);
			king.alpha=0;
			TweenLite.to(king, 0.8, {alpha: 1, onComplete: callback});
		}

		private var p:Prompt;

		private var showingHint:Dictionary=new Dictionary();

		private function showHint(_x:Number, _y:Number, _content:String, reg:int, _parent:Sprite, bgAlign:int=1, callbakc:Function=null):void
		{
			if (p)
				p.playHide();
			p=Prompt.showTXT(_x, _y, _content, 18, callbakc, _parent, bgAlign, true);
			showingHint[_content]=p;
		}

		private var sos:SOService;
		private var mc:MC;
		/**
		 * 是否有任务，不可跳过
		 */
		private var hasTask:Boolean;
		private var rectHolder:Shape;

		private var typeHolder:Sprite;
		private var lockHolder:Sprite;
		private var sun:Image;

		/**
		 * 地图初始化后再次显示地图
		 * @param ec EnableClose显示关闭按钮
		 * @param ea EnableAnimation播放动画
		 */
		public function show(ec:Boolean, ea:Boolean, fromCenter:Boolean):void
		{
			if (!fromCenter)
				hasTask=!ea;
			else
				hasTask=false;
			visible=true;
			TweenLite.killTweensOf(flipAnimation);
			flipAnimation.y=0;
			flipAnimation.height=height;
			if (ea)
				flipAnimation.playAnimation();
			else
				flipAnimation.animationPlayed();
			if (typeHolder)
				resetTypeHolder(to);
			if (lockHolder)
				resetLockHolder();
			if (closeButton)
				closeButton.visible=showFromCenter;
			resetSun();
		}

		/**
		 *
		 * 太阳移动
		 *
		 * */
		private function resetSun(_from:int=-1, _to:int=0):void
		{
			if (!sun)
			{
				sun=getImage("map-sun");
				flipAnimation.addChild(sun);
				sun.x=sunPosArr[0].x;
				sun.y=sunPosArr[0].y;
			}
//			sun.visible=!showFromCenter;
			TweenLite.killTweensOf(sun);
			var fp:Point=sunPosArr[Math.max(0, _from)]; //from
			var tp:Point=sunPosArr[Math.max(0, _to)]; //to
			if (fp.x == tp.x)
				return;
			else if (fp.x > tp.x) //左移
			{
				sun.x=fp.x;
				sun.y=fp.y;
				TweenLite.to(sun, 2.5, {x: tp.x, y: tp.y});
			}
			else //右移
			{
				sun.x=fp.x;
				sun.y=fp.y;
				var leftp:Point=sunPosArr[sunPosArr.length - 1];
				TweenLite.to(sun, 1.3, {x: leftp.x, y: leftp.y, onComplete: function():void
				{
					sun.x=1024;
					TweenLite.to(sun, 1.2, {x: tp.x, y: tp.y});
				}});
			}
		}

		/**
		 * 场景类型
		 * 自动切换,任务提示用
		 * */
		private function resetTypeHolder(index:int=0):void
		{
			typeHolder.visible=!showFromCenter;
			if (index < 0)
				return;
			typeHolder.removeChildren();
			var arr:Array=typeArr[index];
			for each (var p:Point in arr)
			{
				var img:Image=getImage("map-type" + (index + 1).toString());
				img.pivotX=img.width >> 1;
				img.pivotY=img.height >> 1;
				img.x=p.x;
				img.y=p.y;
				typeHolder.addChild(img);
			}
		}

		/**
		 * 场景解锁
		 * 手册进入,跳关用
		 * */
		private function resetLockHolder():void
		{
			lockHolder.visible=showFromCenter;
			lockHolder.removeChildren();
			for (var i:int=0; i < 4; i++)
			{
				if (sos.isModuleCompleted(i))
				{
					var img:Image=getImage("map-unlock" + (i + 1).toString());
					img.pivotX=img.width >> 1;
					img.pivotY=img.height >> 1;
					img.x=centerPoint[i].x;
					img.y=centerPoint[i].y;
					lockHolder.addChild(img);
				}
			}
		}
	}
}

