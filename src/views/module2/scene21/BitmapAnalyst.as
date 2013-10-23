package views.module2.scene21
{
	import com.pamakids.palace.utils.PNGEncoder;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class BitmapAnalyst extends Sprite
	{
		private var dataArr:Array;
		private var bpArr:Array;

		private var originBP:Bitmap;

		private var numw:uint; //横碎片数
		private var numh:uint; //纵碎片数

		private var maxw:Number; //地图宽度
		private var maxh:Number; //地图高度

		private var cellW:Number; //格子宽
		private var cellH:Number; //格子高

		private var scrapW:Number; //碎片宽
		private var scrapH:Number; //碎片高

		private var scaX:Number;

		private var scaY:Number;

		public function BitmapAnalyst(bp:Bitmap, _numw:Number, _numh:Number)
		{
			originBP=bp;

			numw=_numw;
			numh=_numh;

			maxw=originBP.width;
			maxh=originBP.height;

			cellW=maxw / numw;
			cellH=maxh / numh;

			dataArr=[];
			bpArr=[];
		}

		public function initAnalyst():void
		{
			var auxi:SuiPian=new SuiPian();
			scaX=cellW / auxi.low.height;
			scaY=cellH / auxi.low.height;
			scrapW=Math.ceil(auxi.rai.width * 2 * scaX);
			scrapH=Math.ceil(auxi.rai.width * 2 * scaY);

			for (var tx:uint=0; tx < numw; tx++)
			{
				dataArr[tx]=new Array;
				bpArr[tx]=new Array;
				for (var ty:uint=0; ty < numh; ty++)
				{
					var arr:Array=new Array;
					arr[0]=tx == numw - 1 ? 1 : Math.random() < .5 ? 1 : -1;
					arr[1]=ty == numh - 1 ? 1 : Math.random() < .5 ? 1 : -1;
					arr[2]=tx == 0 ? 1 : 0 - dataArr[tx - 1][ty][0];
					arr[3]=ty == 0 ? 1 : 0 - dataArr[tx][ty - 1][1];
					dataArr[tx][ty]=arr;

					var bp:Bitmap=initBP(arr, tx, ty);
					bpArr[tx][ty]=bp;
				}
			}
		}

		public function getPivot():Point
		{
			return new Point(scrapW, scrapH);
		}

		public function getSize():Point
		{
			return new Point(cellW, cellH);
		}

		private function initBP(arr:Array, tx:uint, ty:uint):Bitmap
		{
			var sp:Sprite=new Sprite;
			for (var i:int=0; i < 4; i++)
			{
				var scrap:SuiPian=new SuiPian();
				scrap.x=scrapW / 2;
				scrap.y=scrapH / 2;
				scrap.rotation=i * 90;
				scrap.scaleX=i % 2 ? scaY : scaX;
				scrap.scaleY=i % 2 ? scaX : scaY;
				scrap.low.visible=arr[i] < 0;
				scrap.rai.visible=arr[i] > 0;
				sp.addChild(scrap);
			}

			var spbpd:BitmapData=new BitmapData(scrapW, scrapH, true, 0x00000000);
			spbpd.draw(sp);
			var msk:Bitmap=new Bitmap(spbpd);
			msk.cacheAsBitmap=true;

			var box:Sprite=new Sprite();
			addChild(box);

			originBP.x=(scrapW - cellW) / 2 - cellW * tx;
			originBP.y=(scrapH - cellH) / 2 - cellH * ty;

			box.addChild(originBP);
			box.addChild(msk);
			box.mask=msk;

			addBevelFilter(box);

			box.x=cellW * tx;
			box.y=cellH * ty;

			var bpd:BitmapData=new BitmapData(scrapW, scrapH, true, 0x00000000);
			bpd.draw(box);
			box.removeChildren();
			box=null;
			var image:Bitmap=new Bitmap(bpd);
			image.smoothing=true;

			//			savePNG(bpd, tx.toString() + ty.toString());

			return image;
		}

		private function savePNG(bp:BitmapData, _name:String):void
		{
			var pngEc:PNGEncoder=new PNGEncoder();
			//encode the bitmapdata object and keep the encoded ByteArray
			var imgByteArray:ByteArray=pngEc.encode(bp);
			var file:File=File.desktopDirectory.resolvePath(_name + ".png");
			//Use a FileStream to save the bytearray as bytes to the new file
			var fs:FileStream=new FileStream();
			try
			{
				//open file in write mode
				fs.open(file, FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(imgByteArray);
				//close the file
				fs.close();
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}

		/*碎片斜角滤镜*/
		private function addBevelFilter(value:DisplayObject):void
		{
			var bevel:BevelFilter=new BevelFilter();
			bevel.blurX=5;
			bevel.blurY=5;
			bevel.strength=1;
			bevel.quality=BitmapFilterQuality.LOW;
			bevel.shadowColor=0x000000;
			bevel.shadowAlpha=.9;
			bevel.highlightColor=0xFFFFFF;
			bevel.highlightAlpha=.7;
			bevel.angle=45;
			bevel.distance=2;
			bevel.knockout=false;
			bevel.type=BitmapFilterType.INNER;
			var filtersArray:Array=new Array(bevel);
			value.filters=filtersArray;
		}

		public function getDataArr():Array
		{
			return dataArr;
		}

		public function getBpArr():Array
		{
			return bpArr;
		}

		public function dispose():void
		{
			if (bpArr)
				for (var i:int=0; i < bpArr.length; i++)
				{
					var arr:Array=bpArr[i]
					for (var j:int=0; j < arr.length; j++)
					{
						var bp:Bitmap=arr[j];
						bp.bitmapData.dispose();
					}
					arr=null;
				}
			bpArr=null;
			dataArr=null;
		}
	}
}
