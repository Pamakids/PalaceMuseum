package views.module1
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.pamakids.utils.DPIUtil;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module1.scene2.BoxCellRenderer;
	import views.module1.scene2.Cloth;
	import views.module1.scene2.ClothPuzzle;

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
				if (value)
					list.clipRect.height=37;
				boxHolder.setChildIndex(list, 1);
				TweenLite.to(list, 1, {y: (value ? -536 : 4)});
				TweenLite.to(list.clipRect, 1, {height: (value ? 567 : 30), onComplete: (value ? function():void
				{

				} : function():void
				{
					list.visible=false;
					boxHolder.setChildIndex(list, 0);
				})});
				TweenLite.to(boxCover, 1, {y: (value ? -544 : -4)});
			}
		}


		private var list:List;
		private var quizSolved:Boolean;
		private var index:int=0;

		public function Scene12(am:AssetManager)
		{
			super(am);
			crtKnowledgeIndex=2;

			json=assets.getObject("hint12").hint;
		}

		override protected function init():void
		{
			bg=new Sprite();
			addChild(bg);

			bg.addChild(getImage("background12"));

			addKing();
			addBox();
			addShelf();
			addLion();
//			addHints();

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

//									clothHint.label=getImage("hint-" + kingCloth.type);
//									clothHint.show();
									clothIndex=clothArr.indexOf(kingCloth.type);
									clothLocked=(clothIndex == missionIndex);
									if (!clothLocked)
										showClothHint("hint-" + kingCloth.type);
									else if (hatLocked)
										TweenLite.delayedCall(2, completeMission);
									break;
								}

								case hatPosition:
								{
									if (kingHat.renderer)
										kingHat.renderer.setIconVisible(true);
									kingHat.renderer=draggingCloth.renderer;

//									hatHint.label=getImage("hint-" + kingHat.type);
//									hatHint.show();
									hatIndex=hatArr.indexOf(kingHat.type);
									hatLocked=(hatIndex == missionIndex);
									if (!hatLocked)
										showHatHint("hint-" + kingHat.type);
									else if (clothLocked)
										TweenLite.delayedCall(2, completeMission);
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

		private function showClothHint(content:String):void
		{
			showHint("hint-bg-1", content, 2);
		}

		private function showHatHint(content:String):void
		{
			showHint("hint-bg-0", content, 1);
		}

		private function showLionHint(bg:String, content:String, callback:Function=null):void
		{
			crtLionHintBG=bg;
			crtLionContent=content;

			showHint(bg, content, 0, callback);
//			lionHint.img=getImage("hint-bg-2");
//			lionHint.delay=5
//			lionHint.label=getImage("hint-start");
//			lionHint.show();
		}

		//完成单个任务
		private function completeMission():void
		{
			var str:String=clothArr[missionIndex];
//			lionHint.img=getImage();
//			lionHint.delay=5;
//			lionHint.label=getImage();
//			missionIndex++;

			var callback:Function=missionIndex == clothArr.length - 1 ? endMission : nextMission;
			showLionHint("hint-bg-2", "hint-ok-" + str, callback);
//			lionHint.show();
		}

		//完成所有任务
		private function endMission():void
		{
			showAchievement(2);
			opened=false;
			TweenLite.delayedCall(2, function():void
			{
				showLionHint("hint-bg-2", "hint-end", nextScene);
			});

//			lionHint.img=getImage("hint-bg-0");
//			lionHint.delay=3;
//			lionHint.label=getImage("hint-end");
//			lionHint.show();
		}

		private function nextMission():void
		{
			//解锁
			hatLocked=false;
			clothLocked=false;

			if (missionIndex < 0)
				missionIndex=Math.random() * (clothArr.length - 1);
			else
				missionIndex=clothArr.length - 1;

			if (missionIndex < clothArr.length)
			{
				var str:String=clothArr[missionIndex];

				showLionHint("hint-bg-0", "hint-find-" + str);
//				lionHint.img=getImage("hint-bg-0");
//				lionHint.delay=3;
//				lionHint.label=getImage("hint-find-" + str);
//				lionHint.show();
			}
		}

		private function nextScene():void
		{
			showCard("dragonRobe");
			TweenLite.to(hatLockMark, .5, {alpha: 0});
			TweenLite.to(clothLockMark, .5, {alpha: 0});
			TweenLite.to(lion, 1, {x: lionX, onComplete: sceneOver});
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
//			lionHint=new Hint();
//			addChild(lionHint);
//			lionHint.registration=1;
//			lionHint.x=90;
//			lionHint.y=560;
//			lionHint.visible=false;

//			hatHint=new Hint();
//			addChild(hatHint);
//			hatHint.registration=1;
//			hatHint.x=530;
//			hatHint.y=200;
//			hatHint.img=getImage("hint-bg-0");
//			hatHint.delay=3;
//			hatHint.visible=false;

//			clothHint=new Hint();
//			addChild(clothHint);
//			clothHint.registration=1;
//			clothHint.x=530;
//			clothHint.y=610;
//			clothHint.img=getImage("hint-bg-1");
//			clothHint.delay=4;
//			clothHint.visible=false;
		}

		private function showHint(bg:String, content:String, posIndex:int, callback:Function=null):void
		{
			var pos:Point=posArr[posIndex];
			var txt:String=json[content];
			Prompt.showTXT(pos.x, pos.y, txt, 20, callback, this);
//			var index:int=bg.lastIndexOf("-") + 1;
//			var i:int=int(bg.charAt(index));
//			var delay:int=i + 3;
//			Prompt.show(pos.x, pos.y, bg, content, 1, delay, callback, this);
		}

		private var posArr:Array=[new Point(90, 560), new Point(530, 200), new Point(530, 610)];

		private var hatIndex:int=-1;
		private var clothIndex:int=-1;

		private var _hatLocked:Boolean=false;

		public function get hatLocked():Boolean
		{
			return _hatLocked;
		}

		public function set hatLocked(value:Boolean):void
		{
			_hatLocked=value;
			if (hatLockMark)
				hatLockMark.visible=value;
		}

		private var _clothLocked:Boolean=false;

		public function get clothLocked():Boolean
		{
			return _clothLocked;
		}

		public function set clothLocked(value:Boolean):void
		{
			_clothLocked=value;
			if (clothLockMark)
				clothLockMark.visible=value;
		}


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
				showLionHint("hint-bg-2", "hint-start");
				lion.addEventListener(TouchEvent.TOUCH, onLionTouch);
			}});
		}

		private function onLionTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
				showLionHint(crtLionHintBG, crtLionContent);
		}

		private static var clothArr:Array=["朝服", "行服", "雨服", "龙袍", "常服"];
		private static var hatArr:Array=["朝帽", "行帽", "雨帽", "龙帽", "常帽"];
		private var dpt:Point;
		private var kingRect:Rectangle;
		private var draggingCloth:Cloth;
		private var dragging:Boolean;
		private var tweening:Boolean;

		private var kingCloth:Cloth;

		private var kingHat:Cloth;

		private var missionIndex:int=-1;

		private var lion:Sprite;
		private var crtLionHintBG:String;
		private var crtLionContent:String;

		private var hatLockMark:Image;

		private var clothLockMark:Image;
		private var scrolling:Boolean;

		private var json:Object;

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

					if (renderer)
					{
						var isKingCloth:Boolean
						if (!kingCloth.renderer)
							isKingCloth=false;
						else
							isKingCloth=kingCloth.renderer.label == renderer.label;

						var isKingHat:Boolean;
						if (!kingHat.renderer)
							isKingHat=false;
						else
							isKingHat=kingHat.renderer.label == renderer.label;

						if (!isKingCloth && !isKingHat)
						{
							if ((hatLocked && hatArr.indexOf(renderer.label) >= 0) || (clothLocked && clothArr.indexOf(renderer.label) >= 0))
								return;
							draggingCloth.renderer=renderer
							dpt=pt;
						}
					}
					else
						dpt=null;
					draggingCloth.visible=false;
					scrolling=false;
					break;
				}

				case TouchPhase.MOVED:
				{
					if (dragging || scrolling)
						return;
					if (dpt)
					{
						var dx:Number=dpt.x - pt.x;
						var dy:Number=dpt.y - pt.y;
						if (Math.abs(dx) >= 10 * scale && Math.abs(dy) < 30 * scale && draggingCloth.renderer)
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
						else if (Math.abs(dy) >= 30 * scale)
						{
							scrolling=true;
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
						showLionHint("hint-bg-2", "hint-quizstart");
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

//				lionHint.label=getImage("hint-gamestart");
//				lionHint.callback=nextMission;
//				lionHint.show();
				opened=true;
				crtKnowledgeIndex=3;
				TweenLite.delayedCall(2, function():void
				{
					showLionHint("hint-bg-2", "hint-gamestart", nextMission);
				});
			}});
		}

		private function addKing():void
		{
			clothLocked=hatLocked=true;

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

			hatLockMark=getImage("cloth-lock");
			hatLockMark.visible=false;
			hatLockMark.x=265;
			hatLockMark.y=110;
			kingHolder.addChild(hatLockMark);

			clothLockMark=getImage("cloth-lock");
			clothLockMark.visible=false;
			clothLockMark.x=260;
			clothLockMark.y=515;
			kingHolder.addChild(clothLockMark);
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

					if (clothArr.indexOf(cloth.type) >= 0)
					{
						if (clothLocked)
							return;
							//						if (clothHint)
							//							clothHint.hide();
					}
					else
					{
						if (hatLocked)
							return;
							//						if (hatHint)
							//							hatHint.hide();
					}

					dragging=true;
					draggingCloth.renderer=cloth.renderer;
					draggingCloth.x=tc.globalX / scale;
					draggingCloth.y=tc.globalY / scale;
					draggingCloth.visible=true;
					draggingCloth.scaleX=draggingCloth.scaleY=1;
					draggingCloth.alpha=1;

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

