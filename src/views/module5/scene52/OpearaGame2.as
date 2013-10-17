package views.module5.scene52
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import controllers.MC;

	import events.OperaSwitchEvent;

	import models.SOService;

	import particle.FireParticle;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;
	import views.global.TopBar;
	import views.module5.Scene52;

	public class OpearaGame2 extends PalaceGame
	{
		public var scene:Scene52;
		private var crtOperaName:String;
		private var operaArr:Array=["xiyou", "sanguo"];
		private var gameLevel:int=0;
		private var fireParticle:FireParticle;

		public function OpearaGame2(lvl:int, am:AssetManager=null)
		{
			super(am);
			gameLevel=lvl;
			crtOperaName=operaArr[gameLevel];
			crtTypeArr=this[crtOperaName + "TypeArr"];
			crtBodyPosArr=this[crtOperaName + "BodyPosArr"];
			crtB_HPosArr=this[crtOperaName + "B_PosArr"];
			crtMaskPosArr=this[crtOperaName + "MaskPosArr"];

			addChild(getImage("operabg2"));

			addPillars();

			ropeSP=new Shape();
			addChild(ropeSP);

			if (gameLevel == 0)
				addMountains();
			else
				addBoat();

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
			if (gameLevel == 1)
				addCloud();
			addBtns();

			TweenLite.delayedCall(.5, function():void {
				var e:OperaSwitchEvent=new OperaSwitchEvent(OperaSwitchEvent.OPEN);
				scene.onOperaSwitch(e);
			});

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (SOService.instance.checkHintCount(silverCardClickHint))
				addEventListener(Event.ENTER_FRAME, onEnterFrame2);
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			TopBar.show();
			MC.instance.hideMC();
		}

		private var silverCardClickHint:String="silverCardClickHint";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;
		private var isHintReverse:Boolean;

		private function onEnterFrame2(e:Event):void
		{
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame2);
			}
			if (count < 30 * 8)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					hintFinger=getImage("pushbuttonhint");
					hintFinger.x=36;
					hintFinger.y=586;
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.y == 536)
						isHintReverse=true;
					else if (hintFinger.y == 586)
						isHintReverse=false;
					hintFinger.y+=isHintReverse ? 5 : -5;
				}
			}
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
//						rope.graphics.lineTexture(10, ropeTexture);
						rope.graphics.lineStyle(3, 0x99ccff);
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
				var btn:ElasticButton=new ElasticButton(getImage(crtOperaName + "btn" + btnTypeArr[i]));
				btn.x=56 + i * 100;
				btn.y=btnPosY;
				addChild(btn);
				btn.addEventListener(ElasticButton.CLICK, onBtnClick);
				btnArr.push(btn);
			}

			if (gameLevel == 0)
			{
				var fireBtnXiyou:ElasticButton=new ElasticButton(getImage("sanguobtnfire"));
				fireBtnXiyou.x=770;
				fireBtnXiyou.y=btnPosY;
				addChild(fireBtnXiyou);
				fireBtnXiyou.addEventListener(ElasticButton.CLICK, onXiyouFireBtnClick);

				var mountainBtn:ElasticButton=new ElasticButton(getImage(crtOperaName + "btnmountain"));
				mountainBtn.x=870;
				mountainBtn.y=btnPosY;
				addChild(mountainBtn);
				mountainBtn.addEventListener(ElasticButton.CLICK, onMountainBtnClick);

				var fireMoutainBtn:ElasticButton=new ElasticButton(getImage(crtOperaName + "btnfire"));
				fireMoutainBtn.x=970;
				fireMoutainBtn.y=btnPosY;
				addChild(fireMoutainBtn);
				fireMoutainBtn.addEventListener(ElasticButton.CLICK, onFireBtnClick);
			}
			else
			{
				var fireBtnSanguo:ElasticButton=new ElasticButton(getImage("sanguobtnfire"));
				fireBtnSanguo.x=770;
				fireBtnSanguo.y=btnPosY;
				addChild(fireBtnSanguo);
				fireBtnSanguo.addEventListener(ElasticButton.CLICK, onSanguoFireBtnClick);

				var boatBtn:ElasticButton=new ElasticButton(getImage(crtOperaName + "btnboat"));
				boatBtn.x=870;
				boatBtn.y=btnPosY;
				addChild(boatBtn);
				boatBtn.addEventListener(ElasticButton.CLICK, onBoatBtnClick);

				var cloudBtn:ElasticButton=new ElasticButton(getImage(crtOperaName + "btncloud"));
				cloudBtn.x=970;
				cloudBtn.y=btnPosY;
				addChild(cloudBtn);
				cloudBtn.addEventListener(ElasticButton.CLICK, onCloudBtnClick);
			}
		}

		private function onBoatBtnClick(e:Event):void
		{
			checkClick(7)
			var b:ElasticButton=e.currentTarget as ElasticButton;
			b.touchable=false;
			var dx:Number;
			if (boat.x > 1024)
			{
				dx=Math.random() * 100;
				TweenLite.to(boat, 3, {x: dx, onComplete: function():void {
					b.touchable=true;
				}});
			}
			else
			{
				dx=-1100;
				TweenLite.to(boat, 1.5, {x: dx, onComplete: function():void {
					boat.x=1100;
					if (fireParticle)
					{
						fireParticle.dispose();
						fireParticle=null;
					}
					b.touchable=true;
				}});
			}
		}

		private function onCloudBtnClick(e:Event):void
		{
			checkClick(6)
			var b:ElasticButton=e.currentTarget as ElasticButton;
			b.touchable=false;
			var dx:Number;
			if (cloud.x > 1024)
			{
				dx=100 + Math.random() * 400;
				TweenLite.to(cloud, 3, {x: dx, onComplete: function():void {
					b.touchable=true;
				}});
			}
			else
			{
				dx=-1100;
				TweenLite.to(cloud, 1.5, {x: dx, onComplete: function():void {
					cloud.x=1100;
					b.touchable=true;
				}});
			}
		}

		private var boat:Sprite;
		private var cloud:Image;

		private function addBoat():void
		{
			boat=new Sprite();
			boat.addChild(getImage("boat"));
			addChild(boat);
			boat.x=1100;
			boat.y=501;
		}

		private function addCloud():void
		{
			cloud=getImage("cloud");
			addChild(cloud);
			cloud.x=1100;
			cloud.y=3;
		}

		private function onXiyouFireBtnClick(e:Event):void
		{
			if (fireParticle)
			{
				var b:ElasticButton=e.currentTarget as ElasticButton;
				b.touchable=false;
				TweenLite.to(fireParticle, .5, {alpha: .1, scaleY: .1, onComplete: function():void {
					fireParticle.dispose();
					fireParticle=null;
					b.touchable=true;
				}});
			}
			else
			{
				fireParticle=new FireParticle();
				fireParticle.init(gameLevel);
				moutainHolder.addChild(fireParticle);
				fireParticle.x=170;
				fireParticle.scaleX=2.5;
				fireParticle.y=175;
			}
		}

		private function onSanguoFireBtnClick(e:Event):void
		{
			if (fireParticle)
			{
				var ptc:FireParticle=fireParticle;
				fireParticle=null;
				TweenLite.to(ptc, 1, {alpha: .1, scaleX: .5, onComplete: function():void {
					ptc.removeFromParent(true);
					ptc=null;
				}});
			}
			fireParticle=new FireParticle();
			fireParticle.init(gameLevel);
			boat.addChild(fireParticle);
			fireParticle.x=int(Math.random() * 5) * 200 + 80;
			fireParticle.y=150;
		}

		private function onFireBtnClick(e:Event):void
		{
			checkClick(7)
			TweenLite.killTweensOf(fireMountain);
			firMountainOpen=!firMountainOpen;
			var _scale:Number=firMountainOpen ? 1 : 0;
			TweenLite.to(moutainHolder, .5, {scaleX: _scale, scaleY: _scale});
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
			isMoved=true;
			checkArr[index]=true;
			for each (var b:Boolean in checkArr)
			{
				if (!b)
					return;
			}
			dispatchEvent(new Event(PalaceGame.GAME_OVER));
		}

		private var bodyArr:Vector.<OperaBody>=new Vector.<OperaBody>();

		private function addBodys():void
		{
			for (var i:int=0; i < crtTypeArr.length; i++)
			{
				addOneBody(i);
			}
		}

		private var crtTypeArr:Array;
		private var crtBodyPosArr:Array; //头,身子 相对位置
		private var crtB_HPosArr:Array; //头,身子 相对位置
		private var crtMaskPosArr:Array; //脸谱,相对位置

		private var xiyouTypeArr:Array=["7", "6", "3", "5", "4", "1"];
		private var xiyouBodyPosArr:Array=[new Point(836, 144), new Point(380, 380),
			new Point(649, 375), new Point(274, 634), new Point(528, 632), new Point(773, 644)];
		private var xiyouB_PosArr:Array=[new Point(-104, 2), new Point(-3, 87), new Point(-3, 98), new Point(21, 123), new Point(-7, 88), new Point(33, 107)];
		private var xiyouMaskPosArr:Array=[new Point(0, 0), new Point(16, 43), new Point(30, 37), new Point(28, 69), new Point(7, 23), new Point(30, 44)];

		private var sanguoTypeArr:Array=["1", "2", "3", "4", "5", "6"];
		private var sanguoBodyPosArr:Array=[new Point(131, 148), new Point(450, 154),
			new Point(900, 153), new Point(300, 400), new Point(521, 400), new Point(738, 380)];
		private var sanguoB_PosArr:Array=[new Point(6, 114), new Point(21, 115),
			new Point(22, 111), new Point(-16, 68), new Point(-6, 117), new Point(-32, 58)];
		private var sanguoMaskPosArr:Array=[new Point(18, 41), new Point(15, 64),
			new Point(22, 50), new Point(25, 41), new Point(22, 54), new Point(6, 46)];

		private function addOneBody(index:int):void
		{
			var body:OperaBody=new OperaBody();
			body.index=index;
			var type:String=crtTypeArr[index];
			body.type=type;
			body.body=getImage(crtOperaName + "body" + type);
			body.head=getImage(crtOperaName + "head" + type);
			body.countBG=getImage("body-countdown");
			body.stagePt=crtBodyPosArr[index] //位置 by index
			body.offsetsXY=crtB_HPosArr[index];
			body.maskPos=crtMaskPosArr[index]; //相对位置 by type
			if (index == 5 && gameLevel == 1)
				body.fixY=38;
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
			if (gameLevel == 0)
				if (index < 1)
					sp=spArr[0];
				else if (index < 3)
					sp=spArr[1];
				else
					sp=spArr[2];
			else
				sp=index < 3 ? spArr[0] : spArr[1]
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

			moutainHolder=new Sprite();
			addChild(moutainHolder);
			fireMountain=getImage("firemoutain");
			moutainHolder.addChild(fireMountain);
			moutainHolder.pivotX=fireMountain.width >> 1;
			moutainHolder.pivotY=fireMountain.height;
			moutainHolder.scaleX=moutainHolder.scaleY=.01;
			moutainHolder.x=387;
			moutainHolder.y=200;
			firMountainOpen=false;
		}

		private var moutainHolder:Sprite;

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
