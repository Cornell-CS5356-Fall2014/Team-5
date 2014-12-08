'use strict';

/*
 * Defining the Package
 */
var Module = require('meanio').Module;

var Social = new Module('social');

/*
 * All MEAN packages require registration
 * Dependency injection is used to define required modules
 */
Social.register(function(app, auth, database) {

  //We enable routing. By default the Package Object is passed to the routes
  Social.routes(app, auth, database);

  //We are adding a link to the main menu for all authenticated users
  Social.menus.add({
    title: 'Social',
    link: 'User list',
    roles: ['authenticated'],
    menu: 'main'
  });
  
  Social.aggregateAsset('css', 'social.css');

  /**
    //Uncomment to use. Requires meanio@0.3.7 or above
    // Save settings with callback
    // Use this for saving data from administration pages
    Social.settings({
        'someSetting': 'some value'
    }, function(err, settings) {
        //you now have the settings object
    });

    // Another save settings example this time with no callback
    // This writes over the last settings.
    Social.settings({
        'anotherSettings': 'some value'
    });

    // Get settings. Retrieves latest saved settigns
    Social.settings(function(err, settings) {
        //you now have the settings object
    });
    */

  return Social;
});
