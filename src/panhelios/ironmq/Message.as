package panhelios.api.ironio
{
	public class Message
	{
		protected const MAX_EXPIRES_IN:uint = 2592000;

		protected var _body:String;
		
		protected var _timeout:int = 60; // default of API
		protected var _delay:int = 0; // default of API
		protected var _expiresIn:int = 604800; // default of API
		
		/**
		 * Create a new message.
		 *
		 * @param String body
		 * 		A message body
		 * @param Object properties	
		 * 		An array of message properties
		 * 
		 * Attrobites of the properties object:
		 * - timeout: Timeout, in seconds. After timeout, item will be placed back on queue. Defaults to 60.
		 * - delay: The item will not be available on the queue until this many seconds have passed. Defaults to 0.
		 * - expires_in: How long, in seconds, to keep the item on the queue before it is deleted. Defaults to 604800 (7 days). Maximum is 2592000 (30 days).
		 */
		public function Message(body:String, properties:Object = null)
		{
			_body = body;
			
			if (properties)	
			{
				if ("timeout" in properties)
					_timeout = properties["timeout"];
				
				if ("delay" in properties)
					_delay = properties["delay"];
				
				if ("expires_in" in properties)
					_expiresIn = properties["expires_in"];
			}
		}
		
		public function asObject():Object
		{
			var object:Object = {};
			
			object.body = _body;
			
			if (!isNaN(_timeout))
				object.timeout = _timeout;
			if (!isNaN(_delay))
				object.delay = _delay;
			if (!isNaN(_expiresIn))
				object.expires_in = _expiresIn;
			
			return object;
		}
		
		public function toJSONString():String
		{
			return JSON.stringify(asObject());
		}

		public function get body():String
		{
			return _body;
		}

		public function set body(value:String):void
		{
			_body = value;
		}

		public function get timeout():int
		{
			return _timeout;
		}

		public function set timeout(value:int):void
		{
			_timeout = value;
		}

		public function get delay():int
		{
			return _delay;
		}

		public function set delay(value:int):void
		{
			_delay = value;
		}

		public function get expiresIn():int
		{
			return _expiresIn;
		}

		public function set expiresIn(value:int):void
		{
			_expiresIn = value;
		}


	}
}