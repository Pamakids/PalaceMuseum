package
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayoutData;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import themes.AeonDesktopTheme.source.feathers.themes.AeonDesktopTheme;
	import themes.MetalWorksMobileTheme.source.feathers.themes.MetalWorksMobileTheme;
	import themes.MinimalMobileTheme.source.feathers.themes.MinimalMobileTheme;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			else
				initialize();
		}
		
		private var _container:Vector.<Sprite>;
		private var _buttonGroup:ButtonGroup;
		private var themeIndex:int = 0;
		private const labels:Array = ["AeonDesktopTheme","MetalWorksMobileTheme","MinimalMobileTheme"];
		private function initialize(e:Event=null):void
		{
			
			initSprite();
			//初始化主题
			setThemes();
			initBtns();
		}
		
		private function initSprite():void
		{
			_container = new Vector.<Sprite>();
			var sprite:Sprite;
			for(var i:int = 0;i<3;i++)
			{
				sprite = new Sprite();
				this.addChild( sprite );
				_container[i] = sprite;
			}
		}
		
		private function initBtns():void
		{
			_buttonGroup = new ButtonGroup();
			_buttonGroup.dataProvider = new ListCollection([
				{label:labels[0], triggered:button_triggeredHandler},
				{label:labels[1], triggered:button_triggeredHandler},
				{label:labels[2], triggered:button_triggeredHandler}
			]);
			
			const buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
			buttonGroupLayoutData.horizontalCenter = 0;
			buttonGroupLayoutData.verticalCenter = 0;
			_buttonGroup.layoutData = buttonGroupLayoutData;
			addChild( _buttonGroup );
		}
		
		private function setThemes():void
		{
			switch(this.themeIndex)
			{
				case 0:
					new AeonDesktopTheme();
					break;
				case 1:
					new MetalWorksMobileTheme();
					break;
				case 2:
					/*这个主题会报错*/
//					new MinimalMobileTheme();
					break;
			}
		}
		
		private function button_triggeredHandler(e:Event):void
		{
			var button:Button = Button(e.target);
			var index:int = labels.indexOf(button.label);
			if(this.themeIndex == index)
				return;
			this.themeIndex = index;
			setThemes();
			updateView();
		}
		
		private function updateView():void
		{
			_container[this.themeIndex].addChild( _buttonGroup );
		}
	}
}