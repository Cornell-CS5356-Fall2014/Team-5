'use strict';

/*
 * Defining the Package
 */
var Module = require('meanio').Module,
  bodyParser = require('body-parser');

var JournalEntries = new Module('journalEntries');



/*
 * All MEAN packages require registration
 * Dependency injection is used to define required modules
 */
JournalEntries.register(function(app, auth, database) {

  //app.use(express.bodyParser());
  app.use(bodyParser.json());

  //We enable routing. By default the Package Object is passed to the routes
  JournalEntries.routes(app, auth, database);

  //We are adding a link to the main menu for all authenticated users
  // Photos.menus.add({
  //   title: 'Photo Gallery',
  //   link: 'photos gallery page',
  //   roles: ['authenticated'],
  //   menu: 'main'
  // });
  
  // Photos.aggregateAsset('css', 'photos.css');

  /**
    //Uncomment to use. Requires meanio@0.3.7 or above
    // Save settings with callback
    // Use this for saving data from administration pages
    Photos.settings({
        'someSetting': 'some value'
    }, function(err, settings) {
        //you now have the settings object
    });

    // Another save settings example this time with no callback
    // This writes over the last settings.
    Photos.settings({
        'anotherSettings': 'some value'
    });

    // Get settings. Retrieves latest saved settigns
    Photos.settings(function(err, settings) {
        //you now have the settings object
    });
    */

  return JournalEntries;
});
