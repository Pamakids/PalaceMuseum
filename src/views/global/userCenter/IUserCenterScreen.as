package views.global.userCenter
{
	import starling.textures.Texture;

	public interface IUserCenterScreen
	{
		 /**
		  * 获取场景纹理，用于UserCenter实例动画过渡
		  */		
		 function getScreenTexture():Vector.<Texture>;
		 /**
		  * 检测场景纹理是否已存在
		  * @return 
		  */		 
		 function testTextureInitialized():Boolean;
	}
}