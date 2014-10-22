'use strict';

/*
 * Defining the Package
 */
var Module = require('meanio').Module;

var Export = new Module('export');

/*
 * All MEAN packages require registration
 * Dependency injection is used to define required modules
 */
Export.register(function(app, auth, database) {

  //We enable routing. By default the Package Object is passed to the routes
  Export.routes(app, auth, database);

  //We are adding a link to the main menu for all authenticated users
  Export.menus.add({
    title: 'export example page',
    link: 'export example page',
    roles: ['authenticated'],
    menu: 'main'
  });
  
  Export.aggregateAsset('css', 'export.css');

  /**
    //Uncomment to use. Requires meanio@0.3.7 or above
    // Save settings with callback
    // Use this for saving data from administration pages
    Export.settings({
        'someSetting': 'some value'
    }, function(err, settings) {
        //you now have the settings object
    });

    // Another save settings example this time with no callback
    // This writes over the last settings.
    Export.settings({
        'anotherSettings': 'some value'
    });

    // Get settings. Retrieves latest saved settigns
    Export.settings(function(err, settings) {
        //you now have the settings object
    });
    */

  return Export;
});
