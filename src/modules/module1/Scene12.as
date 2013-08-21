package modules.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.base.PalaceScene;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Scene12 extends PalaceScene
	{
		private var bg:Sprite;

		private var kingHolder:Sprite;
		private var boxHolder:Sprite;

		private var box:Image;

		private var boxCover:Sprite;
		private var _opened:Boolean;

		public function get opened():Boolean
		{
			return _opened;
		}

		public function set opened(value:Boolean):void
		{
			if(_opened != value){
				_opened=value
				boxHolder.setChildIndex(list,value?1:0);
				TweenLite.to(list,1,{y:(value?-536:4)});
				TweenLite.to(list.clipRect,1,{height:(value?567:0)});
				TweenLite.to(boxCover,1,{y:(value?-544:-4)});
			}
		}


		private var list:List;
		private var quizSolved:Boolean;
		private var index:int=0;
		public function Scene12()
		{
		}

		override public function init():void{
			bg=new Sprite();
			addChild(bg);

			bg.addChild(getImage("background12"));

			addKing();
			addBox();
			addShelf();
			addLion();
			addHints();

			addEventListener(TouchEvent.TOUCH,onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			if(!dragging)
				return;

			var tc:Touch=event.getTouch(stage); 
			if(!tc)
				return;

			var pt:Point=new Point(tc.globalX,tc.globalY);

			switch(tc.phase)
			{
				case TouchPhase.MOVED:
				{
					if(dragging&&draggingCloth){
						draggingCloth.x=pt.x;
						draggingCloth.y=pt.y
					}
					break;
				}

				case TouchPhase.ENDED:
				{
					dragging=false;
					dpt=null;

					if(draggingCloth){
						var targetPT:Point;
						if(kingRect.containsPoint(pt)){
							targetPT=checkType(draggingCloth.type)?clothPosition:hatPosition;
						}else{
							var back:Boolean=true;
							targetPT=shelfPosition;
						}
						var _scale:Number=back?.5:1;
						var _alpha:Number=back?0:1;
						tweening=true;
						TweenLite.to(draggingCloth,.5,{x:targetPT.x,y:targetPT.y,scaleX:_scale,scaleY:_scale,alpha:_alpha,
								onComplete:function():void{
									tweening=false;

									switch(targetPT)
									{
										case shelfPosition:
										{
											draggingCloth.renderer.setIconVisible(true);
											break;
										}

										case clothPosition:
										{
											if(kingCloth.renderer)
												kingCloth.renderer.setIconVisible(true);
											kingCloth.renderer=draggingCloth.renderer;
											clothHint.label=getImage("hint-"+kingCloth.type);
											clothHint.show();
											clothIndex=clothArr.indexOf(kingCloth.type);
											clothLocked=(clothIndex==missionIndex);
											if(hatLocked&&clothLocked)
												completeMission();
											break;
										}

										case hatPosition:
										{
											if(kingHat.renderer)
												kingHat.renderer.setIconVisible(true);
											kingHat.renderer=draggingCloth.renderer;
											hatHint.label=getImage("hint-"+kingHat.type);
											hatHint.show();
											hatIndex=hatArr.indexOf(kingHat.type);
											hatLocked=(hatIndex==missionIndex);
											if(hatLocked&&clothLocked)
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
			lionHint.img=getImage("hint-bg-0");
			lionHint.label=getImage("hint-ok-"+str);
			lionHint.callback=nextMission;
			lionHint.show();
		}

		private function nextMission():void
		{
			missionIndex++;
			if(missionIndex<clothArr.length){
				var str:String=clothArr[missionIndex];
				lionHint.img=getImage("hint-bg-2");
				lionHint.label=getImage("hint-find-"+str);
				lionHint.show();
				hatLocked=false;
				clothLocked=false;
			}else{
				lionHint.img=getImage("hint-bg-0");
				lionHint.label=getImage("hint-end");
				lionHint.show();
			}
		}

		private var hatPosition:Point=new Point(444.5,168);
		private var clothPosition:Point=new Point(444.5,517);
		private var shelfPosition:Point=new Point(800,400);

		private function checkType(type:String):Boolean
		{
			return clothArr.indexOf(type)>=0
		}

		private function addBox():void
		{
			boxHolder=new Sprite();
			addChild(boxHolder);
			boxHolder.x=686;
			boxHolder.y=572;

			box=getImage("box.png");
			box.addEventListener(TouchEvent.TOUCH,onClickBox);
			boxCover=new Sprite();
			boxCover.addChild(getImage("boxcover.png"));
			boxCover.pivotX=boxCover.width>>1;
			boxCover.x=box.width/2;
			boxCover.y=-4;

			boxHolder.addChild(box);
			boxHolder.addChild(boxCover);

		}

		private function addHints():void
		{
			lionHint=new Hint();
			addChild(lionHint);
			lionHint.registration=1;
			lionHint.x=79;
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
			var lion:Sprite=new Sprite();
			lion.addChild(getImage("lion"));
			addChild(lion);
			lion.x=lionDX;
			lion.y=540;
		}

		private static var clothArr:Array=["常服","朝服","行服","雨服","龙袍"];
		private static var hatArr:Array=["常帽","朝帽","行帽","雨帽","龙帽"];
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
		private var missionIndex:int=-1;

		private function addShelf():void
		{
			list=new List();

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout=false;
			list.layout=layout;

			var items:Array=[];

			for each (var i:String in clothArr) 
			{
				var cloth:Object={ type: i,src:getImage(i)};
				items.push(cloth);
			}

			for each (var j:String in hatArr) 
			{
				var hat:Object={ type: j,src:getImage(j)};
				items.push(hat);
			}

			items.fixed = true;

			list.dataProvider = new ListCollection(items);

			list.itemRendererFactory=function():IListItemRenderer
			{
				var renderer:BoxCellRenderer = new BoxCellRenderer();
				renderer.width=284;
				renderer.height=223;
				renderer.addChild(getImage("boxcell"));
				renderer.labelField="type";
				renderer.iconField="src";

				renderer.isQuickHitAreaEnabled = true;
				return renderer;
			}
			boxHolder.addChildAt(list,0);
			list.x=6;
			list.y=4;
			list.setSize(284,567);
			list.clipRect=new Rectangle(0,0,284,0)
			list.hasElasticEdges=false;

			draggingCloth=new Cloth();
			addChild(draggingCloth);
			draggingCloth.visible=false;

			list.addEventListener(TouchEvent.TOUCH,onListTouch);
		}

		private function onListTouch(e:TouchEvent):void
		{
			if(tweening)
				return;
			var tc:Touch=e.getTouch(stage); 
			if(!tc)
				return;

			var pt:Point=new Point(tc.globalX,tc.globalY);
			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var renderer:BoxCellRenderer=e.target as BoxCellRenderer;
					if(renderer&&(kingCloth.renderer!=renderer&&kingCloth.renderer!=renderer)){
						draggingCloth.renderer=renderer
						dpt=pt;
					}else
						dpt=null;
					draggingCloth.visible=false;
					break;
				}

				case TouchPhase.MOVED:
				{
					if(dragging)
						return;
					if(dpt){
						var dx:Number=dpt.x-pt.x;
						var dy:Number=dpt.y-pt.y;
						if(dx>20&&Math.abs(dy)<20&&draggingCloth.renderer){
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
			var tc:Touch=e.getTouch(stage,TouchPhase.ENDED);
			if(tc){
//				if(quizSolved)
				opened=!opened;
//				else
//					showQuiz();
			}
//			box.removeEventListener(TouchEvent.TOUCH,onClickBox);
		}

		private function showQuiz():void
		{

		}

		private function addKing():void
		{
			kingHolder=new Sprite();
			kingHolder.addChild(getImage("king12.png"));
			addChild(kingHolder);
			kingHolder.x=268;
			kingHolder.y=38;
			kingRect=new Rectangle(268,38,353,646);

			kingCloth=new Cloth();
			kingHolder.addChild(kingCloth);
			kingCloth.x=176.5;
			kingCloth.y=479.5;
			kingCloth.addEventListener(TouchEvent.TOUCH,onClothTouch);

			kingHat=new Cloth();
			kingHolder.addChild(kingHat);
			kingHat.x=176.5;
			kingHat.y=130;
			kingHat.addEventListener(TouchEvent.TOUCH,onClothTouch);
		}

		private function onClothTouch(event:TouchEvent):void
		{
			if(tweening||dragging)
				return;
			var tc:Touch=event.getTouch(stage)
			if(!tc)
				return;

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var cloth:Cloth=event.currentTarget as Cloth;
					dragging=true;
					draggingCloth.renderer=cloth.renderer;
					draggingCloth.x=tc.globalX;
					draggingCloth.y=tc.globalY;
					draggingCloth.visible=true;
					draggingCloth.scaleX=draggingCloth.scaleY=1;
					draggingCloth.alpha=1;

					if(clothArr.indexOf(cloth.type)>=0)
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

