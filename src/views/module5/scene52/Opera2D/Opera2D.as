package views.module5.scene52.Opera2D
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	import nape.geom.AABB;
	import nape.geom.GeomPolyList;
	import nape.geom.MarchingSquares;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;

	/**
	 * @author yangfei
	 */
	[SWF(width="1024", height="768", frameRate="60")]
	public class Opera2D extends AbstractNapeTest
	{
		private var cellsize:Vec2;
		private var myISO:GraphicIso;

		private var file:FileReference;
		private var fileFilter:FileFilter;
		private var loader:Loader;

		override protected function onNapeWorldReady():void
		{
			ropeShape=new Shape();
			addChild(ropeShape);
			g=ropeShape.graphics;

			file=new FileReference();
			fileFilter=new FileFilter(".png", "*.png");
			loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBytesLoaded);

			myISO=new GraphicIso();
			cellsize=new Vec2(50, 50);

			setUpEvent();

			addOnePlayer(1);

		}

		private function addOnePlayer(index:int):void
		{
			var neck:Body=createNeck(index);
			creatHead(neck, index);
			creatBody(neck, index);
		}

		private function setUpEvent():void
		{
			stage.doubleClickEnabled=true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onClick);

			file.addEventListener(Event.SELECT, onFileSelect);
		}

		private function onFileSelect(event:Event):void
		{
			file.load();
			file.addEventListener(Event.COMPLETE, onFileloaded);
		}

		private function onFileloaded(event:Event):void
		{
			loader.loadBytes(file.data);
		}

		private function onBytesLoaded(event:Event):void
		{
			var bmp:Bitmap=loader.content as Bitmap;
			createMarchingSquareBody(bmp);
		}

		private function onClick(event:MouseEvent):void
		{
			file.browse([fileFilter]);
		}

		private const X1:Number=100;
		private const X2:Number=200;
		private const X3:Number=300;
		private const X4:Number=400;

		private const Y1:Number=100;
		private const Y2:Number=200;
		private const Y3:Number=300;

		public function createMarchingSquareBody(bp:Bitmap):void
		{
			myISO.graphic=bp;
			var b:Body=new Body(BodyType.DYNAMIC);

			var geomList:GeomPolyList;
			geomList=MarchingSquares.run(myISO, new AABB(0, 0, bp.width, bp.height), cellsize, 2, null, false);
			geomList.foreach(function(s:*):void {
				b.shapes.push(new Polygon(s, Material.rubber()));
			});
//			b.shapes.push(new Polygon(Polygon.rect(0, 0, 100, 200), Material.rubber()));
			addChild(bp);
			b.space=napeWorld;
			b.userData.graphic=bp;

			var body1:Body=napeWorld.world;
			var body2:Body=b;
			var anchor1:Vec2=new Vec2(512, 200);
			var anchor2:Vec2=new Vec2(bp.width >> 1, 100);
			var joint:RopeJoint=new RopeJoint(body1, body2, 20, 150, anchor1, anchor2);
			joint.space=napeWorld;

			jointArr.push(joint);
		}

		private function creatBody(neck:Body, index:int):void
		{
			var body:Body=new Body(BodyType.DYNAMIC);
		}

		private function creatHead(neck:Body, index:int):void
		{
			var head:Body=new Body(BodyType.DYNAMIC);
		}

		private function createNeck(index:int):Body
		{
			var neck:Body=new Body(BodyType.DYNAMIC);
			neck.space=napeWorld;
			neck.shapes.push(new Polygon(Polygon.rect(0, 0, 50, 50), Material.rubber()));
			var body1:Body=napeWorld.world;
			var body2:Body=neck;
			var anchor1:Vec2=new Vec2(512, 200);
			var anchor2:Vec2=new Vec2(25, 25);
			var joint:RopeJoint=new RopeJoint(body1, body2, 20, 150, anchor1, anchor2);
			joint.space=napeWorld;

			jointArr.push(joint);

			return neck;
		}

		private var jointArr:Array=[];

		private var ropeShape:Shape;
		private var g:Graphics;

		override protected function loop(event:Event):void
		{
			super.loop(event);
			if (g)
			{
				g.clear();
				g.lineStyle(5);
				for each (var joint:RopeJoint in jointArr)
				{
					if (joint)
						joint.drawLine(g);
				}
			}

		}
	}
}
import flash.display.Bitmap;

import nape.geom.IsoFunction;

class GraphicIso implements IsoFunction
{
	public var graphic:Bitmap;

	public function GraphicIso():void
	{

	}

	public function iso(x:Number, y:Number):Number
	{
		var isOK:Number;
		if (graphic.bitmapData.getPixel32(x, y) > 0)
		{
			isOK=-1;
		}
		else
		{
			isOK=1;
		}
		return isOK;
	}
}
