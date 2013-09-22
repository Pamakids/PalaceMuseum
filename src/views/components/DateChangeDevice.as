package views.components
{
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 时间更改组件，时间单位最小至“天”
	 * @author Administrator
	 */	
	public class DateChangeDevice extends Sprite
	{
		public function DateChangeDevice(width:Number, height:Number)
		{
			init();
		}
		
		private function init():void
		{
			initBackground();
		}
		
		private function initBackground():void
		{
			initImages();
			initLabels();
			initScrolls();
		}
		
		private function initScrolls():void
		{
			
		}
		
		private function initLabels():void
		{
			var Y:int = 50;
			var label:Label = labelFactory();
			label.text = "生日";
//			label.x = 0;
//			label.y = Y;
			this.addChild(label);
			label.touchable =false;
			
			label = labelFactory();
			label.text = "年";
//			label.x = 0;
//			label.y = Y;
			this.addChild( label );
			label.touchable = false;
			
			label = labelFactory();
			label.text = "月";
//			label.x = 0;
//			label.y = Y;
			this.addChild( label );
			label.touchable = false;
			
			label = labelFactory();
			label.text = "日";
//			label.x = 0;
//			label.y = Y;
			this.addChild( label );
			label.touchable = false;
		}
		
		private function initImages():void
		{
			var texture:Texture = UserCenterManager.getTexture("");
			backgroundY = new Image(texture);
			texture = UserCenterManager.getTexture("");			//共用纹理
			backgroundM = new Image(texture);
			backgroundD = new Image(texture);
		}
		
		private function labelFactory():Label
		{
			var label:Label = new Label();
			label.textRendererProperties.textFormat = new TextFormat( FontVo.PALACE_FONT, 26, 0x5e6311);
			label.textRendererProperties.embedFonts = true;
			return label;
		}
		
		/**
		 * 设置时间显示范围
		 * @param min
		 * @param max
		 */		
		public function setMinToMax(min:Date, max:Date):void
		{
		}
		
		private var _crtDate:Date = new Date();
		public function get crtDate():Date
		{
			return crtDate;
		}
		public function set crtDate(date:Date):void
		{
			_crtDate = date;
		}
		
		private var _maxDate:Date = new Date(2014, 12, 31);;
		public function set maxDate(date:Date):void
		{
			_maxDate = date;
		}
		
		private var _minDate:Date = new Date(1930, 01, 01);
		public function set minDate(date:Date):void
		{
			_minDate = date;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		//组件背板
		private var backgroundY:Image;
		private var backgroundM:Image;
		private var backgroundD:Image;
//		private var defaultSkin:DisplayObject;
		
//		/**
//		 * 设置日期显示背景，日期背景若无纹理，则与月份共用
//		 * @param textureY
//		 * @param textureM
//		 * @param textureD
//		 * 
//		 */	
//		public function setTextures(textureY:Texture, textureM:Texture, textureD:Texture=null):void
//		{
//		}
//		public function set defaultSkin(value:DisplayObject):void
//		{
//		}
//		public function set gap(value:Number):void
//		{
//		}
//		public function set padding(value:Number):void
//		{
//		}
//		public function set paddingLeft(value:Number):void
//		{
//		}
//		public function set paddingRight(value:Number):void
//		{
//		}
//		public function set paddingTop(value:Number):void
//		{
//		}
//		public function set paddingBottom(value:Number):void
//		{
//		}
//		override public function set width(value:Number):void
//		{
//		}
//		override public function set height(value:Number):void
//		{
//		}
	}
}