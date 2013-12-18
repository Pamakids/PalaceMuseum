package views.global.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.Const;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceModule;
	import views.global.TailBar;
	import views.global.TopBar;
	import views.global.books.BooksManager;

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

//		private var flipAnimation:FlipAnimation;
		private var flipAnimation:Sprite;
		/**
		 * 地图上不同模块或场景对应的区域
		 */
		private var hotspots:Array;

		public static var assetManager:AssetManager;

		private static var loaded:Boolean=false;

		private static var initTime:int=-1;
		private static var disposeTime:int=-1;
		private static var taskInitTime:int=-1;
		private static var sceneOverTime:int=-1;

		public static function loadAssets():void
		{
			if (!assetManager)
				assetManager=new AssetManager();
			var f:File=File.applicationDirectory.resolvePath('assets/global/map');
			assetManager.enqueue(f, "json/map.json");
			assetManager.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1)
				{
					trace("Map loaded!");
					loaded=true;
					if (map)
						map.init();
				}
			});
		}

		public function Map(from:int=-1, to:int=-1)
		{
			this.viewContainer=new Sprite();
			this.from=from;
			this.to=to;
			super(Map.assetManager, Const.WIDTH, Const.HEIGHT);
			sos=SOService.instance;
			mc=MC.instance;
			map=this;
			if (loaded)
				init();
		}

		override protected function init():void
		{
			mapData=assetManager.getObject("map");
			if (mapData)
				parseData();
			initFlipAnimation();
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
				var offset:Point=getPointFromArr(hotspot.offset as Array);
				hotspots.push(rect);
				var p:Point=getCenterFromRect(rect, offset);
				points.push(p);
				if (hotspot["id"] == "9")
					gardenPt=p;
				var gt:Array=hotspot['goto'];
				if (gt)
				{
					if (gt[0] == 1)
						p=new Point(p.x + 45, p.y)
					centerPoint[gt[0]]=p;
					tasks[gt[0]]=hotspot.task;
				}
				var type:int=hotspot.type;
				if (type)
					typeArr[type - 1].push(p);
			}
		}

		private function getPointFromArr(arr:Array):Point
		{
			if (arr)
				return new Point(arr[0], arr[1]);
			else
				return null;
		}

		private var typeArr:Array=[[], [], [], [], []];

		private function getCenterFromRect(rect:Rectangle, offset:Point=null):Point
		{
			if (offset)
				return new Point(rect.x + rect.width / 2 + offset.x, rect.y + rect.height / 2 + offset.y);
			else
				return new Point(rect.x + rect.width / 2, rect.y + rect.height / 2);
		}

		private function getRectFromArray(arr:Array):Rectangle
		{
			return new Rectangle(arr[0], arr[1], arr[2], arr[3]);
		}

		private function initCloseButton():void
		{
			if (!closeButton)
			{
				closeButton=new ElasticButton(getImage('button_close'));
				closeButton.shadow=getImage("button_close_down");
				addChild(closeButton);
				closeButton.addEventListener(ElasticButton.CLICK, closeTriggeredHandler);
				closeButton.x=width - closeButton.width / 2 - 10;
				closeButton.y=closeButton.height / 2 + 10;
			}
			closeButton.visible=buttonShow;
		}

		public static var map:Map;
		public static var parent:Sprite;
		public var from:int;
		public var to:int;
		public var points:Array;
		private var labels:Array;
		private static var buttonShow:Boolean;

		/**
		 * 显示地图
		 * @param callback 关闭后的回调函数，默认在动画播放完后调用，用以加载模块素材。如若回调函数有参数，则返回0表示动画播放完成，返回1表示直接关闭，返回2表示选择场景后自动关闭
		 * @param from 	   当前模块
		 * @param to   	   转向模块
		 */
		public static function show(callback:Function=null, from:int=-1, to:int=-1, fromCenter:Boolean=false, _buttonShow:Boolean=false):void
		{
			initTime=getTimer();
			if (!fromCenter)
			{
				SoundAssets.playBGM("mapbgm");
			}
			buttonShow=_buttonShow;
			var msIndex:String=SOService.instance.getSO("lastScene") as String;
			if (!msIndex)
				msIndex="11map";
			if (!fromCenter && to >= 0)
				msIndex=(to + 1).toString() + "1map";
			else if (msIndex.lastIndexOf("map") < 0)
				msIndex=msIndex + "map";
			if (!fromCenter)
				SOService.instance.setSO("lastScene", msIndex);
			MC.instance.hideMC();
			if (fromCenter)
				MC.instance.switchWOTB();
			showFromCenter=fromCenter;
			var ec:Boolean=true;
			if (from || to || callback == null)
				ec=false;
			if (map)
			{
				map.from=from;
				map.to=to;
				map.show(ec, !(from || to), fromCenter);
//				parent.setChildIndex(map, parent.numChildren - 1);
			}
			else
			{
				var m:Map=new Map(from, to);
				parent.addChild(m);
			}
		}

		private static var showFromCenter:Boolean;

		private function closeTriggeredHandler(e:Event):void
		{
			if (changing)
				return;
			clear(0);
		}

		/**
		 * @param 0:关闭地图 1:关闭地图和用户中心 2:关闭地图和用户中心,切换模块
		 *
		 * */
		public function clear(status:int=0):void
		{
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, "map");
				initTime=-1;
				taskInitTime=-1;
			}
