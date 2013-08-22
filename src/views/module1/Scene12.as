package views.module1
{
	import com.greensock.TweenLite;
	import views.components.base.PalaceScene;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import views.module1.scene2.ClothPuzzle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import views.module1.scene2.Hint;
	import views.module1.scene2.BoxCellRenderer;
	import views.module1.scene2.Cloth;

	public class Scene12 extends PalaceScene
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
				boxHolder.setChildIndex(list, value ? 1 : 0);
				TweenLite.to(list, 1, {y: (value ? -536 : 4)});
				TweenLite.to(list.clipRect, 1, {height: (value ? 567 : 0)});
				TweenLite.to(boxCover, 1, {y: (value ? -544 : -4)});
			}
		}


		private var list:List;
		private var quizSolved:Boolean;
		private var index:int=0;

		public function Scene12()
		{
		}

		override public function init():void
		{
			bg=new Sprite();
			addChild(bg);

			bg.addChild(getImage("background12"));

			addKing();
			addBox();
			addShelf();
			addLion();
			addHints();

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			if (!dragging)
				return;

			var tc:Touch=event.getTouch(stage);
			if (!tc)
				return;

			var pt:Point=new Point(tc.globalX / scale, tc.globalY / scale);

			switch (tc.phase)
			{
				case TouchPhase.MOVED:
				{
					if (dragging && draggingCloth)
					{
						draggingCloth.x=pt.x;
						draggingCloth.y=pt.y
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					dragging=false;
					dpt=null;

					if (draggingCloth)
					{
						var targetPT:Point;
						if (kingRect.containsPoint(pt))
						{
							targetPT=checkType(draggingCloth.type) ? clothPosition : hatPosition;
						}
						else
						{
							var back:Boolean=true;
							targetPT=shelfPosition;
						}
						var _scale:Number=back ? .5 : 1;
						var _alpha:Number=back ? 0 : 1;
						tweening=true;
						TweenLite.to(draggingCloth, .5, {x: targetPT.x, y: targetPT.y, scaleX: _scale, scaleY: _scale, alpha: _alpha, onComplete: function():void
						{
							tweening=false;

							switch (targetPT)
							{
								case shelfPosition:
								{
									draggingCloth.renderer.setIconVisible(true);
									break;
								}

								case clothPosition:
								{
									if (kingCloth.renderer)
										kingCloth.renderer.setIconVisible(true);
									kingCloth.renderer=draggingCloth.renderer;
									clothHint.label=getImage("hint-" + kingCloth.type);
									clothHint.show();
									clothIndex=clothArr.indexOf(kingCloth.type);
									clothLocked=(clothIndex == missionIndex);
									if (hatLocked && clothLocked)
										completeMission();
									break;
								}

								case hatPosition:
								{
									if (kingHat.renderer)
										kingHat.renderer.setIconVisible(true);
									kingHat.renderer=draggingCloth.renderer;
									hatHint.label=getImage("hint-" + kingHat.type);
									hatHint.show();
									hatIndex=hatArr.indexOf(kingHat.type);
									hatLocked=(hatIndex == missionIndex);
									if (hatLocked && clothLocked)
										completeMission();
									break;
								}

								default:
								{
									break;
								}
							}

							draggingCloth.visible=false;
						}});
					}
					break;
				}
			}

		}

		private function completeMission():void
		{
			var str:String=clothArr[missionIndex];
			lionHint.img=getImage("hint-bg-2");
			lionHint.label=getImage("hint-ok-" + str);
			missionIndex++;
			hatLocked=false;
			clothLocked=false;
			lionHint.callback=nextMission;
			lionHint.show();
		}

		private function nextMission():void
		{
			if (missionIndex < clothArr.length)
			{
				var str:String=clothArr[missionIndex];
				lionHint.img=getImage("hint-bg-0");
				lionHint.label=getImage("hint-find-" + str);
				lionHint.show();
			}
			else
			{
				opened=false;
				lionHint.img=getImage("hint-bg-0");
				lionHint.label=getImage("hint-end");
				lionHint.show();

				setTimeout(nextScene, 3000);
			}
		}

		private function nextScene():void
		{
			dispatchEvent(new Event("gotoNext", true));
		}

		private var hatPosition:Point=new Point(444.5, 168);
		private var clothPosition:Point=new Point(444.5, 517);
		private var shelfPosition:Point=new Point(800, 400);

		private function checkType(type:String):Boolean
		{
			return clothArr.indexOf(type) >= 0
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

		private function addHints():void
		{
			lionHint=new Hint();
			addChild(lionHint);
			lionHint.registration=1;
			lionHint.x=90;
			lionHint.y=560;
			lionHint.visible=false;

			hatHint=new Hint();
			addChild(hatHint);
			hatHint.registration=1;
			hatHint.x=530;
			hatHint.y=200;
			hatHint.img=getImage("hint-bg-0");
			hatHint.visible=false;

			clothHint=new Hint();
			addChild(clothHint);
			clothHint.registration=1;
			clothHint.x=530;
			clothHint.y=610;
			clothHint.img=getImage("hint-bg-1");
			clothHint.visible=false;

			lionHint.img=getImage("hint-bg-2");
			lionHint.label=getImage("hint-start");
			lionHint.show();
		}

		private var hatIndex:int=-1;
		private var clothIndex:int=-1;

		private var hatLocked:Boolean=false;
		private var clothLocked:Boolean=false;

		private var lionX:int=-140;
		private var lionDX:int=20;

		private function addLion():void
		{
			lion=new Sprite();
			lion.addChild(getImage("lion"));
			addChild(lion);
			lion.x=lionDX;
			lion.y=540;
			lion.addEventListener(TouchEvent.TOUCH, onLionTouch);
		}

		private function onLionTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
				lionHint.show();
		}

		private static var clothArr:Array=["常服", "朝服", "行服", "雨服", "龙袍"];
		private static var hatArr:Array=["常帽", "朝帽", "行帽", "雨帽", "龙帽"];
		private var dpt:Point;
		private var kingRect:Rectangle;
		private var draggingCloth:Cloth;
		private var dragging:Boolean;
		private var tweening:Boolean;

		private var kingCloth:Cloth;

		private var kingHat:Cloth;

		private var lionHint:Hint;
		private var hatHint:Hint;
		private var clothHint:Hint;
		private var missionIndex:int=0;

		private var lion:Sprite;

		private function addShelf():void
		{
			list=new List();

			var layout:VerticalLayout=new VerticalLayout();
			layout.useVirtualLayout=false;
			list.layout=layout;

			var items:Array=[];

			for each (var i:String in clothArr)
			{
				var cloth:Object={type: i, src: getImage(i)};
				items.push(cloth);
			}

			for each (var j:String in hatArr)
			{
				var hat:Object={type: j, src: getImage(j)};
				items.push(hat);
			}

			items.fixed=true;

			list.dataProvider=new ListCollection(items);

			list.itemRendererFactory=function():IListItemRenderer
			{
				var renderer:BoxCellRenderer=new BoxCellRenderer();
				renderer.width=284;
				renderer.height=223;
				renderer.addChild(getImage("boxcell"));
				renderer.labelField="type";
				renderer.iconField="src";

				renderer.isQuickHitAreaEnabled=true;
				return renderer;
			}
			boxHolder.addChildAt(list, 0);
			list.x=6;
			list.y=4;
			list.setSize(284, 567);
			list.clipRect=new Rectangle(0, 0, 284, 0)
			list.hasElasticEdges=false;

			draggingCloth=new Cloth();
			addChild(draggingCloth);
			draggingCloth.visible=false;

			list.addEventListener(TouchEvent.TOUCH, onListTouch);
		}

		private function onListTouch(e:TouchEvent):void
		{
			trace('list touching');
			if (tweening)
				return;
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;

			var pt:Point=new Point(tc.globalX / scale, tc.globalY / scale);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var renderer:BoxCellRenderer=e.target as BoxCellRenderer;
					if (renderer && (kingCloth.renderer != renderer && kingCloth.renderer != renderer))
					{
						draggingCloth.renderer=renderer
						dpt=pt;
					}
					else
						dpt=null;
					draggingCloth.visible=false;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (dragging)
						return;
					if (dpt)
					{
						var dx:Number=dpt.x - pt.x;
						var dy:Number=dpt.y - pt.y;
						if (dx > 20 * scale && Math.abs(dy) < 20 * scale && draggingCloth.renderer)
						{
							dragging=true;
							list.stopScrolling();
							draggingCloth.visible=true;
							draggingCloth.x=pt.x;
							draggingCloth.y=pt.y;
							draggingCloth.scaleX=draggingCloth.scaleY=1;
							draggingCloth.alpha=1;
							draggingCloth.renderer.setIconVisible(false);
						}
					}
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function onClickBox(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.BEGAN);
			if (tc)
			{
				box.removeEventListener(TouchEvent.TOUCH, onClickBox);
				lionHint.label=getImage("hint-quizstart");
				lionHint.show();
				var quiz:ClothPuzzle=new ClothPuzzle(assets);
				quiz.y=(768 - quiz.height) / 2;
				addChild(quiz);
				setChildIndex(lion, numChildren - 1);
				setChildIndex(lionHint, numChildren - 1);
				quiz.addEventListener("allMatched", onQuizDone);

			}
//			box.removeEventListener(TouchEvent.TOUCH,onClickBox);
		}

		private function onQuizDone(e:Event):void
		{
			var quiz:ClothPuzzle=e.currentTarget as ClothPuzzle;
			TweenLite.to(quiz, .5, {scaleX: .2, scaleY: .2, x: boxHolder.x + 140, y: boxHolder.y, onComplete: function():void
			{
				quiz.parent.removeChild(quiz);
				lionHint.label=getImage("hint-gamestart");
				lionHint.callback=nextMission;
				lionHint.show();
				opened=true;
			}});
		}

		private function showQuiz():void
		{

		}

		private function addKing():void
		{
			kingHolder=new Sprite();
			kingHolder.addChild(getImage("king12"));
			addChild(kingHolder);
			kingHolder.x=268;
			kingHolder.y=38;
			kingRect=new Rectangle(268, 38, 353, 646);

			kingCloth=new Cloth();
			kingHolder.addChild(kingCloth);
			kingCloth.x=176.5;
			kingCloth.y=479.5;
			kingCloth.addEventListener(TouchEvent.TOUCH, onClothTouch);

			kingHat=new Cloth();
			kingHolder.addChild(kingHat);
			kingHat.x=176.5;
			kingHat.y=130;
			kingHat.addEventListener(TouchEvent.TOUCH, onClothTouch);
		}

		private function onClothTouch(event:TouchEvent):void
		{
			if (tweening || dragging || !opened)
				return;
			var tc:Touch=event.getTouch(stage)
			if (!tc)
				return;

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var cloth:Cloth=event.currentTarget as Cloth;
					dragging=true;
					draggingCloth.renderer=cloth.renderer;
					draggingCloth.x=tc.globalX / scale;
					draggingCloth.y=tc.globalY / scale;
					draggingCloth.visible=true;
					draggingCloth.scaleX=draggingCloth.scaleY=1;
					draggingCloth.alpha=1;

					if (clothArr.indexOf(cloth.type) >= 0)
						clothHint.visible=false;
					else
						hatHint.visible=false;
					cloth.distroy();
					break;
				}

				default:
				{
					break;
				}
			}
		}
	}
}

