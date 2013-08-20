package modules.module1
{
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;

	import starling.display.Sprite;

	public class List1 extends Sprite
	{
		private var _list:List;
		public function List1()
		{
			var items:Array = [];
			for(var i:int = 0; i < 150; i++)
			{
				var item:Object = {text: "Item " + (i + 1).toString()};
				items.push(item);
			}
			items.fixed = true;

			this._list = new List();
			this._list.dataProvider = new ListCollection(items);
			this._list.typicalItem = {text: "Item 1000"};
//			this._list.isSelectable = this.settings.isSelectable;
//			this._list.allowMultipleSelection = this.settings.allowMultipleSelection;
//			this._list.hasElasticEdges = this.settings.hasElasticEdges;
			//optimization to reduce draw calls.
			//only do this if the header or other content covers the edges of
			//the list. otherwise, the list items may be displayed outside of
			//the list's bounds.
			this._list.clipContent = false;
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				renderer.isQuickHitAreaEnabled = true;
				return renderer;
			};
//			this._list.addEventListener(Event.CHANGE, list_changeHandler);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChild(this._list);
		}
	}
}