//			if (!showFromCenter)
//			{
//				SoundAssets.playBGM("main");
//			}
			if (preSky)
			{
				TweenLite.killTweensOf(preSky);
				preSky.removeFromParent(true);
				preSky=null;
			}
			if (desSky)
			{
				TweenLite.killTweensOf(desSky);
				desSky.removeFromParent(true);
				desSky=null;
			}

			var msIndex:String=SOService.instance.getSO("lastScene") as String;
			if (msIndex && msIndex.lastIndexOf("map") >= 0)
				SOService.instance.setSO("lastScene", msIndex.substr(0, 2));

			visible=false;
			closeButton.visible=false;
			changing=false;
//			if (UserCenterManager.getCrtUserCenter() != null)
//				MC.instance.switchLayer(false);
//			else
//			{
//				TopBar.show();
//			}
			switch (status)
			{
				case 0:
				{
					break;
				}

				case 1:
				{
					BooksManager.closeCtrBook();
					break;
				}

				case 2:
				{
					BooksManager.closeCtrBook();
					break;
				}

				default:
				{
					break;
				}
			}
			king.visible=false;
			for (var key:* in showingHint)
			{
				delete showingHint[key];
			}
		}

		override protected function onStage(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		private function initFlipAnimation():void
		{
//			flipAnimation=new FlipAnimation(assetManager.getTexture("mapBG"), 4, 3);
//			flipAnimation.backcover=assetManager.getTexture('map_back');
//			flipAnimation.addEventListener('completed', flipedHandler);
//			flipAnimation.width=width;
//			flipAnimation.height=height;
//			addChild(flipAnimation);

			flipAnimation=new Sprite();
			flipAnimation.addChildAt(getImage("mapBG"), 0);
			addChild(flipAnimation);
			positionKing();
			flipedHandler();
			flipAnimation.y=-460.8;
		}

		override public function dispose():void
		{
			if (sun)
			{
				sun.stop();
				sun.removeFromParent(true);
				Starling.juggler.remove(sun);
			}
			removeEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private function positionKing(kingPoint:Point=null):void
		{
			if (!king)
			{
				king=getImage('king');
				king.pivotX=king.width / 2;
				king.pivotY=king.height / 2;
//				flipAnimation.addChild(king);
			}
			flipAnimation.addChildAt(king, flipAnimation.numChildren);
			if (kingPoint)
			{
				if (!showFromCenter && from == 3 && gardenPt)
					kingPoint=gardenPt;
				king.visible=true;
				king.x=kingPoint.x;
				king.y=kingPoint.y;
			}
			else
			{
				king.visible=false;
			}
		}

		public var isTask:Boolean=true;
		private var sunPosArr:Array=[new Point(949, 39), new Point(863, 22), new Point(713, 7), new Point(554, 0), new Point(217, 10), new Point(-200, 50)];

		private function flipedHandler(e:Event=null):void
		{
			if (MC.needGuide)
			{
//				LionMC.instance.say("先进入手册看看吧！", 0, 0, 0, showGuide);
				showGuide();
				return;
			}
			var comFunc:Function=function():void
			{
				initCloseButton();
//				MC.instance.switchLayer(true);
				if (!showFromCenter)
					TopBar.show();
				mc.switchLayer(false);
//				if (showCenterBtn != null)
//					showCenterBtn();
				addEventListener(TouchEvent.TOUCH, touchHandler);
				positionSun(showFromCenter ? mc.moduleIndex : from);
				TweenLite.to(flipAnimation, 5, {delay: 1, y: 0, ease: Cubic.easeOut});
			};
			var lionSay:Function=function():void
			{
				var i:int=to == -1 ? 0 : to;
				if (!showFromCenter)
				{
					to=i;
					taskInitTime=getTimer();
					LionMC.instance.say(tasks[i], 3, 0, 0, comFunc, 20, 1, true);
					showTaskHint(i);
				}
				else
					comFunc();
			};
			if (flipAnimation.scaleX == 1)
				lionSay();
			else
				TweenLite.to(flipAnimation, 1.5, {x: 0, scaleX: 1, scaleY: 1, onComplete: lionSay});

			if (!pathHolder)
			{
				pathHolder=new Sprite();
				flipAnimation.addChild(pathHolder);
				pathHolder.touchable=false;
			}
			resetDrawPath();

//			if (!lockHolder)
//			{
//				lockHolder=new Sprite();
//				flipAnimation.addChild(lockHolder);
//				lockHolder.touchable=false;
//			}
//			resetLockHolder();
			positionKing(centerPoint[showFromCenter ? mc.moduleIndex : from]);
		}

		private function showGuide():void
		{
			TweenLite.to(flipAnimation, 5, {delay: 1, y: 0, ease: Cubic.easeOut, onComplete: function():void {
				LionMC.instance.say("我就是神通广大的小石狮子。我们先来学习使用《皇帝速成手册》，遇到问题随时找我！", 0, 0, 0, function():void {
					TopBar.instance.showBookAndAvatar(false);
					MC.instance.addGuide(1, function():void {
						TopBar.instance.bookClickedHandler();
					});
				}, 20, .6, true, 30);
			}});
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
//						trace('up point:', upPoint);
						for (var i:int; i < hotspots.length; i++)
						{
							var r:Rectangle=hotspots[i];
							if (r.contains(upPoint.x, upPoint.y))
							{
								drawRect(r);

								item=mapData.hotspots[i];
//								trace('Contains:', item);

								var targetIndex:int=item['goto'] ? item['goto'][0] : -1;
								var crtIndex:int=MC.instance.moduleIndex;
								var top:Point=centerPoint[targetIndex];

								if (targetIndex != -1)
								{
									if (showFromCenter)
									{
										changing=false;
//										if (targetIndex == crtIndex)
//										{
//											clear(1);
//											return;
//										}
//										else if (sos.isModuleCompleted(targetIndex))
//										{
//											moveSun(crtIndex, targetIndex);
//											changing=true;
//										}
									}
									else
									{
										if (to == targetIndex)
										{
											moveSun(crtIndex, targetIndex);
											changing=true;
										}
									}

									if (changing)
									{
										closeButton.visible=false;
										TopBar.hide();
										TailBar.hide();
										if (king.visible)
										{
											flipAnimation.setChildIndex(king, flipAnimation.numChildren - 1);
											TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut});
											drawPath(king.x, king.y, top.x, top.y, 1.8);
										}
										else
										{
											showKing(getCenterFromRect(r), null);
										}
									}
								}

								if (!showingHint[item.tip])
								{
									if (changing)
										showFinalHint(upPoint.x, upPoint.y < 156 ? 156 : upPoint.y, item.tip, 1, flipAnimation, upPoint.x > 800 ? 3 : 1,
													  function():void
													  {
														  delete showingHint[item.tip];
														  clear(0);
														  MC.instance.gotoModule(targetIndex);
													  });
									else
										showHint(upPoint.x, upPoint.y < 156 ? 156 : upPoint.y, item.tip, 1, flipAnimation, upPoint.x > 800 ? 3 : 1,
												 function():void
												 {
													 delete showingHint[item.tip];
												 });
									UserBehaviorAnalysis.trackEvent("click", "mapArea", "", int(item.id));
								}

//								if (targetIndex != -1 && crtIndex == targetIndex)
//								{
//									if (!hasTask)
//									{
//										showKing(getCenterFromRect(r), function():void
//										{
//											clear(2);
//										});
//									}
//									else
//									{
//										TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
//										{
//											clear(2);
//											MC.instance.gotoModule(targetIndex);
//										}});
//									}
//								}
//								else
//								{
//									if (showingHint[item.tip])
//										return;
//									if (targetIndex != -1)
//										changing=true;
//									showHint(upPoint.x, upPoint.y, item.tip, 1, flipAnimation, upPoint.x > 900 ? 3 : 1, function():void
//									{
//										delete showingHint[item.tip];
////										if (sos.isModuleCompleted(moduleIndex))
//										if (targetIndex != -1)
//										{
////											if (mcModuleIndex != -1 && mcModuleIndex != moduleIndex)
////												return;
//											if (king.visible)
//											{
//												TweenLite.to(king, 1.8, {x: top.x, y: top.y, ease: Cubic.easeOut, onComplete: function():void
//												{
//													clear(2);
//													MC.instance.gotoModule(targetIndex);
//												}});
//											}
//											else
//											{
//												showKing(getCenterFromRect(r), function():void
//												{
//													TweenLite.delayedCall(0.8, function():void
//													{
//														clear(2);
//														MC.instance.gotoModule(targetIndex);
//													});
//												});
//											}
//										}
//									});
//								}
								break;
							}
						}
					}
					break;
			}
		}

		private function drawPath(x1:Number, y1:Number, x2:Number, y2:Number, time:Number):void
		{
//			var totalCount:int=time * 30;
//			var count:int=0;
//			drawingPath.graphics.clear();
//			drawingPath.graphics.lineStyle(3, 0x66ccff);
//			drawingPath.graphics.moveTo(x1, y1);
//			drawingPath.addEventListener(Event.ENTER_FRAME,
//				function(e:Event):void {
//					if (count < totalCount && visible)
//					{
//						count++;
//						var d:Number=count / totalCount;
//						var dx:Number=(x2 - x1) * d + x1;
//						var dy:Number=(y2 - y1) * d + y1;
//						drawingPath.graphics.lineTo(dx, dy);
//					}
//				});
		}

		private function resetDrawPath():void
		{
//			if (!drawingPath)
//			{
//				drawingPath=new Shape();
//				pathHolder.addChild(drawingPath);
//			}
//			drawingPath.graphics.clear();
		}

