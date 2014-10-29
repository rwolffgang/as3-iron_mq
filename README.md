# IronMQ ActionScript Client Library (write-only)

This library makes it easy to post messages to the IronMQ queue backend. 

## Usage
To use this library, you'll need an IronMQ account, which you can create at [Iron.io](http://www.iron.io/). 

    var token:String = "WgWOH0ohygGxZ8B7o2p1ErE5i2s"; // example value
	var projectId:String = "52200e53a67bcb0001000060"; // example value
	var iron:IronMQ = new IronMQ(token, projectId);

	iron.postMessage("my_queue", "Hello World");
	// or
	iron.defaultQueue = "my_queue";
	iron.postObject({test: "Hello World"});
	
## Contribution
If you consider a contrubtion to this project, you're welcome. Please stay as close as possible to the function calls of the [IronMQ PHP SDK](https://github.com/iron-io/iron_mq_php). This will make the transition for fellow developers easier.