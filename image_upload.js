console.log('Hello World!!');

var gm = require('gm'), 
	fs = require('fs');

function workItem(imagePath) {
	this.imagePath = imagePath;
	this.getImagePath = function() {return this.imagePath;}
}

function fileQueue() {
	this.queue = fs.readdirSync('./img')

	this.pull = function() {
		return this.imagePath;
	}
}




function exec_loop(queue) {
	var active_aps = [];

	var workItem = queue.pull();
	var imagePath = getImagePath(workItem);

	while (!queue.empty) {
		var workItem = queue.pull()
		var imagePath = getImagePath(workItem);
		var promise = doResizeOperation(imagePath);

		promise.

	}
}


