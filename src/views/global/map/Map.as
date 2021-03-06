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

	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;

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
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.PalaceStars;
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

		private var mapData:Object;

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

		public static function loadMapAssets(cb:Function=null,needBG:Boolean=false,_fromCenter:Boolean=false):void
		{
			showFromCenter=_fromCenter;
			if(cb!=null)
			{
				if(needBG)
				{
					var loading:Image=Image.fromBitmap(new PalaceModule.gameBG());
					MC.instance.main.addChild(loading);
				}else
					MC.instance.main.addMask();

				var _loadImage:Image=new Image(Texture.fromBitmap(new PalaceModule.loading()));
				_loadImage.pivotX=_loadImage.width >> 1;
				_loadImage.pivotY=_loadImage.height >> 1;
				MC.instance.main.addChild(_loadImage as Image);
				_loadImage.x=1024/2;
				_loadImage.y=768/2;
				_loadImage.scaleX=_loadImage.scaleY=.5;
				_loadImage.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					_loadImage.rotation+=0.2;
				});
			}
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

					if(needBG)
					{
						loading.removeFromParent(true);
					}
					if(cb!=null)
					{
						_loadImage.removeFromParent(true);
						MC.instance.main.removeMask();
						cb();
					}
				}
			});
		}

		private var rectDic:Dictionary=new Dictionary();

		public function Map(from:int=-1, to:int=-1)
		{
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
			mapData=Map.assetManager.getObject("map");
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
					if (gt[0] == 2)
						p=new Point(p.x + 45, p.y)
					centerPoint[gt[0]]=p;
					tasks[gt[0]]=hotspot.task;
					rectDic[gt[0]]=rect;

				}
				var type:int=hotspot.type;
				if (type)
					typeArr[type - 1].push(p);
			}
		}

		override protected function getImage(name:String):Image
		{
			var t:Texture;
			if (MC.assetManager)
				t=MC.assetManager.getTexture(name);
			if (!t && Map.assetManager)
				t=Map.assetManager.getTexture(name)
			if (t)
				return new Image(t);
			else
				return null;
		}

		private var hintRect:Shape;

		private function blinkHint():void
		{
			flipAnimation.setChildIndex(hintRect,numChildren-1);
			TweenLite.to(hintRect,1,{alpha:1,onComplete:function():void{
				TweenLite.to(hintRect,1,{alpha:0,onComplete:blinkHint});
			}});
		}

		private function initHint(r:Rectangle):void
		{
			hintRect=new Shape();
			flipAnimation.addChild(hintRect);
			hintRect.graphics.lineStyle(4, 0x00ffff);
			hintRect.graphics.drawRoundRect(r.x-3, r.y-3, r.width+6, r.height+6, 10);
			hintRect.graphics.endFill();
			hintRect.alpha=0;

			TweenLite.delayedCall(13,blinkHint);
		}

		private function getPointFromArr(arr:Array):Point
		{
			if (arr)
				return new Point(arr[0], arr[1]);
			else
				return null;
		}

		private var typeArr:Array=[[], [], [], [], [],[]];

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
		public static function show(from:int=-1, to:int=-1, _fromCenter:Boolean=false, _buttonShow:Boolean=false):void
		{
			showFromCenter=_fromCenter;
			initTime=getTimer();
			if (!showFromCenter)
			{
				SoundAssets.playBGM("mapbgm");
			}
			buttonShow=_buttonShow;
			var msIndex:String=SOService.instance.getSO("lastScene") as String;
			if (!msIndex)
				msIndex="11map";
			else
			{
				if (!showFromCenter && to >= 0)
				{
					var _to:int=to;
					if(_to==0)
						_to=0;
					else if(_to==1)
						_to=5;
					else
						_to--;
					msIndex=(_to + 1).toString() + "1map";
				}
				else if (msIndex.lastIndexOf("map") < 0)
					msIndex=msIndex + "map";
			}
			if (!showFromCenter)
				SOService.instance.setSO("lastScene", msIndex);
			MC.instance.hideMC();
			if (showFromCenter)
				MC.instance.switchWOTB();
//			var ec:Boolean=true;
//			if (from || to || callback == null)
//				ec=false;
//			if (map)
//			{
//				map.from=from;
//				map.to=to;
//				map.show(ec, !(from || to), fromCenter);
//				parent.setChildIndex(map, parent.numChildren - 1);
//			}
//			else
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
			if(hintRect)
			{
				TweenLite.killTweensOf(hintRect);
				hintRect.removeFromParent(true);
				hintRect=null;
			}
			TweenLite.killTweensOf(blinkHint);
			removeEventListener(Event.ENTER_FRAME, onScrolling);
			if (initTime > 0)
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, "map");
				initTime=-1;
				taskInitTime=-1;
			}
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

			if (rectHolder)
			{
				TweenLite.killTweensOf(rectHolder);
				rectHolder.removeFromParent(true);
				rectHolder=null;
			}

			var msIndex:String=SOService.instance.getSO("lastScene") as String;
			if (msIndex && msIndex.lastIndexOf("map") >= 0)
				SOService.instance.setSO("lastScene", msIndex.substr(0, 2));

			visible=false;
			if(closeButton)
				closeButton.visible=false;
			changing=false;

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
			if(king)
				king.visible=false;
			for (var key:* in showingHint)
			{
				delete showingHint[key];
			}

			if(Map.assetManager)
				Map.assetManager.purge();
			removeFromParent(true);
			Map.assetManager=null;
		}

		override protected function onStage(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		private function initFlipAnimation():void
		{
			scroller=new ScrollContainer();
			var lo:VerticalLayout=new VerticalLayout();
			lo.gap=0;
			lo.horizontalAlign=VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			scroller.layout=lo;
			scroller.width=1024 + 300;
			scroller.height=768 + 20;

			flipAnimation=new Sprite();
			flipAnimation.addChildAt(getImage("mapBG"), 0);
			positionKing();

			top=getImage("mapTop");
			botttom=getImage("mapBotton");

			addChild(top);
			scroller.addChild(flipAnimation);
			addChild(botttom);

			addChild(scroller);

			topH=top.height;
			mapH=1344;
			bottomH=botttom.height;
			scroller.elasticity=.22

			flipedHandler();
		}

		private var pt:Point=new Point();

		private function onScrolling(e:Event):void
		{
			if (scroller && top && botttom)
			{
				var vp:Number=-scroller.verticalScrollPosition
				vp=this.globalToLocal(flipAnimation.localToGlobal(pt)).y;
				top.y=vp - topH + 10;
				botttom.y=vp + mapH - 10;
			}
		}

		private var topH:Number;
		private var mapH:Number;
		private var bottomH:Number;

		override public function dispose():void
		{
			if (sun)
			{
				sun.stop();
				sun.removeFromParent(true);
				Starling.juggler.remove(sun);
			}
			removeEventListener(TouchEvent.TOUCH, touchHandler);
			removeChildren(0,-1,true);
		}

		private function positionKing(kingPoint:Point=null):void
		{
			if (!king)
			{
				king=getImage('king');
				king.pivotX=king.width / 2;
				king.pivotY=king.height / 2;
			}
			flipAnimation.addChildAt(king, flipAnimation.numChildren);
			if (kingPoint)
			{
				if (!showFromCenter && from == 4 && gardenPt)
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
			var mcI:int=mc.moduleIndex;

			var comFunc:Function=function():void
			{
				initCloseButton();
				if (!showFromCenter){
					TopBar.show();
					mc.switchLayer(false);
					scroller.scrollToPosition(0, 0, 5);
				}
				addEventListener(TouchEvent.TOUCH, touchHandler);
				positionSun(showFromCenter ? mcI : from);
			};
			if(showFromCenter)
			{
				positionKing(centerPoint[mcI]);
				addEventListener(TouchEvent.TOUCH, touchHandler);
				comFunc();
				return;
			}
			scroller.verticalScrollPosition=mapH - 768;
			addEventListener(Event.ENTER_FRAME, onScrolling);
			if (MC.needGuide)
			{
				if(guideStep==0)
					showGuide1();
				else
					showGuide2();
				return;
			}
			var lionSay:Function=function():void
			{
				var i:int=to == -1 ? 0 : to;
				if (!showFromCenter)
				{
					to=i;
					initHint(rectDic[to]);
					taskInitTime=getTimer();
					LionMC.instance.say(tasks[i], 3, 0, 0, comFunc, 20, true);
					showTaskHint(i);
				}
				else
					comFunc();
			};
			if(!showFromCenter)
				lionSay();

			positionKing(centerPoint[showFromCenter ? mc.moduleIndex : from]);
		}

		private function showGuide1():void
		{
			guideStep++;
			scroller.scrollToPosition(0, 0, 5);
			TweenLite.delayedCall(5, function():void {
				TweenLite.delayedCall(4,MC.instance.stage.addClickHint);
				LionMC.instance.say("我就是神通广大的小狮子。我们现在先去“用户中心”看看吧！", 0, 0, 0, function():void {
					MC.instance.stage.removeClickHint();
					TopBar.instance.visible=true;
					TopBar.instance.showBookAndAvatar(false);
					MC.instance.addGuide(6, function():void {
						TopBar.instance.avatarClickedHandler();
						map.clear(0);
					});
				}, 20, true, 10);
			});
		}

		private static var guideStep:int=0;

		private function showGuide2():void
		{
			scroller.scrollToPosition(0, 0, 5);
			TweenLite.delayedCall(5, function():void {
				TweenLite.delayedCall(4,MC.instance.stage.addClickHint);
				LionMC.instance.say("我们接下来学习使用《皇帝速成手册》，遇到问题随时找我！", 0, 0, 0, function():void {
					MC.instance.stage.removeClickHint();
					TopBar.instance.visible=true;
					TopBar.instance.showBookAndAvatar(false);
					MC.instance.addGuide(1, function():void {
						TopBar.instance.bookClickedHandler();
						map.clear(0);
					});
				}, 20, true, 10);
			});
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
			var t:Touch=e.getTouch(this);
			var item:Object;
			if (!t)
				return;
			var p:Point=t.getLocation(this);
			var toy:Number;
			switch (t.phase)
			{
				case TouchPhase.BEGAN:
					downPoint=p;
					break;
				case TouchPhase.ENDED:
					if (!downPoint)
						return;
					var upPoint:Point=p;
					var distance:Number=Point.distance(downPoint, upPoint);
					if (distance < 10)
					{
						if (changing)
							return;
						upPoint=flipAnimation.globalToLocal(this.localToGlobal(upPoint));
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
										}
										else
										{
											showKing(getCenterFromRect(r), null);
										}

										new PalaceStars(p.x,p.y,this);
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
				rectHolder.touchable=false;
			}
			flipAnimation.addChildAt(rectHolder, flipAnimation.numChildren);
			TweenLite.killTweensOf(rectHolder);
			rectHolder.alpha=1;
			rectHolder.graphics.clear();
			rectHolder.graphics.lineStyle(2, 0x00ffff);
			rectHolder.graphics.drawRoundRect(r.x, r.y, r.width, r.height, 10);
			TweenLite.to(rectHolder, 3, {alpha: 0});
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
			flipedHandler();
			if (typeHolder)
				resetTypeHolder(to);
			initCloseButton();
		}

		private function positionSun(_index:int):void
		{
			_index=_index > 0 ? _index : 0;

			if(_index==1)
				_index=1;
			else if(_index>1)
				_index=_index-1;

			if (!sun)
			{
				sun=new MovieClip(Map.assetManager.getTextures("sun"), .5);
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

		private var scroller:ScrollContainer;

		private var top:Image;

		private var botttom:Image;

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

			var t:int;
			if(_to<=0)
				t=0;
			else if(_to==1)
				t=1;
			else if(_to>1)
				t=_to-1;

//			t++;

			desSky=getImage("sky" + (t+1).toString());
			flipAnimation.addChildAt(desSky, 1);
			desSky.alpha=0;
			TweenLite.to(desSky, 2.3, {alpha: 1});

			TweenLite.killTweensOf(sun);
			var tp:Point=sunPosArr[Math.max(0, t)]; //to
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
	}
}

