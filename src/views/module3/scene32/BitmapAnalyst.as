package views.module3.scene32
{
	import flash.display.Bitmap;

	public class BitmapAnalyst
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

		public function BitmapAnalyst(bp:Bitmap, _numw:Number, _numh:Number)
		{
			originBP=bp;

			numw=_numw;
			numh=_numh;

			maxw=originBP.width / numw;
			maxh=originBP.height / numh;

			dataArr=[];
			bpArr=[];
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
