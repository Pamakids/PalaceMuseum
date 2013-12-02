package views.global.books.events
{
	public class BookEvent
	{
		/**
		 * 子场景初始化完成后派发该事件
		 */
		public static const Initialized:String="initialized";
		/**
		 * 子场景初始化显示完成，此事件在Initialized之后派发，用以确定场景所有元素及素材加载工作完成，主要用于场景之间的切换
		 */
		public static var InitViewPlayed:String="initViewPlayed";
		/**
		 * 在当前Tab场景内部显示内容更新后派发（如页码变更）
		 */
		public static const ViewUpdated:String="viewUpdated";
		/**
		 * 场景内纹理更新失败，通常原因为已经达到最后一页或处于第一页
		 */
		public static const ViewUpdateFail:String="viewUpdateFail";
	}
}