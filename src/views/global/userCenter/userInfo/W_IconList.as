package views.global.userCenter.userInfo
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import views.global.userCenter.UserCenterManager;

	public class W_IconList extends FeathersControl
	{
		public function W_IconList()
		{
		}
		
		override protected function initialize():void
		{
			initBackground();
			initList();
		}
		
		private var list:List;
		/**
		 * { username: "name", iconIndex: i, birthday: "2013-01-11"},
		 */		
		private function initList():void
		{
			list = new List();
			list.dataProvider = new ListCollection([
				{icon: "0"},
				{icon: "1"},
				{icon: "2"},
				{icon: "3"}
			]);
			list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:IconListRenderer = new IconListRenderer();
				renderer.addEventListener(Event.TRIGGERED, onTriggered);
				return renderer;
			};
			list.width = 480;
			list.height = 120;
			list.layout = new HorizontalLayout();
			this.addChild( list );
			list.x = 44;
			list.y = 31;
		}
		
		private function onTriggered(e:Event):void
		{
			dispatchEventWith(Event.TRIGGERED, false, (e.currentTarget as IconListRenderer).index);
		}
		
		private function initBackground():void
		{
			var image:Image = new Image( UserCenterManager.getTexture("background_iconlist") );
			this.addChild( image );
			this.width = image.width;
			this.height = image.height;
		}
		
		override public function dispose():void
		{
			if(list)
				list.removeFromParent(true);
			super.dispose();
		}
	}
}