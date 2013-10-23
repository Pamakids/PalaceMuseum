package views.module3.scene32
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;
	import com.pamakids.palace.utils.StringUtils;
	import com.pamakids.utils.DPIUtil;
	import com.pamakids.utils.StringUtil;

	import flash.events.AccelerometerEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;

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

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class MenuGame extends PalaceGame
	{
		//菜单栏
		public static var barW:int=567;
		public static var barH:int=91;

		//菜单块
		public static var blockW:int=196;
		public static var blockH:int=81;

		private var dx:Number;
		private var dy:Number;

		private var scale:Number;

		private var space:Space;

		private var originalMenuArr:Array=["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
		private var menuArr:Array=[];

		private var hotareaArr:Array=[];
		private var checkArr:Vector.<Sprite>=new Vector.<Sprite>();

		private var acc:Accelerometer;

		private var startSP:Sprite=new Sprite();
		private var gameSP:Sprite=new Sprite();
		private var endSP:Sprite=new Sprite();

		public function MenuGame(am:AssetManager=null)
		{
			super(am);

			scale=DPIUtil.getDPIScale();
			addBG();

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);

			addStart();
		}

		private function addStart():void
		{
			addChild(startSP);
			var gameHint:Image=getImage("menu-hint");
			gameHint.x=160;
			startSP.addChild(gameHint);

			var sbHolder:Sprite=new Sprite();
			sBtn=getImage("menu-simple");
			sBtnD=getImage("menu-simple-down");
			sbHolder.x=49;
			sbHolder.y=514;
			sbHolder.addChild(sBtn);
			sbHolder.addChild(sBtnD);
			startSP.addChild(sbHolder);
			sbHolder.addEventListener(TouchEvent.TOUCH, onSBTouch);

			var hbHolder:Sprite=new Sprite();
			hBtn=getImage("menu-hard");
			hBtnD=getImage("menu-hard-down");
			hbHolder.x=67;
			hbHolder.y=618;
			hbHolder.addChild(hBtn);
			hbHolder.addChild(hBtnD);
			startSP.addChild(hbHolder);
			hbHolder.addEventListener(TouchEvent.TOUCH, onHBTouch);

			startBtn=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down");
			startBtn.x=891;
			startBtn.y=666;
			startSP.addChild(startBtn);
			startBtn.addEventListener(ElasticButton.CLICK, onStartTouch);
			shakeNext();
			gamelevel=0;
		}

		private function shakeNext():void
		{
			if (startBtn)
				TweenMax.to(startBtn, 1, {shake: {x: 5, numShakes: 4}, onComplete: function():void
				{
					TweenLite.delayedCall(5, shakeNext);
				}});
		}

		private function onStartTouch(e:Event):void
		{
			closeBtn.visible=closeBtn.touchable=false;
			startBtn.removeEventListener(TouchEvent.TOUCH, onStartTouch);
			startSP.touchable=false;
			TweenLite.delayedCall(1, function():void {
				TweenLite.to(startSP, 1, {y: -768,
						onComplete: function():void {
							startSP.dispose();
							initGame(gamelevel);
						}});
			});
		}

		private function onHBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED)
			if (tc)
				gamelevel=1;
		}

		private function onSBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED)
			if (tc)
				gamelevel=0;
		}

		private function initGame(level:int):void
		{
			shuffleData(level);
			addPlayArea();
			addChild(gameSP);
			addBars();
		}

		private function startGame():void
		{
			acc=new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);

			addEventListener(TouchEvent.TOUCH, onTouch);

			time=new Timer(33);
			time.addEventListener(TimerEvent.TIMER, onTimer);
			time.start();
		}

		private function initTime():void
		{
			timeHolder=new Sprite();
			timeHolder.addChild(getImage("menu-timebar"));
			lbl=new TextField(200, 50, "00:00:00");
			lbl.fontSize=32;
			lbl.color=0x83d00;
			lbl.vAlign="top";
			gameSP.addChild(lbl);
			lbl.x=20;
			lbl.y=25;

			timeHolder.addChild(lbl);
			timeHolder.x=1024;
			timeHolder.y=30;

			addChild(timeHolder);
		}

		private function addPlayArea():void
		{
			playBG=getImage("menu-area");
			playBG.x=(1024 - playAreaW) / 2;
			addChild(playBG);
		}

		protected function onTimer(event:TimerEvent):void
		{
			var crttime:int=time.currentCount;

			lbl.text=getStringFormTime(crttime);
		}

		private function addBars():void
		{
			barArea=new Sprite();
			gameSP.addChild(barArea);
			barArea.x=(1024 - playAreaW) / 2;
			barArea.y=-playAreaH;

			addRope();

			for (var i:int=0; i < menuArr.length; i++)
			{
				addOneBar(i)
				addOneArea(i);
			}


			initTime();

			TweenLite.to(timeHolder, 1, {x: 822});
			TweenLite.to(barArea, 1.2, {y: 0, ease: Bounce.easeOut,
					onComplete: function():void {
						addWorld();
						startGame();
					}
				});
		}

		private function addRope():void
		{
			var ropeH:int=28;
			var length:int=playAreaH / ropeH + 1;
			var xPOSArr:Array=[24, 212, 382, 537];
			var cx:Number=(playAreaW - barW) / 2;

			for (var i:int=0; i < length; i++)
			{
				for (var j:int=0; j < xPOSArr.length; j++)
				{
					var rope:Image=getImage("menu-rope");
					rope.x=xPOSArr[j] + cx;
					rope.y=i * ropeH;
					barArea.addChild(rope);
				}
			}
		}

		private function addOneArea(i:int):void
		{
			var length:int=menuArr.length;
			var cx:Number=playAreaEdgeRight - (playAreaW - barW) / 2 - blockW - 6;
			var cy:Number=playAreaCenterY - (length / 2 - i) * GAP - 3;
			hotareaArr.push(new Rectangle(cx, cy, blockW, blockH));
		}

		private var playAreaCenterY:Number=283;
		private var playAreaEdgeLeft:Number=140;
		private var playAreaW:Number=743;
		private var playAreaH:Number=566;
		private var playAreaEdgeRight:Number=883;
		private var GAP:Number=barH;

		private function addOneBar(i:int):void
		{
			var length:int=menuArr.length;
			var cx:Number=(playAreaW - barW) / 2;
			var cy:Number=playAreaCenterY - (length / 2 - i) * GAP;

			//bar
			var menuBar:Image=getImage("menu-" + menuArr[i] + "-bar");
			barArea.addChild(menuBar);
			menuBar.x=cx;
			menuBar.y=cy;

			//light
			var menuCheck:Sprite=new Sprite();
			menuCheck.addChild(getImage("menu-check"));
			menuCheck.clipRect=new Rectangle(barW, 0, barW, barH);
			menuCheck.x=cx - 3;
			menuCheck.y=cy - 2;
			barArea.addChild(menuCheck);
			checkArr.push(menuCheck);
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
			space=new Space(new Vec2(0, 3000));

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
				var block:Body=new Body(BodyType.DYNAMIC, new Vec2(100 + Math.random() * 800, 0));

				block.shapes.add(new Polygon(Polygon.rect(-188 / 2, -70 / 2, 188, 70), Material.wood()));
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

				gameSP.addChild(block.userData.graphic);

				blockArr.push(block);
			}

			addEventListener(Event.ENTER_FRAME, loop);
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

									var blockG:MenuBlock=draggingBlock.userData.graphic;
									blockG.parent.setChildIndex(blockG, blockG.parent.numChildren - 1);
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
					var checkLight:Sprite=checkArr[crtindex];
					hotareaArr[crtindex]=new Rectangle(-1000, -1000, 0, 0);
					checkCount++;

					var endFunction:Function;

					if (checkCount == hotareaArr.length)
					{
						time.stop();
						endFunction=function():void {
							TweenLite.delayedCall(2, gameOver);
						}
					}

					delayFunction=function():void {
						TweenLite.to(checkLight.clipRect, .7, {x: 0});
						if (endFunction)
							endFunction();
					}
				}
				else
				{
					delayFunction=function():void {
						blockGraphic.addEventListener(TouchEvent.TOUCH, onBlockTouch);
					};
				}
				TweenLite.to(draggingBlock.position, .3, {x: rect.x + rect.width / 2, y: rect.y + rect.height / 2,
						onComplete: delayFunction});
			}

		}

		private function gameOver():void
		{
			isWin=true;
			TweenLite.to(playBG, 1, {alpha: 0});
			TweenLite.to(timeHolder, 1, {x: 1024});
			TweenLite.to(gameSP, 1.2, {y: -768, ease: Bounce.easeIn,
					onComplete: function():void {
						timeHolder.dispose();
						gameSP.dispose();
						initGameResult(time.currentCount);
					}});
		}

		private function initGameResult(_count:int):void
		{
			addChild(endSP);
			endSP.x=148;
			endSP.y=-547;

			var gameResultlvl:String=gameResult + gamelevel.toString();
			var menugameresult:int=SOService.instance.getSO(gameResultlvl) as int;

			var resultTXT:String;
			var recordTXT:String;
			var delayFunction:Function;

			if (!menugameresult)
			{
				SOService.instance.setSO(gameResultlvl, _count);
				delayFunction=showRecord;
				resultTXT=recordTXT=getStringFormTime(_count);
			}
			else if (_count < menugameresult)
			{
				SOService.instance.setSO(gameResultlvl, _count);
				delayFunction=showRecord;
				resultTXT=recordTXT=getStringFormTime(_count);
			}
			else
			{
				resultTXT=getStringFormTime(_count);
				recordTXT=getStringFormTime(menugameresult);
			}
			endSP.addChild(getImage("menu-end"));

			var resultTF:TextField=new TextField(300, 100, resultTXT);
			resultTF.fontSize=48;
			resultTF.color=0xb83d00;
			resultTF.x=305;
			resultTF.y=255;
			resultTF.vAlign="top";
			endSP.addChild(resultTF);

			var recordTF:TextField=new TextField(150, 40, recordTXT);
			recordTF.fontSize=26;
			recordTF.color=0x602508;
			recordTF.x=332;
			recordTF.y=400;
			endSP.addChild(recordTF);

			var rsBtn:ElasticButton=new ElasticButton(getImage("restart"));
			rsBtn.shadow=getImage("restart-light");
			rsBtn.x=380;
			rsBtn.y=520;
			endSP.addChild(rsBtn);

			TweenLite.to(endSP, 1, {y: 28, onComplete: function():void {

				rsBtn.addEventListener(ElasticButton.CLICK, restartGame);
				if (delayFunction)
					delayFunction();
				else
					closeBtn.visible=closeBtn.touchable=true;
			}});
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			closeGame();
		}

		private function closeGame():void
		{
			dispatchEvent(new Event(PalaceGame.GAME_OVER));
		}

		private function restartGame(e:Event=null):void
		{
			dispatchEvent(new Event(PalaceGame.GAME_RESTART));
		}

		private function getStringFormTime(_count:int):String
		{
			var sectime:int=_count / 30;

			var mm:int=(_count % 30);
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

			var txt:String=hour == 0 ? (minStr + ":" + secStr) : "59:59";
			txt+=":" + mmStr;
			return txt;
		}

		private function showRecord():void
		{
			var recordIcon:Image=getImage("game-record");
			endSP.addChild(recordIcon);
			recordIcon.x=536;
			recordIcon.y=282;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut,
					onComplete: function():void {
						closeBtn.visible=closeBtn.touchable=true;
					}});
		}

		private function onBlockTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.BEGAN);
			if (!tc)
				return;
			var block:MenuBlock=e.currentTarget as MenuBlock;
			if (block)
			{
				block.parent.setChildIndex(block, block.parent.numChildren - 1);
				block.removeEventListener(TouchEvent.TOUCH, onBlockTouch);
				var body:Body=blockArr[block.index];
				if (!body.userData.matched)
					draggingBlock=body;
			}
		}

		private var blockType:CbType=new CbType();
		private var draggingBlock:Body;

		private var lbl:TextField;

		private var time:Timer;
		private var checkCount:int=0;

		private var barArea:Sprite;

		private var playBG:Image;
		private var _gamelevel:int;

		private var sBtn:Image;

		private var sBtnD:Image;

		private var hBtn:Image;

		private var hBtnD:Image;

		private var startBtn:ElasticButton;

		private var timeHolder:Sprite;
		private var closeBtn:ElasticButton;
		public var isWin:Boolean;

		public function get gamelevel():int
		{
			return _gamelevel;
		}

		public function set gamelevel(value:int):void
		{
			_gamelevel=value;
			if (!sBtn)
				return;
			switch (value)
			{
				case 0:
				{
					sBtn.visible=hBtnD.visible=false;
					sBtnD.visible=hBtn.visible=true;
					break;
				}

				case 1:
				{
					sBtn.visible=hBtnD.visible=true;
					sBtnD.visible=hBtn.visible=false;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function loop(e:Event):void
		{
			space.step(1 / 30);

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
			space.gravity=new Vec2(-dx * 3000, dy * 3000)
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
