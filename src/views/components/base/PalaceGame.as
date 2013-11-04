package views.components.base
{
	import com.pamakids.palace.utils.StringUtils;

	import controllers.MC;

	import models.SOService;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.global.TailBar;
	import views.global.TopBar;

	public class PalaceGame extends Container
	{
		public static const GAME_OVER:String="gameOver";
		public static const GAME_RESTART:String="gameRestart";

		protected var assetManager:AssetManager;
		public var fromCenter:Boolean=false;
		private var _isWin:Boolean;

		public function get isWin():Boolean
		{
			return _isWin;
		}

		public function set isWin(value:Boolean):void
		{
			if (_isWin == value)
				return;
			_isWin=value;
			if (value)
				end();
		}


		public function get gameName():String
		{
			return StringUtils.getClassName(this);
		}

		public function PalaceGame(am:AssetManager=null)
		{
			SOService.instance.setSO(gameName, true);
			assetManager=am;
			super();
		}

		protected function addBG():void
		{
			var bg:Image=Image.fromBitmap(new PalaceModule.gameBG());
			addChild(bg);
		}

		public function get gameResult():String
		{
			return gameName + "gameresult";
		}

		override protected function onStage(e:Event):void
		{
			super.onStage(e);
			MC.isTopBarShow=false;
			TopBar.hide();
			TailBar.hide();
			MC.instance.hideMC();
		}

		override protected function init():void
		{
		}

		protected var closeBtn:ElasticButton;

		protected function addClose(_x:Number=950, _y:Number=60):void
		{
			closeBtn=new ElasticButton(getImage("button_close"));
			closeBtn.shadow=getImage("button_close_down");
			closeBtn.x=_x;
			closeBtn.y=_y;
			addChild(closeBtn);
			closeBtn.addEventListener(ElasticButton.CLICK, onCloseClick);
		}

		protected function onCloseClick(e:Event):void
		{
			dispatchEvent(new Event(PalaceGame.GAME_OVER));
		}

		protected function end():void
		{
			if (closeBtn)
				closeBtn.changeSkin(getImage("button_next"), getImage("button_next_down"));
		}

		override public function dispose():void
		{
			if (fromCenter)
				assetManager.dispose()
			else
				assetManager=null;
			super.dispose();
			MC.isTopBarShow=true;
			TopBar.show();
			MC.instance.showMC();
		}

		protected function getImage(name:String):Image
		{
			var t:Texture
			if (MC.assetManager)
				t=MC.assetManager.getTexture(name);
			if (!t && assetManager)
				t=assetManager.getTexture(name)
			if (t)
				return new Image(t);
			else
				return null;
		}
	}
}
