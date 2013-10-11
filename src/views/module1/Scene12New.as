package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.pamakids.palace.utils.SPUtils;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module1.scene12.BoxCellRenderer;
	import views.module1.scene12.Cloth;
	import views.module1.scene12.Cloth2;
	import views.module1.scene12.ClothCircle;
	import views.module1.scene12.ClothPuzzle;

	/**
	 * 早起模块
	 * 换装场景
	 * @author Administrator
	 */
	public class Scene12New extends PalaceScene
	{
		private var bg:Sprite;

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
				TweenLite.to(boxCover, 1, {y: (value ? -272 : -4)});
			}
		}

		private var clothHintCount:String="clothHintCount";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var hintFinger:Image;

		private function onEnterFrame(e:Event):void
		{
			if (isMoved)
			{
				if (hintShow)
					hintShow.removeFromParent(true);
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			if (count < 30 * 8)
				count++;
			else
			{
				if (!hintShow)
				{
					hintShow=new Sprite();
					var hintArrow:Image=getImage("clothhintarrow");
					hintFinger=getImage("clothhintfinger");
					hintArrow.x=596;
					hintArrow.y=354;
					hintFinger.x=789;
					hintFinger.y=414;
					hintShow.addChild(hintArrow);
					hintShow.addChild(hintFinger);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (hintFinger.x == 589)
					{
						hintFinger.scaleX=hintFinger.scaleY=1;
					}
					else if (hintFinger.x == 789)
					{
						hintFinger.scaleX=hintFinger.scaleY=.8;
					}
					hintFinger.x+=hintFinger.scaleX == 1 ? 10 : -10;
				}
			}
		}

		private var quizSolved:Boolean;
		private var index:int=0;

		public function Scene12New(am:AssetManager)
		{
			super(am);
			crtKnowledgeIndex=2;

			json=assets.getObject("hint12").hint;
		}

		override protected function init():void
		{
			taskType=int(Math.random() * clothArr.length);

			bg=new Sprite();
			addChild(bg);

			bg.addChild(getImage("background12"));

			addCircle();
			addKing();
			addBox();
			addLion();
		}

		private function showLionHint(content:String, callback:Function=null):void
		{
			crtLionContent=content;
			showHint(content, 0, callback);
		}

		private function nextScene():void
		{
			showCard("dragonRobe");
			TweenLite.to(lion, 1, {x: lionX, onComplete: sceneOver});
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

		private function showHint(content:String, posIndex:int, callback:Function=null):void
		{
			var pos:Point=posArr[posIndex];
			var txt:String=json[content];
			Prompt.showTXT(pos.x, pos.y, txt, 20, callback, this);
		}

		private var posArr:Array=[new Point(90, 560), new Point(530, 200), new Point(530, 610)];

		private var lionX:int=-140;
		private var lionDX:int=20;

		private function addLion():void
		{
			lion=new Sprite();
			lion.addChild(getImage("lion"));
			addChild(lion);

			lion.x=lionX;
			lion.y=300;
			lion.rotation=-Math.PI / 4;


			TweenLite.to(lion, 1, {x: lionDX, y: 540, rotation: 0, ease: Elastic.easeOut, onComplete: function():void
			{
				showLionHint("hint-start");
				lion.addEventListener(TouchEvent.TOUCH, onLionTouch);
			}});
		}

		private function onLionTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
				showLionHint(crtLionContent);
		}

		private static var clothArr:Array=["朝服", "行服", "雨服", "龙袍", "常服"];
		private static var hatArr:Array=["朝帽", "行帽", "雨帽", "龙帽", "常帽"];

		private var lion:Sprite;
		private var crtLionContent:String;

		private var json:Object;

		private function addCircle():void
		{
			for (var i:int=0; i < clothArr.length; i++)
			{
				var cloth:Cloth2=new Cloth2();
				cloth.cloth=getImage(clothArr[i]);
				cloth.hat=getImage(hatArr[i]);
				cloth.type=i;
				cloth.light=getImage("circlelight");
				dataArr.push(cloth);
			}
			shuffleArr(dataArr, 5);
			if ((dataArr[0].type) == taskType)
			{
				dataArr=dataArr.reverse();
			}
			circle=new ClothCircle();
			circle.dataArr=dataArr;
			circle.circle=getImage("circle");
			addChild(circle);
			circle.x=547;
			circle.y=612;
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
			var tc:Touch=e.getTouch(stage, TouchPhase.BEGAN);
			if (tc)
			{
				box.removeEventListener(TouchEvent.TOUCH, onClickBox);
				var quiz:ClothPuzzle=new ClothPuzzle(assets);

				var sx:Number=boxHolder.x + 50;
				var sy:Number=boxHolder.y;

				var ex:Number=0;
				var ey:Number=(768 - quiz.height) / 2;

				addChild(quiz);
				setChildIndex(lion, numChildren - 1);

				quiz.x=sx;
				quiz.y=sy;
				quiz.scaleX=quiz.scaleY=.2;

				TweenLite.to(quiz, 1, {scaleX: 1, scaleY: 1, x: ex, y: ey, onComplete: function():void
				{
					TweenLite.delayedCall(2, function():void
					{
						showLionHint("hint-quizstart");
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

				opened=true;
				crtKnowledgeIndex=3;
				TweenLite.delayedCall(2, function():void
				{
					showLionHint("hint-gamestart", initMission);
				});
			}});
		}

		private function initMission():void
		{
			var str:String=clothArr[taskType];
			showLionHint("hint-find-" + str, initCircle);
		}

		private function initCircle():void
		{
			circle.sp1=frontSP;
			circle.sp2=backSP;
			circle.initCircle();

			TweenLite.to(circle, .6, {alpha: 1, onComplete: function():void {
				addEventListener(TouchEvent.TOUCH, onDrag);
			}});
		}

		private function onDrag(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{

					break;
				}

				case TouchPhase.MOVED:
				{
					var move:Point=tc.getMovement(this);
					circle.angle-=move.x / 200 / Math.PI;
					break;
				}

				case TouchPhase.ENDED:
				{

					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function addKing():void
		{
			backSP=new Sprite();
			frontSP=new Sprite();

			kingHolder=new Sprite();
			kingHolder.addChild(getImage("king12"));
			SPUtils.registSPCenter(kingHolder, 2);

			addChild(backSP);
			addChild(kingHolder);
			addChild(frontSP);
			backSP.x=frontSP.x=kingHolder.x=547;
			backSP.y=frontSP.y=kingHolder.y=612;
		}
	}
}

