'use strict';

// Requires meanio
var mean = require('meanio');
var bodyParser     = require('body-parser');

// Creates and serves mean application
mean.serve({ /*options placeholder*/ }, function(app, config) {
	var port = config.https && config.https.port ? config.https.port : config.http.port;
	console.log('Mean app started on port ' + port + ' (' + process.env.NODE_ENV + ')');

	app.use(bodyParser.json());
	app.use(bodyParser.urlencoded({ extended: true }));



});
