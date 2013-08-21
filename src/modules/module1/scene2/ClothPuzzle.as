package modules.module1.scene2
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.palace.base.PalaceScene;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

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

		private var xoffset:Number;
		private var yoffset:Number;
		private var itemWidth:Number;
		private var itemHeight:Number;

		private var signDic:Dictionary;
		private var clothDic:Dictionary;
		private var begin:Boolean;
		private var shadow:Image;
		private var initPositionDic:Dictionary;
		private var rightPositionDic:Dictionary;

		override public function dispose():void{
			am=null;
			super.dispose();
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
			while (randomPoints&&!randomPoints[3])
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
			shadow=new Image(am.getTexture('bgquizshadow'));
			shadow.alpha=0;
			addChild(shadow);

			var points:Array=[new Point(151, 95), new Point(330, 64), new Point(510, 95), new Point(689, 73)];
			rightPositionDic=new Dictionary();
			var clothPoints:Dictionary;
			clothPoints=new Dictionary();
			clothPoints['日']=points[0];
			clothPoints['月']=points[1];
			clothPoints['天']=points[2];
			clothPoints['地']=points[3];

			signDic=new Dictionary();
			clothDic=new Dictionary();
			initPositionDic=new Dictionary();

			var randomPoints:Array;
			while (!randomPoints)
			{
				randomPoints=generateRandomPositions(points);
			}

			var ia:Dictionary=new Dictionary();
			for (var key:String in clothPoints)
			{
				var p:Point=clothPoints[key];
				var i:Image=new Image(am.getTexture('quiz-matchsign.png'));
				i.alpha=0;
				i.x=p.x;
				i.y=p.y;
				addChild(i);
				var ci:Image=new Image(am.getTexture('quiz-' + key + '.png'));
				xoffset=(i.width - ci.width) / 2;
				yoffset=(i.height - ci.height) / 2;
				itemHeight=ci.height;
				itemWidth=ci.width;
				ci.x=p.x + xoffset;
				ci.y=p.y + yoffset;
				addChild(ci);
				ci.alpha=0;
				var pi:int=points.indexOf(p);
				TweenLite.to(ci, 0.3, {alpha: 1, delay: pi * 0.2});
				clothDic[key]=ci;
				initPositionDic[ci]=randomPoints[pi];
				rightPositionDic[ci]=points[pi];
				signDic[ci]=i;
				ia[ci]=pi;
			}
			TweenLite.delayedCall(0.8, function():void
			{
				for each (var cloth:Image in clothDic)
				{
					var top:Point=randomPoints[ia[cloth]];
					TweenLite.to(cloth, 0.5, {x: top.x + xoffset, y: top.y + yoffset, ease: Cubic.easeIn, onComplete: function():void
					{
						begin=true;
					}});
				}
			});

			addEventListener(TouchEvent.TOUCH, touchHandler);

			trace(width, height);
		}

		private var dragingImage:Image;
		private var otherImage:Image;
		private var downPoint:Point;

		private function touchHandler(event:TouchEvent):void
		{
			if (begin)
			{
				var touch:Touch=event.getTouch(stage);
				if (!touch)
					return;
				var p:Point;
				if (touch.phase == TouchPhase.BEGAN)
				{
					checkPointInRect(new Point(touch.globalX, touch.globalY), true);
					if (dragingImage)
					{
						downPoint=new Point(touch.globalX, touch.globalY);
						setChildIndex(dragingImage, numChildren - 1);
					}
				}
				else if (touch.phase == TouchPhase.MOVED)
				{
					if (dragingImage)
					{
						p=initPositionDic[dragingImage];
						dragingImage.x=p.x + (touch.globalX - downPoint.x) + itemWidth / 2;
						dragingImage.y=p.y + (touch.globalY - downPoint.y) + itemHeight / 2;
					}
				}
				else if (touch.phase == TouchPhase.ENDED)
				{
					if (dragingImage)
						checkPointInRect(new Point(touch.globalX, touch.globalY));
				}
			}
		}

		private function checkPointInRect(point:Point, useInBegin:Boolean=false):void
		{
			var p:Point;
			if (!useInBegin && !dragingImage)
				return;
			var hasHited:Boolean;
			for (var i:Image in initPositionDic)
			{
				p=initPositionDic[i];
				if (i != dragingImage)
				{
					var r:Rectangle=new Rectangle(p.x + xoffset, p.y + yoffset, itemWidth, itemHeight);
					if (r.contains(point.x, point.y))
					{
						hasHited=true;
						if (useInBegin)
						{
							dragingImage=i;
						}
						else if (dragingImage)
						{
							begin=false;
							otherImage=i;
							var dp:Point=initPositionDic[dragingImage];
							TweenLite.to(dragingImage, 0.5, {x: p.x + xoffset, y: p.y + yoffset, ease: Cubic.easeOut});
							TweenLite.to(i, 0.5, {x: dp.x + xoffset, y: dp.y + yoffset, ease: Cubic.easeOut, onComplete: function():void
							{
								initPositionDic[dragingImage]=p;
								if (p.x == rightPositionDic[dragingImage].x)
									TweenLite.to(signDic[dragingImage], 0.5, {alpha: 1});
								else
									TweenLite.to(signDic[dragingImage], 0.5, {alpha: 0});
								initPositionDic[i]=dp;
								if (dp.x == rightPositionDic[i].x)
									TweenLite.to(signDic[i], 0.5, {alpha: 1, onComplete: function():void
									{
										var allMatched:Boolean=true;
										for each (i in signDic)
										{
											if (i.alpha == 0)
											{
												allMatched=false;
												break;
											}
										}
										if (allMatched)
										{
											trace('all matched');
											TweenLite.to(shadow, 0.8, {alpha: 1, onComplete: function():void
											{
												dispatchEvent(new Event('allMatched'));
											}});
										}
									}});
								else
									TweenLite.to(signDic[i], 0.5, {alpha: 0});
								begin=true;
								dragingImage=null;
							}});
						}
						break;
					}
				}
			}
			if (dragingImage && !useInBegin && !hasHited)
			{
				p=initPositionDic[dragingImage];
				begin=false;
				TweenLite.to(dragingImage, 0.5, {x: p.x + xoffset, y: p.y + yoffset, ease: Cubic.easeOut, onComplete: function():void
				{
					begin=true;
				}});
				dragingImage=null;
			}
		}
	}
}