//		private var drawingPath:Shape;
//		private var path:Shape;

		private function drawRect(r:Rectangle):void
		{
			if (!rectHolder)
			{
				rectHolder=new Shape();
//				flipAnimation.addChild(rectHolder);
				rectHolder.touchable=false;
			}
			flipAnimation.addChildAt(rectHolder, flipAnimation.numChildren);
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

		private function showFinalHint(_x:Number, _y:Number, _content:String, reg:int, _parent:Sprite, bgAlign:int=1, callbakc:Function=null):void
		{
			if (taskInitTime > 0)
			{
				sceneOverTime=getTimer();
				UserBehaviorAnalysis.trackTime("taskTime", sceneOverTime - taskInitTime, "map");
				taskInitTime=-1;
			}
			if (p2)
				p2.playHide();
			p2=Prompt.showTXT(_x, _y, _content, 18, callbakc, _parent, bgAlign, true);
			showingHint[_content]=p2;
		}

		private var p2:Prompt;

		private var sos:SOService;
		private var mc:MC;
		/**
		 * 是否有任务，不可跳过
		 */
		private var hasTask:Boolean;
		private var rectHolder:Shape;

		private var typeHolder:Sprite;
		private var lockHolder:Sprite;
		private var pathHolder:Sprite;
		private var sun:MovieClip;
		private var gardenPt:Point;

		/**
		 * 地图初始化后再次显示地图
		 * @param ec EnableClose显示关闭按钮
		 * @param ea EnableAnimation播放动画
		 */
		public function show(ec:Boolean, ea:Boolean, fromCenter:Boolean):void
		{
			changing=false;
			if (!fromCenter)
				hasTask=!ea;
			else
				hasTask=false;
			visible=true;
			TweenLite.killTweensOf(flipAnimation);
//			flipAnimation.y=showFromCenter ? 0 : -460.8;
			flipAnimation.y=-460.8;
//			flipAnimation.height=height;
			flipedHandler();
//			if (ea)
//				flipAnimation.playAnimation();
//			else
//				flipAnimation.animationPlayed();
			if (typeHolder)
				resetTypeHolder(to);
//			if (lockHolder)
//				resetLockHolder();
			initCloseButton();
//			positionSun(from);
		}

		private function positionSun(_index:int):void
		{
			_index=_index > 0 ? _index : 0;
			if (!sun)
			{
				sun=new MovieClip(assetManager.getTextures("sun"), 2);
				sun.play();
				sun.touchable=false;
				Starling.juggler.add(sun);
			}
			flipAnimation.addChildAt(sun, flipAnimation.numChildren);
			sun.x=sunPosArr[_index].x;
			sun.y=sunPosArr[_index].y;

			if (preSky)
			{
				TweenLite.killTweensOf(preSky);
				preSky.removeFromParent(true);
				preSky=null;
			}
			preSky=getImage("sky" + (_index + 1).toString());
			preSky.alpha=0;
			TweenLite.to(preSky, .3, {alpha: 1});
			flipAnimation.addChildAt(preSky, 1);
		}

		private var preSky:Image;
		private var desSky:Image;
		public static var showCenterBtn:Function;

		/**
		 *
		 * 太阳移动
		 *
		 * */
		private function moveSun(_from:int=-1, _to:int=0):void
		{
			if (desSky)
			{
				TweenLite.killTweensOf(desSky);
				desSky.removeFromParent(true);
				desSky=null;
			}
			if (preSky)
				TweenLite.to(preSky, 2.3, {alpha: 0});

			desSky=getImage("sky" + (Math.max(0, _to) + 1).toString());
			flipAnimation.addChildAt(desSky, 1);
			desSky.alpha=0;
			TweenLite.to(desSky, 2.3, {alpha: 1});

			TweenLite.killTweensOf(sun);
			var tp:Point=sunPosArr[Math.max(0, _to)]; //to
			if (sun.x == tp.x)
				return;
			else if (sun.x > tp.x) //左移
				TweenLite.to(sun, 2.5, {x: tp.x, y: tp.y});
			else //右移
			{
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
//		private function resetLockHolder():void
//		{
//			lockHolder.visible=showFromCenter;
//			lockHolder.removeChildren();
//			for (var i:int=0; i < 5; i++)
//			{
//				if (sos.isModuleCompleted(i))
//				{
//					var img:Image=getImage("map-unlock" + (i + 1).toString());
//					img.pivotX=img.width >> 1;
//					img.pivotY=img.height >> 1;
//					img.x=centerPoint[i].x;
//					img.y=centerPoint[i].y;
//					lockHolder.addChild(img);
//				}
//			}
//			if (king)
//				flipAnimation.setChildIndex(king, flipAnimation.numChildren - 1);
//		}
	}
}

