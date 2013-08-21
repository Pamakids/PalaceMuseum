package modules.module1
{
	import com.greensock.TweenLite;
	import com.pamakids.palace.base.PalaceScene;

	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
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

			addShelf();
		}


		private static var clothArr:Array=["常服.png","朝服.png","行袍.png","雨服.png","龙袍.png"];
		private static var hatArr:Array=["常帽.png","朝帽.png","行帽.png","雨帽.png","龙帽.png"];

		private function addShelf():void
		{
			list=new List();

			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout=false;
			list.layout=layout;

			var items:Array=[];

			for each (var i:String in clothArr) 
			{
				var cloth:Object={ type: "cloth",src:getImage(i)};
				items.push(cloth);
			}

			for each (var j:String in hatArr) 
			{
				var hat:Object={ type: "hat",src:getImage(j)};
				items.push(hat);
			}

			items.fixed = true;

			list.dataProvider = new ListCollection(items);

			list.itemRendererFactory=function():IListItemRenderer
			{
				var renderer:BoxCellRenderer = new BoxCellRenderer();
				renderer.width=284;
				renderer.height=223;
				renderer.addChild(getImage("boxcell.png"));
				renderer.labelField="type";
				renderer.iconField="src";
//				var type:String=renderer.data;
//				var src:String=renderer.data["src"];

				setTimeout(function():void{
					index++
					trace(renderer.data,index)
				},1);

				renderer.isQuickHitAreaEnabled = true;
				return renderer;
			}
			boxHolder.addChildAt(list,0);
			list.x=6;
			list.y=4;
			list.setSize(284,567);
			list.clipRect=new Rectangle(0,0,284,0)
			list.hasElasticEdges=false;
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
		}
	}
}

