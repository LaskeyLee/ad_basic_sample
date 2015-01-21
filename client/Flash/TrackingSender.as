package {
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class TrackingSender extends Loader
	{
		public function TrackingSender()
		{
			super();
			timer = new Timer(10000);//10秒超时
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
			timer.start();
		}
		
		private var timer:Timer;
		
		private var trackingType:String;
		
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			super.load(request, context);
			contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, gotHttpStatus);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onTimeOut(e:TimerEvent):void{
			removeURLLoaderListeners();
			trace("超时");
		}
		
		protected function onComplete(evt:Event):void{
			removeURLLoaderListeners();
			trace("成功");
		}
		
		protected function onIOError(evt:IOErrorEvent):void{
			removeURLLoaderListeners();
			//这两种ID，是真正的网络IO错误
			if(evt.errorID == 2036 || evt.errorID == 2035){
				trace("错误:"+evt.errorID+" status "+evt.text);
			}else{
				//其他情况，有可能是
				//Error #2124: 加载的文件为未知类型。
				//这是由于服务器返回的Response Body不是图片导致的，这实际上是成功地发送了监测
				trace("成功，但返回并非图片");
			}
		}
		
		protected function onSecurityError(evt:SecurityErrorEvent):void{
			removeURLLoaderListeners();
		}
		
		protected function removeURLLoaderListeners():void{
			if(contentLoaderInfo){
				contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, gotHttpStatus);
				contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
				contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
				contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			}
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
		}
		
		protected function gotHttpStatus(evt:HTTPStatusEvent):void{
			trace("得到状态码:"+evt.status);
		}
		
		
	}
}