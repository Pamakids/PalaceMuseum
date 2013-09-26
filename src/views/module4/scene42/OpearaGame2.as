package views.module4.scene42
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import events.OperaSwitchEvent;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;
	import views.module4.Scene42;

	public class OpearaGame2 extends PalaceGame
	{
		public var scene:Scene42;
		private var crtOperaName:String="xiyou";

		public function OpearaGame2(am:AssetManager=null)
		{
			super(am);

			addChild(getImage("operabg2"));

			addMountains();

			addPillars();

			ropeSP=new Shape();
			addChild(ropeSP);

			for (var i:int=0; i < 3; i++)
			{
				var sp:Sprite=new Sprite();
				addChild(sp);
				spArr.push(sp);

				var rail:Image=getImage("railing" + (i + 1).toString() + "2");
				addChild(rail);
				rail.y=railYArr[i];
				rail.touchable=false;
			}

			addBodys();
			addBtns();

			TweenLite.delayedCall(.5, function():void {
				var e:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.OPEN);
				scene.onOperaSwitch(e);
			});

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private var ropeSP:Shape;
		private var ropeTexture:Texture;

		private function onEnterFrame():void
		{
//			ropeSP.graphics.clear();
//			ropeSP.graphics.lineStyle(3, 0x99ccff);
			for each (var body:OperaBody in bodyArr)
			{
				if (body)
				{
					body.shake();
					var rope:Shape=body.rope;
					if (rope)
					{
						rope.graphics.clear();
						rope.graphics.lineTexture(10, ropeTexture);
//						rope.graphics.lineStyle(3, 0x99ccff);
						rope.graphics.moveTo(body.stagePt.x - 5, -200);
						rope.graphics.lineTo(body.x - 5, body.y);
					}
//					ropeSP.graphics.moveTo(body.stagePt.x, -200);
//					ropeSP.graphics.lineTo(body.x, body.y);
				}
			}
		}

		private var btnArr:Array=[];
		private var btnPosXArr:Array=[];
		private var btnPosY:Number=729;
		private var btnTypeArr:Array=["1", "2", "3", "4", "5", "6"];

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(8);

		private function addBtns():void
		{
			var btnbg:Image=getImage("scorebg");
			btnbg.y=768 - btnbg.height;
			addChild(btnbg);
			btnbg.touchable=false;
			for (var i:int=0; i < btnTypeArr.length; i++)
			{
				var btn:ElasticButton=new ElasticButton(getImage("btn" + btnTypeArr[i]));
				btn.x=56 + i * 100;
				btn.y=btnPosY;
				addChild(btn);
				btn.addEventListener(ElasticButton.CLICK, onBtnClick);
				btnArr.push(btn);
			}

			var mountainBtn:ElasticButton=new ElasticButton(getImage("btnmountain"));
			mountainBtn.x=870;
			mountainBtn.y=btnPosY;
			addChild(mountainBtn);
			mountainBtn.addEventListener(ElasticButton.CLICK, onMountainBtnClick);

			var fireBtn:ElasticButton=new ElasticButton(getImage("btnfire"));
			fireBtn.x=970;
			fireBtn.y=btnPosY;
			addChild(fireBtn);
			fireBtn.addEventListener(ElasticButton.CLICK, onFireBtnClick);
		}

		private function onFireBtnClick(e:Event):void
		{
			checkClick(7)
			TweenLite.killTweensOf(fireMountain);
			firMountainOpen=!firMountainOpen;
			var _scale:Number=firMountainOpen ? 1 : 0.01;
			TweenLite.to(fireMountain, .5, {scaleX: _scale, scaleY: _scale});
		}

		private function onMountainBtnClick(e:Event):void
		{
			checkClick(6)
			TweenLite.killTweensOf(mountain);
			mountainOpen=!mountainOpen;
			var _scale:Number=mountainOpen ? 1 : 0.01;
			TweenLite.to(mountain, .5, {scaleX: _scale, scaleY: _scale});
		}

		private function onBtnClick(e:Event):void
		{
			var btn:ElasticButton=e.currentTarget as ElasticButton;
			var index:int=btnArr.indexOf(btn);
			if (index < 0)
				return;
			checkClick(index);
			var body:OperaBody=bodyArr[index];
			if (body)
			{
				TweenLite.killTweensOf(body);
				if (body.ready)
					body.playExit();
				else
					body.playEnter(false);
			}
		}

		private function checkClick(index:int):void
		{
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			dispatchEvent(new Event("gameOver"));
		}

		private var bodyArr:Vector.<OperaBody>=new Vector.<OperaBody>();

		private function addBodys():void
		{
			ropeTexture=assets.getTexture("loading");
			for (var i:int=0; i < typeArr.length; i++)
			{
				addOneBody(i);
			}
		}

		private var typeArr:Array=["7", "6", "3", "5", "4", "1"];

		private var bodyPosArr:Array=[new Point(836, 144), new Point(380, 380),
			new Point(649, 375), new Point(274, 634), new Point(528, 632), new Point(773, 644)];

		private var xiyouB_PosArr:Array=[new Point(-104, 2), new Point(-3, 87), new Point(-3, 98), new Point(21, 123), new Point(-7, 88), new Point(33, 107)];
//		private var xiyouB_PosArr2:Array=[new Point(33, 107), new Point(26, 109), new Point(-3, 98), new Point(-7, 88), new Point(21, 123), new Point(-3, 87)];
		private var xiyouMaskPosArr:Array=[new Point(0, 0), new Point(16, 43), new Point(30, 37), new Point(28, 69), new Point(7, 23), new Point(30, 44)];

//		private var xiyouMaskPosArr2:Array=[new Point(30, 44), new Point(13, 55), new Point(30, 37), new Point(7, 23), new Point(28, 69), new Point(16, 43)];

		private function addOneBody(index:int):void
		{
			var body:OperaBody=new OperaBody();
			body.index=index;
			var type:String=typeArr[index];
			body.type=type;
			body.body=getImage(crtOperaName + "body" + type);
			body.head=getImage(crtOperaName + "head" + type);
			body.countBG=getImage("body-countdown");
			body.stagePt=bodyPosArr[index] //位置 by index
			body.offsetsXY=xiyouB_PosArr[index];
			body.maskPos=xiyouMaskPosArr[index]; //相对位置 by type
			body.reset();
			var rope:Shape=new Shape();
			body.rope=rope;

			var img:Image=getImage(crtOperaName + "mask" + type);
			if (img)
			{
				var mask:OperaMask=new OperaMask();
				mask.index=index;
				mask.type=type;
				mask.addChild(img);
				body.addMask(mask, false);
			}

			bodyArr[index]=body;
			var sp:Sprite;
			if (index < 1)
				sp=spArr[0];
			else if (index < 3)
				sp=spArr[1];
			else
				sp=spArr[2];
			sp.addChild(rope);
			sp.addChild(body);
		}

		private var spArr:Array=[];
		private var railYArr:Array=[180, 418, 643];

		private function addMountains():void
		{
			mountain=getImage("moutain");
			mountain.pivotX=mountain.width >> 1;
			mountain.pivotY=mountain.height;
			mountain.scaleX=mountain.scaleY=.01;
			mountain.x=762;
			mountain.y=695;
			addChild(mountain);
			mountainOpen=false;

			fireMountain=getImage("firemoutain");
			fireMountain.pivotX=fireMountain.width >> 1;
			fireMountain.pivotY=fireMountain.height;
			fireMountain.scaleX=fireMountain.scaleY=.01;
			fireMountain.x=387;
			fireMountain.y=200;
			addChild(fireMountain);
			firMountainOpen=false;
		}

		private var pillarPosArr:Array=[new Point(285, 0), new Point(697, 0),
			new Point(246, 239), new Point(749, 240), new Point(202, 477), new Point(757, 478)];

		private var mountain:Image;

		private var fireMountain:Image;
		private var mountainOpen:Boolean;
		private var firMountainOpen:Boolean;

		private function addPillars():void
		{
			for (var i:int=0; i < pillarPosArr.length; i++)
			{
				var img:Image=getImage("pillar" + (i + 1).toString());
				img.x=pillarPosArr[i].x;
				img.y=pillarPosArr[i].y;
				addChild(img);
				img.touchable=false;
			}

		}
	}
}
