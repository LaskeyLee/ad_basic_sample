package
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	
	public class FlashAdSample extends Sprite
	{
		public function FlashAdSample()
		{
			simpleSend();
			sendWithResult();
		}
		
		private function simpleSend():void{
			sendToURL(new URLRequest("http://www.cnoam.com/tracking"));
		}
		
		private function sendWithResult():void{
			var sender:TrackingSender = new TrackingSender();
			sender.load(new URLRequest("http://www.cnoam.com/tracking"));
		}
		
	}
}