package views.module3.scene31
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Quad;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class JigsawGame extends PalaceGame
	{
		[Embed(source="/assets/module3/scene31/map.jpg")]
		private var img:Class;

		private var startSP:Sprite=new Sprite();
		private var gameSP:Sprite=new Sprite();
		private var endSP:Sprite=new Sprite();

		public function JigsawGame(am:AssetManager=null)
		{
			super(am);

			scale=DPIUtil.getDPIScale();
			addChild(getImage("gamebg"));

			closeBtn=new ElasticButton(getImage("button_close"));
			addChild(closeBtn);
			closeBtn.x=950;
			closeBtn.y=60;
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseTouch);
//			closeBtn.visible=closeBtn.touchable=false;

			addStart();

			map=new img();

			px=(1024 - map.width) / 2 - 100;
			py=(768 - map.height) / 2 - 50;
		}

		private function onCloseTouch(e:Event):void
		{
			closeBtn.removeEventListener(ElasticButton.CLICK, onCloseTouch);
			closeGame();
		}

		private function closeGame():void
		{
			dispatchEvent(new Event("gameOver"));
		}

		private function restartGame(e:Event=null):void
		{
			dispatchEvent(new Event("gameRestart"));
		}

		private function onStartTouch(e:Event):void
		{
			startBtn.addEventListener(TouchEvent.TOUCH, onStartTouch);
			startSP.touchable=false;
			TweenLite.delayedCall(1, function():void {
				TweenLite.to(startSP, 1, {y: -768,
						onComplete: function():void {
							startSP.dispose();
							initGameBG();
							initData(gamelevel);
							startGame();
						}});
			});
		}

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

		private function addStart():void
		{
			addChild(startSP);
			var gameHint:Image=getImage("jigsaw-name");
			gameHint.x=160;
			gameHint.y=100;
			startSP.addChild(gameHint);

			var sbHolder:Sprite=new Sprite();
			sBtn=getImage("menu-simple");
			sBtnD=getImage("menu-simple-down");
			sbHolder.x=400;
			sbHolder.y=400;
			sbHolder.addChild(sBtn);
			sbHolder.addChild(sBtnD);
			startSP.addChild(sbHolder);
			sbHolder.addEventListener(TouchEvent.TOUCH, onSBTouch);

			var hbHolder:Sprite=new Sprite();
			hBtn=getImage("menu-hard");
			hBtnD=getImage("menu-hard-down");
			hbHolder.x=415;
			hbHolder.y=505;
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

			gamelevel=0;

		}

		private function getStringFormTime(_count:int):String
		{
			var sectime:int=_count / 100;

			var mm:int=(_count % 100);
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

		private static const gameResult:String="Jigsawgameresult";

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

		private var _gamelevel:int;

		private var bpArr:Array=[];

		private var cellArr:Vector.<Cell>=new Vector.<Cell>();

		private var playground:Sprite;
		private var piv:Point;
		private var size:Point;

		private var map:Bitmap;

		private var bgHolder:Sprite;

		private var colorBG:Image;
		private var okHolder:Sprite;
		private var ready:Boolean;

		private var px:Number;
		private var py:Number;
		private var closeBtn:ElasticButton;
		private var startBtn:ElasticButton;
		private var hBtn:Image;
		private var hBtnD:Image;
		private var sBtn:Image;
		private var sBtnD:Image;
		private var time:Timer;
		private var timeHolder:Sprite;
		private var lbl:TextField;

		private var analyst:BitmapAnalyst;

		public function initData(lvl:int):void
		{
			var map:Bitmap=new img();
			analyst=new BitmapAnalyst(map, 4 + lvl * 2, 4 + lvl * 2);
			analyst.initAnalyst();
			bpArr=analyst.getBpArr();
			piv=analyst.getPivot();
			size=analyst.getSize();
		}

		public function startGame():void
		{
			initGameBG();
			initPlayGround();
			initTime();
			TweenLite.delayedCall(2, shuffle);
		}

		private function initPlayGround():void
		{
			playground=new Sprite();
			gameSP.addChild(playground);

			playground.x=px;
			playground.y=py;

			for (var i:int=0; i < bpArr.length; i++)
			{
				var arr:Array=bpArr[i];
				for (var j:int=0; j < arr.length; j++)
				{
					var bp:Bitmap=arr[j];
					var cell:Cell=new Cell(i, j, bp);
					cell.pivotX=piv.x >> 1;
					cell.pivotY=piv.y >> 1;
					playground.addChild(cell);
					cell.tx=size.x * i + size.x / 2;
					cell.ty=size.y * j + size.y / 2;
					cell.x=cell.tx;
					cell.y=cell.ty;
					cell.addEventListener(TouchEvent.TOUCH, onCellTouch);
					cellArr.push(cell);
				}
			}
		}

		private function shuffle():void
		{
			for each (var cell:Cell in cellArr)
			{
				var dx:Number=50 + Math.random() * 900 - px;
				var dy:Number=Math.random() * 50 + 530 + gamelevel * 40;
				var dr:Number=Math.random() * Math.PI * 2;
//				dr=0;
				TweenLite.to(cell, 1, {x: dx, y: dy, rotation: dr});
			}

			TweenLite.to(timeHolder, 1, {x: 822, onComplete: function():void {
				ready=true;
				time=new Timer(10);
				time.addEventListener(TimerEvent.TIMER, onTimer);
				time.start();
			}});
		}

		protected function onTimer(event:TimerEvent):void
		{
			var crttime:int=time.currentCount;

			lbl.text=getStringFormTime(crttime);
		}

		private function initTime():void
		{
			timeHolder=new Sprite();
			timeHolder.addChild(getImage("menu-timebar"));
			lbl=new TextField(200, 50, "00:00:00");
			lbl.fontSize=32;
			lbl.color=0x83d00;
			gameSP.addChild(lbl);
			lbl.x=20;
			lbl.y=25;

			timeHolder.addChild(lbl);
			timeHolder.x=1024;
			timeHolder.y=30;

			addChild(timeHolder);
		}

		private function onCellTouch(e:TouchEvent):void
		{
			if (!ready)
				return;
			var cell:Cell=e.currentTarget as Cell;
			if (!cell)
				return;
			var tcbs:Vector.<Touch>=e.getTouches(cell, TouchPhase.BEGAN);
			var tcms:Vector.<Touch>=e.getTouches(cell, TouchPhase.MOVED);
			var tces:Vector.<Touch>=e.getTouches(cell, TouchPhase.ENDED);

			if (tcbs.length > 0)
			{
				if (!cell.filter)
				{
					var fl:BlurFilter=BlurFilter.createDropShadow(10);
					cell.filter=fl;
					playground.setChildIndex(cell, playground.numChildren - 1);
				}
			}

			if (tcms.length == 1)
			{
				var delta:Point=tcms[0].getMovement(this);
				cell.x+=delta.x;
				cell.y+=delta.y;
			}
			//如果有两个点，可以认为是旋转
			else if (tcms.length == 2)
			{
				//得到两个点的引用
				var touchA:Touch=tcms[0];
				var touchB:Touch=tcms[1];
				//A点的当前和上一个坐标
				var currentPosA:Point=touchA.getLocation(this);
				var previousPosA:Point=touchA.getPreviousLocation(this);
				//B点的当前和上一个坐标
				var currentPosB:Point=touchB.getLocation(this);
				var previousPosB:Point=touchB.getPreviousLocation(this);
				//计算两个点之间的距离
				var currentVector:Point=currentPosA.subtract(currentPosB);
				var previousVector:Point=previousPosA.subtract(previousPosB);
				//计算上一个弧度和当前触碰点弧度，算出弧度差值
				var currentAngle:Number=Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number=Math.atan2(previousVector.y, previousVector.x);
				var deltaAngle:Number=currentAngle - previousAngle;
				//旋转
				cell.rotation+=deltaAngle;
			}

			if (tces.length > 0)
			{
				cell.filter=null;
				check(cell);
			}
		}

		private function check(cell:Cell):void
		{
			var pt:Point=new Point(cell.x, cell.y);
			var tpt:Point=new Point(cell.tx, cell.ty);
			if (Point.distance(pt, tpt) < 20 && Math.abs(cell.rotation) < Math.PI / 9)
			{
				cell.removeEventListener(TouchEvent.TOUCH, onCellTouch);
				okHolder.addChild(cell);

				if (playground.numChildren == 0)
				{
					time.stop();
					TweenLite.to(cell, 1, {x: cell.tx, y: cell.ty, rotation: 0, onComplete: gameOver});
				}
				else
					TweenLite.to(cell, .3, {x: cell.tx, y: cell.ty, rotation: 0});
			}
		}

		private function gameOver():void
		{
			TweenLite.to(okHolder, .5, {alpha: 0});
			TweenLite.to(colorBG, .5, {alpha: 1, onComplete: function():void {
				TweenLite.to(timeHolder, 1, {x: 1024});
				TweenLite.to(gameSP, 1.2, {y: -768, ease: Bounce.easeIn,
						onComplete: function():void {
							timeHolder.dispose();
							gameSP.dispose();
							initResult(time.currentCount);
						}});
			}});
		}

		private function initResult(_count:int):void
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

			var resultTF:TextField=new TextField(300, 80, resultTXT);
			resultTF.fontSize=48;
			resultTF.color=0xb83d00;
			resultTF.x=305;
			resultTF.y=240;
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

		private function initGameBG():void
		{
			addChild(gameSP);
			bgHolder=new Sprite();
			gameSP.addChild(bgHolder);
			okHolder=new Sprite();
			gameSP.addChild(okHolder);

			bgHolder.x=okHolder.x=px;
			bgHolder.y=okHolder.y=py;
			var greyBG:Image=Image.fromBitmap(map);
			var fl:ColorMatrixFilter=new ColorMatrixFilter();
			fl.matrix=Vector.<Number>([
				1, 0, 0, 0, 0,
				1, 0, 0, 0, 0,
				1, 0, 0, 0, 0,
				0, 0, 0, 1, 0
				]);
			greyBG.filter=fl;
			bgHolder.addChild(greyBG);

			colorBG=Image.fromBitmap(map);
			bgHolder.addChild(colorBG)
			colorBG.alpha=0;
			bgHolder.touchable=false;
			okHolder.touchable=false;
		}
	}
}
