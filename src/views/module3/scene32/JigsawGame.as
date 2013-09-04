package views.module3.scene32
{
	import flash.display.Bitmap;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class JigsawGame extends PalaceGame
	{
		[Embed(source="/assets/module3/scene32/map.jpg")]
		private var img:Class;

		public function JigsawGame(am:AssetManager=null)
		{
			super(am);
		}

		public var dataArr:Array=[];
		public var bpArr:Array=[];
		public var cellArr:Vector.<Vector.<Cell>>=new Vector.<Vector.<Cell>>();

		private var playground:Sprite;

		public function initData():void
		{
			var map:Bitmap=new img();

		}

		public function startGame():void
		{
			initGameBG();
			initPlayGround();

		}

		private function initPlayGround():void
		{
			playground=new Sprite();
			addChild(playground);

			for (var i:int=0; i < dataArr.length; i++)
			{
				var arr:Array=dataArr[i];
				for (var j:int=0; j < arr.length; j++)
				{
					cellArr[i][j]=new Cell();
				}
			}
		}

		private function initGameBG():void
		{
			var greyBG:Image=getImage("map");
			var fl:ColorMatrixFilter=new ColorMatrixFilter();
			fl.matrix=Vector.<Number>([
				1, 0, 0, 0, 0,
				1, 0, 0, 0, 0,
				1, 0, 0, 0, 0,
				0, 0, 0, 1, 0
				]);
			greyBG.filter=fl;
			addChild(greyBG);

			var colorBG:Image=getImage("map");
			addChild(colorBG)
			colorBG.alpha=0;
		}
	}
}
