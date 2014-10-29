/**
 * ActionScript client for IronMQ
 * 
 * @link https://github.com/Panhelios/as3-iron_mq
 * 
 * IronMQ is a scalable, reliable, high performance message queue in the cloud.
 */
package panhelios.api.ironio
{	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	public class IronMQ
	{
		private const urlBase:String = "https://mq-aws-us-east-1.iron.io/1/projects/";
		private const urlQueues:String = "/queues/";
		private const urlMessages:String = "/messages";
	
		private var _urlLoader:URLLoader = new URLLoader();
		
		protected var _token:String;
		protected var _projectId:String;
		protected var _defaultQueue:String;
		
		public function IronMQ(token:String, projectId:String)
		{
			_token = token;
			_projectId = projectId;
			
			/* configure URLLoader */
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			/* hook to URLLoader events */
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			_urlLoader.addEventListener(Event.OPEN, onOpen);
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
		}
		
		protected function buildUrl(queueName:String):String
		{
			return urlBase + _projectId + urlQueues + queueName + urlMessages;
		}
		
		/**
		 * Push a message on the queue
		 *
		 * Examples:
		 * <code>
		 * ironMQ.postMessage("test_queue", "Hello world");
		 * </code>
		 * <code>
		 * ironMQ.postMessage("test_queue", "Test Message", {
		 * 	timeout: 120,
		 * 	delay: 2,
		 * 	expires_in: 2*24*3600
		 * });
		 * </code>
		 *
		 * @param String queueName	Name of the queue.
		 * @param String message	Body of the message
		 * @param Object properties	Object of properties, see class Message for description
		 */
		public function postMessage(queueName:String, message:String, properties:Object = null):void
		{
			var msg:Message = new Message(message, properties);
			var request:URLRequest = new URLRequest();
			
			/* prepare headers */
			var contentTypeHeader:URLRequestHeader = new URLRequestHeader("Content-Type", "application/json");
			var authenticationHeader:URLRequestHeader = new URLRequestHeader("Authorization", "OAuth "+ _token);
			
			/* prepare request */
			request.requestHeaders = [contentTypeHeader, authenticationHeader];
			request.method = URLRequestMethod.POST;
			request.url = buildUrl(queueName);
			
			/* preapre messages array */
			var messages:Array = [];
			messages.push(msg.asObject());
			
			/* attach messages to request */
			request.data = JSON.stringify({ messages: messages });

			/* send request to API */
			try {
				_urlLoader.load(request);
			} catch (e:Error) {
				trace(e);
			}
		}
		
		/**
		 * Shorthand function to post an object to a queue
		 *
		 * Examples:
		 * <code>
		 * iron.defaultQueue = "my_queue";
		 * iron.postObject({test: "Hello World"});
		 * </code>
		 *
		 * @param Object message	Object to be posted encapsulated in a message
		 * @param String queue		(option) Name of the target queue
		 */
		public function postObject(message:Object, queue:String = ""):void
		{
			if (queue == "")
				queue = _defaultQueue;
			
			postMessage(queue, JSON.stringify(message));
		}
		
		protected function onSecurity(event:SecurityErrorEvent):void
		{
			//trace("security", event.text);
		}
		
		protected function onStatus(event:HTTPStatusEvent):void
		{
			//trace("status", event.status);
		}
		
		private function onOpen(event:Event):void
		{
			//trace("connection open");
		}
		
		private function onComplete(event:Event):void
		{
			//trace(_urlLoader.data);
		}

		public function get defaultQueue():String
		{
			return _defaultQueue;
		}

		public function set defaultQueue(value:String):void
		{
			_defaultQueue = value;
		}

	}
}

