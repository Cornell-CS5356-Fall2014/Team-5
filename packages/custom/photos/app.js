'use strict';

/*
 * Defining the Package
 */
var Module = require('meanio').Module;

var Photos = new Module('photos');

/*
 * All MEAN packages require registration
 * Dependency injection is used to define required modules
 */
Photos.register(function(app, auth, database) {

  //We enable routing. By default the Package Object is passed to the routes
  Photos.routes(app, auth, database);

  //We are adding a link to the main menu for all authenticated users
  Photos.menus.add({
    title: 'Photos',
    link: 'photos gallery page',
    roles: ['authenticated'],
    menu: 'main'
  });
  
  Photos.aggregateAsset('css', 'photos.css');

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

  return Photos;
});
