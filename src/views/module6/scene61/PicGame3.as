package views.module6.scene61
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class PicGame3 extends PalaceGame
	{
		public function PicGame3(am:AssetManager=null)
		{
			super(am);

			addChild(getImage('artgamebg'));
			var p1:Image=getImage('curtain-l');
			p1.scaleX=-1;
			addChild(p1);
			p1.x=1024;

			var p2:Image=getImage('pillar-r');
			addChild(p2);
			p2.scaleX=-1;
			p2.x=p2.width;

			initPics();

			initPieces();

			addClose();
		}

		private function initPics():void
		{
			shadowHolder=new Sprite();
			addChild(shadowHolder);
			var img:Image=getImage('art3BG');
			img.x=picX;
			img.y=picY;
			shadowHolder.addChild(img);
			shadowHolder.touchable=false;

			pieceHolder=new Sprite();
			addChild(pieceHolder);

			finPic=getImage('art3');
			addChild(finPic);
			finPic.x=picX;
			finPic.y=picY;
			finPic.alpha=0;
			finPic.touchable=false;
		}

		private var picX:Number=161;
		private var picY:Number=77;

		private function initPieces():void
		{
			shadowPosArr.push(new Point(607,139));
			shadowPosArr.push(new Point(797,182));
			shadowPosArr.push(new Point(630,275));
			shadowPosArr.push(new Point(748,378));
			shadowPosArr.push(new Point(630,511));

			posArr.push(new Point(picX+103,picY+301));
			posArr.push(new Point(picX+58,picY+421));
			posArr.push(new Point(picX-9,picY+129));
			posArr.push(new Point(picX+58,picY+34));
			posArr.push(new Point(picX-9,picY+419));

			for (var i:int = 0; i < 5; i++) 
			{
				var id:String='cut'+(i+1).toString();
				var img:Image=getImage(id);
				var img2:Image=getImage(id+'s');

				var pos:Point=shadowPosArr[i];

				img.x=img2.x=pos.x;
				img.y=img2.y=pos.y;

				shadowHolder.addChild(img2);
				pieceHolder.addChild(img);

				img.addEventListener(TouchEvent.TOUCH,onPieceTouch);

				pieceArr.push(img);
				hitArr.push(new Rectangle(posArr[i].x,posArr[i].y,img.width,img.height));
			}
		}

		private function onPieceTouch(e:TouchEvent):void
		{
			var img:Image=e.currentTarget as Image;
			var tc:Touch=e.getTouch(img);
			if(!tc)
				return;

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					TweenLite.killTweensOf(img);
					break;
				}

				case TouchPhase.MOVED:
				{
					var mov:Point=tc.getMovement(this)
					img.x+=mov.x;
					img.y+=mov.y;
					break;
				}

				case TouchPhase.ENDED:
				{
					check(img)
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function check(img:Image):void
		{
			var index:int=pieceArr.indexOf(img);
			var rect:Rectangle=hitArr[index];
			var dpt:Point;
			if(rect.contains(img.x+img.width/2,img.y+img.height/2))
			{
				img.touchable=false;
				checkArr[index]=true;
				dpt=posArr[index];
			}else
			{
				dpt=shadowPosArr[index];
			}

			TweenLite.to(img,.5,{x:dpt.x,y:dpt.y});

			for each (var b:Boolean in checkArr) 
			{
				if(!b)
					return;
			}

			var text:Image=getImage('text3');
			addChild(text);
			text.x=652;
			text.y=24;

			isWin=true;
			TweenLite.to(finPic,.5,{alpha:1});
			TweenLite.to(shadowHolder,.5,{alpha:0});
			dispatchEvent(new Event('showCollection',true));
		}

		private var pieceArr:Array=[];
		private var posArr:Array=[];
		private var shadowPosArr:Array=[];
		private var hitArr:Array=[];

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(5);

		private var shadowHolder:Sprite;
		private var pieceHolder:Sprite;

		private var finPic:Image;
	}
}

