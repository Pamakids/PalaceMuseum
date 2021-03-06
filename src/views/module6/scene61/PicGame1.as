package views.module6.scene61
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class PicGame1 extends PalaceGame
	{
		public function PicGame1(am:AssetManager=null)
		{
			super(am);

			addChild(getImage('artgamebg'));
			var p1:Image=getImage('curtain-l');
			addChild(p1);

			var p2:Image=getImage('pillar-r');
			addChild(p2);
			p2.x=1024-p2.width;

			gameHolder=new Sprite();
			addChild(gameHolder);
			gameHolder.x=161;
			gameHolder.y=78;

			gameHolder.addChild(getImage('art1BG'));

			for (var i:int = 0; i < num; i++) 
			{
				var id:String='block'+(i+1).toString();

				var block:Image=getImage(id);
				var blockBG:Image=getImage(id+'s');
				var halo:Image=getImage('block-halo');
				var piece:PicPiece=new PicPiece(block,blockBG,halo,i);
				pieceArr.push(piece);
				piece.addEventListener(TouchEvent.TOUCH,onTouch);
			}
			pieceArr.reverse();
			shuffle();

			finishPic=getImage('art1');
			addChild(finishPic);
			finishPic.touchable=false;
			finishPic.alpha=0;
			finishPic.x=161;
			finishPic.y=78;
		}

		private function onTouch(e:TouchEvent):void
		{
			var p:PicPiece=e.currentTarget as PicPiece;
			var tc:Touch=e.getTouch(p);
			if(tc)
			{
				if(selectedPiece&&selectedPiece!=p)
					return;

				switch(tc.phase)
				{
					case TouchPhase.BEGAN:
					{
						if(!selectedPiece)
						{
							selectedPiece=p;
							gameHolder.setChildIndex(p,gameHolder.numChildren-1);
							p.showHalo();
//							showHalo(pieceArr.indexOf(p));
						}
						break;
					}

					case TouchPhase.MOVED:
					{
						var mov:Point=tc.getMovement(this);
						p.y+=mov.y;
						if(p.y<0)
							p.y==0;
						if(p.y>GAP*(num-1))
							p.y=GAP*(num-1);

						break;
					}

					case TouchPhase.ENDED:
					{
						var di:int=Math.max(0,Math.min(tc.getLocation(gameHolder).y/GAP,pieceArr.length-1));
						var dp:PicPiece=pieceArr[di];
						if(dp==p||dp.checked)
						{
							var dy:Number=pieceArr.indexOf(p)*GAP;
							gameHolder.touchable=false;
//							hideHalo();
							selectedPiece=null;
							p.hideHalo();
							TweenLite.to(p,.5,{y:dy,onComplete:function():void{
								gameHolder.touchable=true;
							}});

						}else
							swap(dp,p);
						break;
					}

					default:
					{
						break;
					}
				}
//				else
//				{
//					swap(selectedPiece,p);
//				}
			}
		}

		private var num:Number=5;

		private function shuffle():void
		{
			var p:PicPiece=pieceArr.splice(Math.random()*pieceArr.length,1)[0];
			pieceArr.push(p);

			for (var i:int = 0; i < pieceArr.length; i++) 
			{
				if(pieceArr[i].index==i)
				{
					shuffle();
					return;
				}
			}

			placePeices();
		}

		private function placePeices():void
		{
			for (var i:int = 0; i < pieceArr.length; i++) 
			{
				var piece:PicPiece=pieceArr[i];
				gameHolder.addChild(piece);
				piece.y=i*GAP;
			}

//			halo=getImage('block-halo');
//			gameHolder.addChild(halo);
//			halo.touchable=false;
//			halo.pivotX=halo.width>>1;
//			halo.pivotY=halo.height>>1;
//			halo.x=399>>1;
//			hideHalo();

			addClose();
		}

		private var selectedPiece:PicPiece;

		private function swap(p1:PicPiece,p2:PicPiece):void
		{
//			hideHalo();
			if(!selectedPiece||p1==p2){
				selectedPiece=null;
				return;
			}
			selectedPiece=null;
			p1.hideHalo();
			p2.hideHalo();
			gameHolder.setChildIndex(p1,gameHolder.numChildren-1);
			gameHolder.setChildIndex(p2,gameHolder.numChildren-1);

			gameHolder.touchable=false;

			var i1:int=pieceArr.indexOf(p1);
			var i2:int=pieceArr.indexOf(p2);

//			var dx1:Number=p1.x;
			var dy1:Number=i1*GAP;

//			var dx2:Number=p2.x;
			var dy2:Number=i2*GAP;

			pieceArr[i1]=p2;
			pieceArr[i2]=p1;

			function completeFunc():void
			{
				gameHolder.touchable=true;
				checkPieces();
			}

			TweenLite.to(p1,.5,{y:dy2});
			TweenLite.to(p2,.5,{y:dy1,onComplete:completeFunc});

		}

		private function checkPieces():void
		{
			var allCheck:Boolean=true;
			for (var i:int = 0; i < pieceArr.length; i++) 
			{
				var p:PicPiece=pieceArr[i];
				if(p.index==i)
				{
					p.setColor();
				}else
					allCheck=false;
			}

			if(allCheck)
			{
				var text:Image=getImage('text3');
				addChild(text);
				text.x=652;
				text.y=24;
				dispatchEvent(new Event('showCollection',true));
				isWin=true;

				TweenLite.to(finishPic,1,{alpha:1});
			}
		}

		private var pieceArr:Array=[];

//		private function showHalo(index:int):void
//		{
//			halo.y=index*GAP+GAP/2;
//			halo.visible=true;
//		}

//		private function hideHalo():void
//		{
//			halo.visible=false;
//		}

//		private var halo:Image;

		private var GAP:Number=111;

		private var gameHolder:Sprite;

		private var finishPic:Image;
	}
}

