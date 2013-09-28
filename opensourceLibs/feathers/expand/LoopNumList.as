package feathers.expand
{
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	
	public class LoopNumList extends Scroller
	{
		public function LoopNumList(width:Number, height:Number)
		{
			this.width = width;
			this.height = height;
		}
		
		private var datas:Array;
		public function setMinToMax(min:int, max:int):void
		{
		}
		
		private var max:int;
		public function set maximum(value:int):void
		{
		}
		
		private var min:int;
		public function set mininum(value:int):void
		{
		}
		
		private var crt:int;
		private function get crtnum():int
		{
			return crt;
		}
		
		override protected function draw():void
		{
		}
		
		
		private var list_1:List;
		private var list_2:List;
		
		
		override protected function initialize():void
		{
			datas = [];
			initList();
		}
		
		private function initList():void
		{
			list_1 = new List();
			list_2 = new List();
			list_1.dataProvider = new ListCollection(datas);
			list_1.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				return renderer;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}