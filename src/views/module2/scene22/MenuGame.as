package views.module2.scene22
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.utils.SPUtils;
	import com.pamakids.utils.DPIUtil;

	import flash.events.AccelerometerEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;

	import feathers.controls.Label;

	import models.SOService;

	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	public class MenuGame extends PalaceScene
	{
		public static var boxW:int=201;
		public static var boxH:int=82;

		public static var blockW:int=183;
		public static var blockH:int=64;

		private var dx:Number;
		private var dy:Number;

		private var scale:Number;

		private var space:Space;

		private var originalMenuArr:Array=["1", "2", "3", "4", "5", "6"];
		private var menuArr:Array=[];

		private var hotareaArr:Array=[];
		private var checkArr:Vector.<MenuCheckBar>=new Vector.<MenuCheckBar>();

		private var acc:Accelerometer;

		public function MenuGame(am:AssetManager=null)
		{
			super(am);

			scale=DPIUtil.getDPIScale();
			addChild(getImage("bg-menu"));
			addSelectors();

			initGame(0);
		}

		private function addSelectors():void
		{
			// TODO Auto Generated method stub
		}

		private function initGame(level:int):void
		{
			shuffleData(level);
			addBars();
			addWorld();

			acc=new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(TouchEvent.TOUCH, onTouch);

			lbl=new TextField(200, 100, "00 : 00");
			lbl.fontSize=24;
			lbl.color=0xffffff;
			addChild(lbl);
			lbl.x=850;
			lbl.y=20;
			time=new Timer(10);
			time.addEventListener(TimerEvent.TIMER, onTimer);
			time.start();
		}

		protected function onTimer(event:TimerEvent):void
		{
			var crttime:int=time.currentCount;
			var sectime:int=crttime / 100;

			var mm:int=(crttime % 100);
			var min:int=sectime % 3600 / 60;
			var sec:int=sectime % 60;
			var hour:int=sectime / 3600;

			var mmStr:String=mm.toString();
			var minStr:String=min.toString();
			var secStr:String=sec.toString();
			var hourStr:String=hour.toString();

			if (mm < 10)
				mmStr="0" + mmStr;
			if (min < 10)
				minStr="0" + minStr;
			if (sec < 10)
				secStr="0" + secStr;

			var txt:String=hour == 0 ? (minStr + " : " + secStr) : "59 : 59";
			txt+=" : " + mmStr;
			lbl.text=txt;
		}

		private function addBars():void
		{
			for (var i:int=0; i < menuArr.length; i++)
			{
				addOneBar(i)
				addOneArea(i);
			}
		}

		private function addOneArea(i:int):void
		{
			var length:int=menuArr.length;
			var cx:Number=playAreaEdgeRight - blockW;
			var cy:Number=playAreaCenterY - (length / 2 - i) * GAP;
			hotareaArr.push(new Rectangle(cx, cy, blockW, blockH));
		}

		private var playAreaCenterY:Number=300;
		private var playAreaEdgeLeft:Number=200;
		private var playAreaEdgeRight:Number=800;
		private var GAP:Number=boxH;

		private function addOneBar(i:int):void
		{
			var length:int=menuArr.length;
			var cx:Number=playAreaEdgeLeft;
			var cy:Number=playAreaCenterY - (length / 2 - i) * GAP;

			var menuCheck:MenuCheckBar=new MenuCheckBar();
			addChild(menuCheck);
			checkArr.push(menuCheck);
			var menuBar:Image=getImage("menu-" + menuArr[i]);
			addChild(menuBar);
		}

		private function shuffleData(level:int):void
		{
			var length:int=originalMenuArr.length;
			for (var i:int=0; i < 20; i++)
			{
				var str:String=originalMenuArr.splice(Math.random() * length, 1)[0];
				originalMenuArr.push(str);
			}

			var menuLenth:int=4 + level * 2;
			for (var j:int=0; j < menuLenth; j++)
			{
				menuArr.push(originalMenuArr[j]);
			}
		}

		private function addWorld():void
		{
			space=new Space(new Vec2(0, 600));

			var wallW:int=200;
			var posArr:Array=[new Rectangle(-wallW, -wallW, 1224, wallW), new Rectangle(-wallW, 768, 1224, wallW),
				new Rectangle(-wallW, 0, wallW, 768), new Rectangle(1024, 0, wallW, 768)];

			//addwall
			for (var i:int=0; i < 4; i++)
			{
				var rect:Rectangle=posArr[i];
				var wall:Body=new Body(BodyType.STATIC);
				wall.shapes.add(new Polygon(Polygon.rect(rect.x, rect.y, rect.width, rect.height), Material.wood()));
				wall.space=space;
			}

			//addblocks
			for (var j:int=0; j < menuArr.length; j++)
			{
				var block:Body=new Body(BodyType.DYNAMIC, new Vec2(100 + Math.random() * 800, 200));

				block.shapes.add(new Polygon(Polygon.rect(-blockW / 2, -blockH / 2, blockW, blockH), Material.wood()));
				block.cbTypes.add(blockType);
				block.space=space;

				var blockGraphic:MenuBlock=new MenuBlock();
				blockGraphic.index=j;
				blockGraphic.addChild(getImage("menu-" + menuArr[j] + "-block"));

				block.userData.graphic=blockGraphic;
				block.userData.graphicUpdate=updateGrap;
				block.userData.matched=false;
				block.userData.dragging=false;
				block.userData.boxindex=-1;

				addChild(block.userData.graphic);

				blockArr.push(block);
			}
		}

		private var blockArr:Vector.<Body>=new Vector.<Body>();

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var bodiesList:BodyList=space.bodiesUnderPoint(new Vec2(pt.x, pt.y));
					bodiesList.foreach(
						function(body:Body):void {
							if (body.cbTypes.has(blockType))
								if (!body.userData.matched)
								{
									body.userData.dragging=true;
									body.space=null;
									body.rotation=0;
									draggingBlock=body;
								}
						}
						);
					break;
				}

				case TouchPhase.MOVED:
				{
					if (draggingBlock)
					{
						draggingBlock.position.x=pt.x;
						draggingBlock.position.y=pt.y;
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					if (draggingBlock)
						checkPOS(pt);
					draggingBlock=null;
					break;
				}

				default:
				{
					break;
				}
			}

		}

		private function checkPOS(pt:Point):void
		{
			draggingBlock.userData.dragging=false;
			var crtindex:int=-1;
			var rect:Rectangle;
			var delayFunction:Function;
			for (var i:int=0; i < hotareaArr.length; i++)
			{
				rect=hotareaArr[i];
				if (rect.containsPoint(pt))
				{
					crtindex=i;
					break;
				}
			}
			var blockGraphic:MenuBlock=draggingBlock.userData.graphic;
			if (crtindex < 0)
			{
				draggingBlock.space=space;
			}
			else
			{
				for each (var _block:Body in blockArr)
				{
					if (_block.userData.boxindex == crtindex && draggingBlock != _block)
					{
						_block.space=space;
						_block.userData.boxindex=-1;
					}
				}
				draggingBlock.userData.boxindex=crtindex;
				if (blockGraphic.index == crtindex)
				{
					draggingBlock.userData.matched=true;
					var checkLight:MenuCheckBar=checkArr[crtindex];
					hotareaArr[crtindex]=new Rectangle(-1000, -1000, 0, 0);
					checkCount++;

					var endFunction:Function;

					if (checkCount == hotareaArr.length)
						endFunction=gameOver;

					delayFunction=function():void {
						TweenLite.to(checkLight.clipRect, .5, {x: 0});
						if (endFunction)
							endFunction();
					}
				}
				else
				{
					blockGraphic.addEventListener(TouchEvent.TOUCH, onBlockTouch);
					delayFunction=null;
				}
				TweenLite.to(draggingBlock.position, .5, {x: rect.x + rect.width / 2, y: rect.y + rect.height / 2,
						onComplete: delayFunction});
			}

		}

		private function gameOver():void
		{
			initGameResult(time.currentCount);
			time.reset();
		}

		private function initGameResult(_count:int):void
		{
			trace("gameover")
			var menugameresult:int=SOService.instance.getSO(gameResult) as int;

			if (_count < menugameresult)
				SOService.instance.setSO(gameResult, _count);
		}

		private static const gameResult:String="menugameresult";

		private function onBlockTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.BEGAN);
			if (!tc)
				return;
			var block:MenuBlock=e.currentTarget as MenuBlock;
			if (block)
			{
				block.removeEventListener(TouchEvent.TOUCH, onBlockTouch);
				draggingBlock=blockArr[block.index];
			}
		}

		private var blockType:CbType=new CbType();
		private var draggingBlock:Body;

		private var lbl:TextField;

		private var time:Timer;
		private var checkCount:int=0;

		private function loop(e:Event):void
		{
			space.step(1 / 60);

			for (var i:int=0; i < blockArr.length; i++)
			{
				var body:Body=blockArr[i];

				if (body.userData.graphicUpdate)
					body.userData.graphicUpdate(body);
			}
		}

		protected function onUpdate(event:AccelerometerEvent):void
		{
			dx=event.accelerationX;
			dy=event.accelerationY;
			space.gravity=new Vec2(-dx * 600, dy * 600)
		}

		private function updateGrap(b:Body):void
		{
			if (!b.userData.graphic)
				return;
			b.userData.graphic.x=b.position.x;
			b.userData.graphic.y=b.position.y;
			b.userData.graphic.rotation=b.rotation;
		}
	}
}
