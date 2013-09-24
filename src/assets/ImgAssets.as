package assets
{
	public class ImgAssets
	{
		public function ImgAssets()
		{
		}

		// game top

//		[Embed(source="data/images/game_top_reset_bg.png")] public static const img_game_top_reset_bg:Class
//		[Embed(source="data/buttons/game_top_reset_no.png")] public static const img_game_top_reset_no:Class
//		[Embed(source="data/buttons/game_top_reset_yes.png")] public static const img_game_top_reset_yes:Class
		
		// game scene
		[Embed(source="data/images/bgAAA.jpg")] public static const img_bgAAA:Class
		
		// game scene
		[Embed(source="data/images/bgAA.jpg")] public static const img_bgAA:Class
		

		[Embed(source="data/images/tipA.png")] public static const img_tipA:Class
		[Embed(source="data/images/tipB.png")] public static const img_tipB:Class
		[Embed(source="data/images/tipC.png")] public static const img_tipC:Class
		[Embed(source="data/images/tipD.png")] public static const img_tipD:Class
		
		[Embed(source="data/images/tipA2.jpg")] public static const img_tipA2:Class
		[Embed(source="data/images/tipB2.png")] public static const img_tipB2:Class
		[Embed(source="data/images/tipC2.png")] public static const img_tipC2:Class
		[Embed(source="data/images/tipD2.png")] public static const img_tipD2:Class
		
		[Embed(source="data/images/tipA3.png")] public static const img_tipA3:Class
		[Embed(source="data/images/tipB3.png")] public static const img_tipB3:Class
		[Embed(source="data/images/tipC3.png")] public static const img_tipC3:Class
		[Embed(source="data/images/tipD3.png")] public static const img_tipD3:Class

		[Embed(source="data/images/tipA4.png")] public static const img_tipA4:Class
		[Embed(source="data/images/tipB4.png")] public static const img_tipB4:Class
		[Embed(source="data/images/tipC4.png")] public static const img_tipC4:Class
		[Embed(source="data/images/tipD4.png")] public static const img_tipD4:Class

		
		public static function getTipList(index:int):Array{
			if(index == 0) return [img_tipA,img_tipB,img_tipC,img_tipD]
			if(index == 1) return [img_tipA2,img_tipB2,img_tipC2,img_tipD2]
			if(index == 2) return [img_tipA3,img_tipB3,img_tipC3,img_tipD3]
			if(index == 3) return [img_tipA4,img_tipB4,img_tipC4,img_tipD4]
			return null
		}
		
		[Embed(source="data/images/bgA.jpg")] public static const img_bgA:Class
		[Embed(source="data/images/bgB.jpg")] public static const img_bgB:Class
		[Embed(source="data/images/bgC.jpg")] public static const img_bgC:Class
		[Embed(source="data/images/bgD.jpg")] public static const img_bgD:Class
		
		public static function getBgRef(index:int):Class{
			if(index == 0) return img_bgA
			if(index == 1) return img_bgB
			if(index == 2) return img_bgC
			if(index == 3) return img_bgD
			return null
		}
		
		[Embed(source="data/images/translateA.png")] public static const imgtranslateA:Class
		[Embed(source="data/images/translateB.png")] public static const imgtranslateB:Class
		[Embed(source="data/images/translateC.png")] public static const imgtranslateC:Class
		[Embed(source="data/images/translateD.png")] public static const imgtranslateD:Class
		
		public static function getTranslateRef(index:int):Class{
			if(index == 0) return imgtranslateA
			if(index == 1) return imgtranslateB
			if(index == 2) return imgtranslateC
			if(index == 3) return imgtranslateD
			return null
		}
	}
}