package views.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.global.TailBar;
	import views.module1.scene12.Cloth2;
	import views.module1.scene12.ClothCircle;
	import views.module1.scene12.ClothPuzzle;

	/**
	 * 早起模块
	 * 换装场景
	 * @author Administrator
	 */
	public class Scene12 extends PalaceScene
	{
		private var bgHolder:Sprite;

		private var kingHolder:Sprite;
		private var boxHolder:Sprite;

		private var box:Image;

		private var boxCover:Sprite;
		private var _opened:Boolean;
		private var scale:Number=DPIUtil.getDPIScale();

		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(value:Boolean):void
		{
			if (_opened != value)
			{
				_opened=value
				if (value)
				{
					var dx:Number=boxCover.x + 400;
					TweenLite.to(boxCover, .2, {y: -50, onComplete: function():void {
						TweenLite.to(boxCover, .5, {x: dx, onComplete: initCircle});
					}
								 });
				}
				else
					TweenLite.to(boxHolder, .5, {x: 1100});
			}
		}

		private var clothHintCount:String="clothHintCount";
		private var count:int=0;
		private var hintFinger:Image;

		private var quizSolved:Boolean;
		private var index:int=0;

		public function Scene12(am:AssetManager)
		{
			super(am);
			crtKnowledgeIndex=2;

			json=assetManager.getObject("hint12").hint;
		}

		override protected function init():void
		{
			taskType=int(Math.random() * clothArr.length);

			bgHolder=new Sprite();
			addChild(bgHolder);

			bgHolder.addChild(getImage("background12"));

			addCircle();
			addKing();
			addBox();

			showLionHint("hint-start", null, false);
		}

		private function showLionHint(content:String, callback:Function=null, isTask:Boolean=false):void
		{
			var txt:String=json[content];
			LionMC.instance.say(txt, 0, 0, 0, callback, 20, 1, isTask);
		}

		private function addBox():void
		{
			boxHolder=new Sprite();
			addChild(boxHolder);
			boxHolder.x=686;
			boxHolder.y=572;

			box=getImage("box");
			box.addEventListener(TouchEvent.TOUCH, onClickBox);
			boxCover=new Sprite();
			boxCover.addChild(getImage("boxcover"));
			boxCover.pivotX=boxCover.width >> 1;
			boxCover.x=box.width / 2;
			boxCover.y=-4;

			boxHolder.addChild(box);
			boxHolder.addChild(boxCover);
		}

		private var posArr:Array=[new Point(90, 560), new Point(530, 200), new Point(530, 610)];

		private var lionX:int=-140;
		private var lionDX:int=20;

		private static var clothArr:Array=["朝服", "行服", "雨服", "龙袍", "常服"];
		private static var hatArr:Array=["朝帽", "行帽", "雨帽", "龙帽", "常帽"];

		private var json:Object;

		private function addCircle():void
		{
			for (var i:int=0; i < clothArr.length; i++)
			{
				var cloth:Cloth2=new Cloth2();
				cloth.cloth=getImage(clothArr[i]);
				cloth.hat=getImage(hatArr[i]);
				cloth.type=clothArr[i];
				dataArr.push(cloth);
			}
			shuffleArr(dataArr, 5);
			if ((dataArr[0].type) == clothArr[taskType])
			{
				dataArr=dataArr.reverse();
			}
			circle=new ClothCircle();
			circle.readyCallback=initMission;
			circle.dataArr=dataArr;
			circle.light=assetManager.getTexture("light");
			addChild(circle);
			circle.x=533;
			circle.y=653;
			circle.checkIndex=checkIndex;
		}

		private var taskType:int=0;

		private function shuffleArr(arr:Array, times:int):void
		{
			var len:int=arr.length;
			if (len < 2)
				return;
			for (var i:int=0; i < times; i++)
			{
				arr.push(arr.splice(int(Math.random() * len), 1)[0])
			}
		}

		private var dataArr:Array=[];

		private var circle:ClothCircle;

		private var backSP:Sprite;

		private var frontSP:Sprite;

		private function onClickBox(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(box, TouchPhase.ENDED);
			if (tc)
			{
				box.removeEventListener(TouchEvent.TOUCH, onClickBox);
				var quiz:ClothPuzzle=new ClothPuzzle(assetManager);

				var sx:Number=boxHolder.x + 50;
				var sy:Number=boxHolder.y;

				var ex:Number=0;
				var ey:Number=(768 - quiz.height) / 2;

				addChild(quiz);

				quiz.x=sx;
				quiz.y=sy;
				quiz.scaleX=quiz.scaleY=.2;

				SoundAssets.playSFX("boxscale");
				TweenLite.to(quiz, 1, {scaleX: 1, scaleY: 1, x: ex, y: ey, onComplete: function():void
				{
					TweenLite.delayedCall(2, function():void
					{
						showLionHint("hint-quizstart", null, true);
					});
					quiz.addEventListener("allMatched", onQuizDone);
					quiz.activate();
				}});
			}
		}

		private function onQuizDone(e:Event):void
		{
			var quiz:ClothPuzzle=e.currentTarget as ClothPuzzle;
			TweenLite.to(quiz, .5, {scaleX: .2, scaleY: .2, x: boxHolder.x + 50, y: boxHolder.y, onComplete: function():void
			{
				quiz.parent.removeChild(quiz);

				SoundAssets.playSFX("boxopen");
				opened=true;
			}});
		}

		private function initMission():void
		{
			playKing(1);
			opened=false;
			var str:String=clothArr[taskType];
			showLionHint("hint-find-" + str, function():void {
				addEventListener(TouchEvent.TOUCH, onDrag);
			}, true);
		}

		private var speedX:Number=0;
		private var knowledgeHolder:Sprite;
		private var knowledgeTF:TextField;

		private function checkIndex(type:String):void
		{
			var isWin:Boolean;
			if (type == clothArr[taskType])
			{
				isWin=true;
				SoundAssets.playSFX("happy");
				playKing(0);
			}
			else
			{
				var _index:int=Math.random() > .6 ? 1 : (Math.random() > .5 ? 2 : 3);
				playKing(_index);
			}
			showKnowledge(type, isWin);
		}

		private function showKnowledge(type:String, isWin:Boolean=false):void
		{
			var txt:String=json["hint-ok-" + type];
			if (!knowledgeHolder)
			{
				knowledgeHolder=new Sprite();
				addChild(knowledgeHolder);
				knowledgeHolder.x=532;
				knowledgeHolder.y=720;
				var knowledgeBG:Image=getImage("hintbar");
				knowledgeHolder.addChild(knowledgeBG);
				knowledgeHolder.pivotX=knowledgeBG.width >> 1;
				knowledgeHolder.pivotY=knowledgeBG.height >> 1;
				knowledgeTF=new TextField(knowledgeBG.width - 30, knowledgeBG.height - 10, txt, FontVo.PALACE_FONT, 20, 0x561a1a, true);
				knowledgeTF.x=knowledgeBG.x + 15;
				knowledgeTF.y=knowledgeBG.y + 3;
				knowledgeHolder.addChild(knowledgeTF);
				knowledgeTF.touchable=false;
				knowledgeTF.hAlign="center";
			}
			knowledgeTF.text=txt;

			var txt2:String=json["hint-head-" + type];
			var img:Image=getImage(txt2);
			if (headP)
				headP.playHide();
			var cb:Function;
			if (isWin)
			{
				if (!SOService.instance.getSO("collection_card_0collected"))
					addMask(0);
				TailBar.hide();
				cb=function():void {
					showCard("0", function():void {
						showAchievement(2, sceneOver);
					});
				}
			}
			if (img)
				headP=Prompt.showIMG(632, 200, img, cb, this);
			else
				headP=Prompt.showTXT(632, 200, txt2, 20, cb, this);
		}

		private var headP:Prompt;

		private function initCircle():void
		{
			circle.sp1=frontSP;
			circle.sp2=backSP;
			circle.initCircle();

			var quad:Quad=new Quad(1024, 768, 0);
			quad.alpha=0;
			bgHolder.addChild(quad);

			TweenLite.to(quad, 1, {alpha: .6});
			quizSolved=true;
		}

		private var dragging:Boolean;
		private var dpt:Point;

		private function onDrag(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					dpt=pt;
					dragging=false;
					circle.startDrag();
					break;
				}

				case TouchPhase.MOVED:
				{
					if (Math.abs(dpt.x - pt.x) > 10)
						dragging=true;
					if (dragging)
					{
						var move:Point=tc.getMovement(this);
						speedX=move.x / 200 / Math.PI;
						circle.angle-=speedX;
					}
					break;
				}

				case TouchPhase.STATIONARY:
				{
					speedX=0;
					trace("stay")
					break;
				}

				case TouchPhase.ENDED:
				{
//					if (dragging)
					circle.tweenPlay(speedX);
					dragging=false;
					speedX=0;
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private var expArr:Array=["kingHappy", "kingLook", "KingNaughty"];

		private var kingHead:MovieClip;

		private function addKing():void
		{
			backSP=new Sprite();
			frontSP=new Sprite();

			kingHolder=new Sprite();
			playKing(0);
			var king:Image=getImage("king12")
			king.x=-1;
			king.y=2;
			kingHolder.addChild(king);
			kingHolder.pivotX=king.width >> 1;
			kingHolder.pivotY=king.height;

			addChild(backSP);
			addChild(kingHolder);
			addChild(frontSP);
			backSP.x=frontSP.x=kingHolder.x=533;
			backSP.y=frontSP.y=kingHolder.y=653;

			king.addEventListener(TouchEvent.TOUCH, onKingTouch);
		}

		private function onKingTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(kingHolder, TouchPhase.ENDED);
			if (tc)
				playKing(int(Math.random() * expArr.length))
		}

		public function playKing(expressionIndex:int):void
		{
			if (kingDelay)
			{
				kingDelay.kill();
				kingDelay=null;
			}
			if (kingHead)
			{
				kingHead.stop();
				Starling.juggler.remove(kingHead);
				kingHead.removeFromParent(true);
				kingHead=null;
			}

			kingHead=new MovieClip(assetManager.getTextures(expArr[expressionIndex]), 18);
			kingHead.loop=0;
			kingHead.play();
			Starling.juggler.add(kingHead);
			kingHead.x=62;
			kingHead.y=108;
			kingHolder.addChildAt(kingHead, 0);

			if (quizSolved)
			{
				var _index:int=Math.random() > .7 ? 1 : 2;
				kingDelay=TweenLite.delayedCall(8, playKing, [_index]);
			}
		}

		override public function dispose():void
		{
			if (kingDelay)
			{
				kingDelay.kill();
				kingDelay=null;
			}
			if (kingHead)
			{
				kingHead.stop();
				Starling.juggler.remove(kingHead);
				kingHead.removeFromParent(true);
				kingHead=null;
			}
			super.dispose();
		}

		private var kingDelay:TweenLite;
//		private var lastTask:Boolean;
	}
}

