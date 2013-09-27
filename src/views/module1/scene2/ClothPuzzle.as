package views.module1.scene2
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import models.SOService;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	[Event(name="allMatched", type="starling.events.Event")]
	public class ClothPuzzle extends Sprite
	{
		private var am:AssetManager;

		private var clothXOffset:Number;
		private var clothYOffset:Number;
		private var itemWidth:Number;
		private var itemHeight:Number;

		private var correctCircleDic:Dictionary;
		private var ready:Boolean;
		private var matchedGlow:Image;
		private var currentPositionDic:Dictionary;
		private var correctPositionDic:Dictionary;

		private var scale:Number=DPIUtil.getDPIScale();

		override public function dispose():void
		{
			am=null;
			super.dispose();
		}

		private var puzzleHintCount:String="puzzleHintCount";
		private var isMoved:Boolean;
		private var hintShow:Sprite;
		private var count:int=0;
		private var puzzleHint:Image;
		private var hintReverse:Boolean;

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
					puzzleHint=new Image(am.getTexture('puzzlehint'));
					puzzleHint.x=246;
					puzzleHint.y=42;
					hintShow.addChild(puzzleHint);
					addChild(hintShow);
					hintShow.touchable=false;
				}
				else
				{
					if (puzzleHint.alpha == 0)
						hintReverse=false;
					else if (puzzleHint.alpha == 1)
						hintReverse=true;
					puzzleHint.alpha+=hintReverse ? -.05 : .1;
				}
			}
		}

		private function generateRandomPositions(points:Array):Array
		{
			var randomPoints:Array=[];
			var arr:Array=[points[1], points[2], points[3]];
			var r:int=Math.floor(Math.random() * 3);
			randomPoints[0]=arr[r];
			arr.splice(0, 1);
			if (r != 0)
			{
				arr.splice(arr.indexOf(randomPoints[0]), 1);
				r=Math.floor(Math.random() * 2);
			}
			else
			{
				r=Math.floor(Math.random() * 3);
			}
			arr.unshift(points[0]);
			randomPoints[1]=arr[r];
			arr.splice(arr.indexOf(randomPoints[1]), 1);
			while (randomPoints && !randomPoints[3])
			{
				var leftPoint:Point;
				for each (leftPoint in points)
				{
					if (randomPoints.indexOf(leftPoint) == -1)
					{
						if (!randomPoints[2] && leftPoint != points[2])
							randomPoints[2]=leftPoint;
						else if (!randomPoints[3])
						{
							if (leftPoint != points[3])
								randomPoints[3]=leftPoint;
							else
								randomPoints=null;
						}
					}
				}
			}
			return randomPoints;
		}

		public function ClothPuzzle(am:AssetManager)
		{
			super();
			this.am=am;
			addChild(new Image(am.getTexture('bgquiz')));
			matchedGlow=new Image(am.getTexture('bgquizshadow'));
			matchedGlow.alpha=0;
			addChild(matchedGlow);

			var points:Array=[new Point(151, 95), new Point(330, 64), new Point(510, 95), new Point(689, 73)];
			correctPositionDic=new Dictionary();
			var clothPoints:Dictionary;
			clothPoints=new Dictionary();
			clothPoints['日']=points[0];
			clothPoints['月']=points[1];
			clothPoints['天']=points[2];
			clothPoints['地']=points[3];

			correctCircleDic=new Dictionary();
			clothDic=new Dictionary();
			currentPositionDic=new Dictionary();


			while (!randomPoints)
			{
				randomPoints=generateRandomPositions(points);
			}

			ia=new Dictionary();
			for (var key:String in clothPoints)
			{
				var p:Point=clothPoints[key];
				var i:Image=new Image(am.getTexture('quiz-matchsign'));
				i.alpha=0;
				i.x=p.x;
				i.y=p.y;
				addChild(i);
				var ci:Image=new Image(am.getTexture('quiz-' + key + ''));
				clothXOffset=(i.width - ci.width) / 2;
				clothYOffset=(i.height - ci.height) / 2;
				itemHeight=ci.height;
				itemWidth=ci.width;
				ci.x=p.x + clothXOffset;
				ci.y=p.y + clothYOffset;
				addChild(ci);
				ci.alpha=0;
				var pi:int=points.indexOf(p);
				TweenLite.to(ci, 0.3, {alpha: 1, delay: pi * 0.2});
				clothDic[key]=ci;
				currentPositionDic[ci]=randomPoints[pi];
				correctPositionDic[ci]=points[pi];
				correctCircleDic[ci]=i;
				ia[ci]=pi;
			}

//			trace(width, height);
		}

		public function activate():void
		{
			TweenLite.delayedCall(0.8, function():void
			{
				for each (var cloth:Image in clothDic)
				{
					var top:Point=randomPoints[ia[cloth]];
					TweenLite.to(cloth, 0.5, {x: top.x + clothXOffset, y: top.y + clothYOffset, ease: Cubic.easeIn, onComplete: function():void
					{
						ready=true;
					}});
				}
			});

			addEventListener(TouchEvent.TOUCH, touchHandler);
			if (SOService.instance.checkHintCount(puzzleHintCount))
				addEventListener(Event.ENTER_FRAME, onEnterFrame);

		}

		private var dragingCloth:Image;
		private var otherCloth:Image;
		private var downPoint:Point;

		private var ia:Dictionary;

		private var clothDic:Dictionary;

		private var randomPoints:Array;

		private function touchHandler(event:TouchEvent):void
		{
			if (ready)
			{
				var touch:Touch=event.getTouch(stage);
				if (!touch)
					return;
				var p:Point;
				if (touch.phase == TouchPhase.BEGAN)
				{
					checkPointInRect(new Point(touch.globalX / scale, touch.globalY / scale), true);
					if (dragingCloth)
					{
						downPoint=new Point(touch.globalX / scale, touch.globalY / scale);
						setChildIndex(dragingCloth, numChildren - 1);
					}
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					if (dragingCloth)
					{
						p=currentPositionDic[dragingCloth];
						dragingCloth.x=p.x + (touch.globalX / scale - downPoint.x) + itemWidth / 2;
						dragingCloth.y=p.y + (touch.globalY / scale - downPoint.y) + itemHeight / 2;
					}
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					if (dragingCloth)
						checkPointInRect(new Point(touch.globalX / scale, touch.globalY / scale));
				}
			}
		}

		private function checkPointInRect(point:Point, useInBegin:Boolean=false):void
		{
			var p:Point;
			if (!useInBegin && !dragingCloth)
				return;
			var hasHited:Boolean;
			for (var i:Image in currentPositionDic)
			{
				p=currentPositionDic[i];
				if (i != dragingCloth)
				{
					var r:Rectangle=new Rectangle(p.x + clothXOffset, p.y + clothYOffset, itemWidth, itemHeight);
					if (r.contains(point.x, point.y))
					{
						hasHited=true;
						if (useInBegin)
						{
							dragingCloth=i;
						}
						else if (dragingCloth)
						{
							ready=false;
							otherCloth=i;
							var dp:Point=currentPositionDic[dragingCloth];
							TweenLite.to(dragingCloth, 0.5, {x: p.x + clothXOffset, y: p.y + clothYOffset, ease: Cubic.easeOut});
							TweenLite.to(i, 0.5, {x: dp.x + clothXOffset, y: dp.y + clothYOffset, ease: Cubic.easeOut, onComplete: function():void
							{
								currentPositionDic[dragingCloth]=p;
								if (p.x == correctPositionDic[dragingCloth].x) {
									TweenLite.to(correctCircleDic[dragingCloth], 0.5, {alpha: 1});
									isMoved=true;
								}
								else
									TweenLite.to(correctCircleDic[dragingCloth], 0.5, {alpha: 0});
								currentPositionDic[i]=dp;
								if (dp.x == correctPositionDic[i].x)
									TweenLite.to(correctCircleDic[i], 0.5, {alpha: 1, onComplete: function():void
									{
										isMoved=true;
										var allMatched:Boolean=true;
										for each (i in correctCircleDic)
										{
											if (i.alpha == 0)
											{
												allMatched=false;
												break;
											}
										}
										if (allMatched)
										{
//											trace('all matched');
											TweenLite.to(matchedGlow, 0.8, {alpha: 1, onComplete: function():void
											{
												dispatchEvent(new Event('allMatched'));
											}});
										}
									}});
								else
									TweenLite.to(correctCircleDic[i], 0.5, {alpha: 0});
								ready=true;
								dragingCloth=null;
							}});
						}
						break;
					}
				}
			}
			if (dragingCloth && !useInBegin && !hasHited)
			{
				p=currentPositionDic[dragingCloth];
				ready=false;
				TweenLite.to(dragingCloth, 0.5, {x: p.x + clothXOffset, y: p.y + clothYOffset, ease: Cubic.easeOut, onComplete: function():void
				{
					ready=true;
				}});
				dragingCloth=null;
			}
		}
	}
}


