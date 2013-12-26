package views.module1.scene12
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
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
			if (count < 30 * 5)
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

		private function showKnowledge(type:String, isWin:Boolean=false):void
		{
			if (matchedGlow.alpha > 0)
				return;
			var txt:String=json[type];
			if (!knowledgeHolder)
			{
				knowledgeHolder=new Sprite();
				knowledgeHolder.x=width >> 1;
				knowledgeHolder.y=680;
				var knowledgeBG:Image=new Image(am.getTexture("hintbar"));
				knowledgeHolder.addChild(knowledgeBG);
				knowledgeHolder.pivotX=knowledgeBG.width >> 1;
				knowledgeHolder.pivotY=knowledgeBG.height >> 1;
				knowledgeTF=new TextField(knowledgeBG.width - 30, knowledgeBG.height - 10, txt, FontVo.PALACE_FONT, 20, 0x561a1a, true);
				knowledgeTF.x=knowledgeBG.x + 15;
				knowledgeTF.y=knowledgeBG.y + 3;
				knowledgeHolder.addChild(knowledgeTF);
				knowledgeTF.touchable=false;
				knowledgeTF.hAlign="center";
				addChild(knowledgeHolder);
			}
			knowledgeTF.text=txt;
		}

		public function ClothPuzzle(am:AssetManager)
		{
			super();
			this.am=am;
			json=am.getObject("hint12").hint;
			addChild(new Image(am.getTexture('bgquiz')));
			matchedGlow=new Image(am.getTexture('bgquizshadow'));
			matchedGlow.alpha=0;
			addChild(matchedGlow);

			points=[new Point(151, 95), new Point(330, 64), new Point(510, 95), new Point(689, 73)];
			var points1:Array=[new Point(238, 262), new Point(427, 233), new Point(608, 264), new Point(797, 242)];
			var points2:Array=[new Point(74, 257), new Point(309, 248), new Point(482, 257), new Point(671, 240)];
			pst=["日", "月", "天", "地"];
			correctPositionDic=new Dictionary();

			clothPoints=new Dictionary();
			clothPoints['日']=points[0];
			clothPoints['月']=points[1];
			clothPoints['天']=points[2];
			clothPoints['地']=points[3];

			var lightPts:Dictionary=new Dictionary();
			lightPts['日']=points1[0];
			lightPts['月']=points1[1];
			lightPts['天']=points1[2];
			lightPts['地']=points1[3];

			var boxLightPts:Dictionary=new Dictionary();
			boxLightPts['日']=points2[0];
			boxLightPts['月']=points2[1];
			boxLightPts['天']=points2[2];
			boxLightPts['地']=points2[3];

			correctCircleDic=new Dictionary();
			clothDic=new Dictionary();
			currentPositionDic=new Dictionary();
			lightDic=new Dictionary();


			while (!randomPoints)
			{
				randomPoints=generateRandomPositions(points);
			}

			ia=new Dictionary();
			var index:int=0;
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

				var light:Sprite=new Sprite();
				var line:Sprite=new Sprite();
				var img:Image=new Image(am.getTexture("light" + key));
				line.addChild(img);
				line.clipRect=new Rectangle(0, -img.height, img.width, img.height);
				line.x=lightPts[key].x;
				line.y=lightPts[key].y;

				var halo:Image=new Image(am.getTexture("boxlight" + key));
				halo.alpha=0;
				halo.x=boxLightPts[key].x;
				halo.y=boxLightPts[key].y;

				light.addChild(line);
				light.addChild(halo);
				light.touchable=false;
				addChild(light);
				lightDic[ci]=light;

				index++;
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
						showKnowledge("puzzle-default");
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
		private var lightDic:Dictionary;
		private var json:Object;
		private var knowledgeHolder:Sprite;
		private var knowledgeTF:TextField;

		private var clothPoints:Dictionary;

		private var pst:Array;

		private var points:Array;

		private function touchHandler(event:TouchEvent):void
		{
			if (ready)
			{
				var touch:Touch=event.getTouch(this);
				if (!touch)
					return;
				var p:Point;
				var pt:Point=touch.getLocation(this);
				if (touch.phase == TouchPhase.BEGAN)
				{
					checkPointInRect(pt, true);
					if (dragingCloth)
					{
						if (correctCircleDic[dragingCloth].alpha > 0)
							dragingCloth=null;
						else
						{
							downPoint=pt;
							setChildIndex(dragingCloth, numChildren - 1);
						}
					}
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					if (dragingCloth)
					{
						p=currentPositionDic[dragingCloth];
						dragingCloth.x=p.x + (pt.x - downPoint.x) + itemWidth / 2;
						dragingCloth.y=p.y + (pt.y - downPoint.y) + itemHeight / 2;
					}
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					if (dragingCloth)
						checkPointInRect(pt);
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

							var id:String=pst[points.indexOf(correctPositionDic[dragingCloth])];
							showKnowledge(id);

						}
						else if (dragingCloth)
						{
							ready=false;
							otherCloth=i;
							var dp:Point=currentPositionDic[dragingCloth];
							if (correctCircleDic[i].alpha > 0)
							{
								TweenLite.to(dragingCloth, 0.5, {x: dp.x + clothXOffset, y: dp.y + clothYOffset, ease: Cubic.easeOut, onComplete: function():void {
									dragingCloth=null;
									ready=true;
								}});
								return;
							}
							SoundAssets.playSFX("switching", true);
							TweenLite.to(dragingCloth, 0.5, {x: p.x + clothXOffset, y: p.y + clothYOffset, ease: Cubic.easeOut});
							TweenLite.to(i, 0.5, {x: dp.x + clothXOffset, y: dp.y + clothYOffset, ease: Cubic.easeOut, onComplete: function():void
							{
								currentPositionDic[dragingCloth]=p;
								if (p.x == correctPositionDic[dragingCloth].x) {
									var sp:Sprite=lightDic[dragingCloth];
									TweenLite.to(correctCircleDic[dragingCloth], 0.5, {alpha: 1, onComplete: function():void {
										playLight(sp);
									}});
									isMoved=true;
								}
								else
									TweenLite.to(correctCircleDic[dragingCloth], 0.5, {alpha: 0});
								currentPositionDic[i]=dp;
								if (dp.x == correctPositionDic[i].x)
								{
									var sp2:Sprite=lightDic[i];
									TweenLite.to(correctCircleDic[i], 0.5, {alpha: 1, onComplete: function():void
									{
										playLight(sp2);
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
											TweenLite.to(knowledgeHolder, 1, {alpha: 0})
											TweenLite.to(matchedGlow, 2, {alpha: 1, onComplete: function():void
											{
												dispatchEvent(new Event('allMatched'));
											}});
										}
									}});
								}
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

		private function playLight(sp:Sprite):void
		{
			if (!sp)
				return;
			SoundAssets.playSFX("blockmatch", true);
			var img1:Sprite=sp.getChildAt(0) as Sprite;
			var img2:Image=sp.getChildAt(1) as Image;

			if (img1 && img2)
			{
//				img1.clipRect=new Rectangle(0, -img1.height, img1.width, img1.height);
//				var h:Number=img1.height;
				TweenLite.to(img1.clipRect, .3, {y: 0, onComplete: function():void {
					TweenLite.to(img2, .3, {alpha: 1});
				}});
			}
		}
	}
}


