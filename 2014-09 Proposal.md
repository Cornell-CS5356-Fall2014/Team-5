#Cookem Cookalicious Project Proposal
**dated 29 September 2014**
###Basic Information
*Team Members*: 	Sean Herman (sjh293) & James Kizer (jdk288)
*Product Name*:	Cook-em' Cookalicious (tentative)
###Product Description
Cookem Cookalicious (CC) is a iOS app and companion website that allows cooks to journal and share their home kitchen creations. There are countless recipe and cooking how-to resources available apps and sites available already, but few tools that allow home cooks to simply write about and share their best (and worst) creations. This new product aims to provide a new social discovery and content creation platform focused exclusively on home cooking and baking.
The process of journaling or documenting a night's cooking will be very approachable. Users may take pictures with their normal phone camera, or using the app's built in camera utility. When adding a new journal entry, users will see pictures grouped together in a chronological timeline. After selecting an entry in this timeline, users select one or more photos to begin seed a draft post. Additional pictures may be added, either from the gallery or using a bare bones built-in camera utility. Captions or descriptions may be added to 1 or a group of photos, describing each part of the cooking process. Users can also include detailed recipe information with entries, including ingredients and preparation instructions. Submitted entries will also be publishable into other existing social networks (esp. Facebook).
Beyond this journaling/creation experience, we also hope the app and website will provide a rich cooking discovery experience. By leveraging users' existing social network connections on Facebook, our CC tools will allow users to browse posts by other home cooks. While browsing, users may bookmark posts from other users.
The web experience will be focused primarily on the passive or read-only aspects of the CC product, while the app will provide the necessary features for content creation.
###Minimum Entry Requirements
####User Accounts/Management
Rather than requiring that users create unique credentials for our product, we intend to leverage *Facebook Login* technology. We will naturally still need to store some user account data (e.g., users that have signed up, Facebook OpenID tokens, etc.), but user verification will be managed with existing Facebook credentials [1].
####Native App on iOS or Android
Our native application will be developed for iOS, and will focus on the content creation portions of the product. This will require extensive integration with the camera and gallery features. Entries created on mobile devices will, however, be viewable either in the app or on the web.
####Meal description/metadata logging
Logging of meals will focus heavily on the photographs users take during the cooking process. We do hope to allow users to tie photographs together with posts and photo grouping, but the experience will be photo-centric. Each distinct journal entry will actually consist of 1 or more sub-entries. Each sub-entry represents a stage in a meal’s preparation, and may include 1 or more photos, and a writeup.
Top-level journal entries may also include full recipes (list of ingredients, quantities, preparation instructions). These recipe/ingredient sections will be visually distinct from other sub-entries. Furthermore, each top-level entry will include a _Title_ and a _Banner/Headline_ image. It will be these elements (title, banner image) that are shown to users browsing other journal entries in their app.
####Photo capture/storage
We intend to use the iOS camera or a bare-bones photograph utility to allow users to capture images during meal preparation. Any images taken within the app will be stored in a dedicated folder on the device. Photos added to journal entries published using the CC app will be stored in our content database, along with the rest of the entry metadata.
####Thumbnailing
Banner images included with each top-level journal entry will be appropriately re-sized to make the images browsable in a blog or [Facebook] News Feed style chronological timeline.
####Service-Oriented Architecture (SOA)
In order to allow for development on 2 platforms simultaneously (iOS, web), we intend to develop a universal set of API endpoints. Using these endpoints, requests from either mobile or the web will hit the same pieces of back-end query and update logic.
To facilitate this design pattern, we have a rudimentary Flask application up and running on an AWS EC2 instance. All the necessary API endpoints for content creation and discovery will be consolidated into a RESTful API implemented in Python on the Flask framework. At the very least, we will use Flask's well integrated SQL-Alchemy extension for database access [2], and the Flask-RESTful extension [3] may also be installed to speed the development of API features.
####Web presence
The web portion of our product will focus on content discovery. We have a rudimentary "Hello, world" page setup through Flask, but are investigating more flexible front-end frameworks like AngularJS as an alternative. Full reliance on Flask's Jinja2 templating engine would likely limit the features that could be provided on the web.
####API for Data Export
The data export API will also be served by Python. We expect that a certain endpoint will simply provide a full zipped-archive a CSV data representing all of that user's non-photographic content. Photographs will not be included in data export, since we intend to simply pull that content from the phone, which suggests that the user should have that data already in hand.
####3rd-Party API Integration
As mentioned previously, we intend to leverage Facebook's Login API. Depending on the difficulty encountered in implementing Facebook login (which uses the non-standard Facebook Connect interface), we might also implement one or both of Twitter[4] Google's[5] competing sign-in products.
Furthermore, we intend to provide some hooks to social network APIs that allow users to republish[6]  content created within the application more widely[7].
###Deep Dives
###Advanced UX
The Cookem Cookalicious mobile app will be implemented as a universal iOS app and will include both iPhone and iPad specific interfaces. These interfaces may include advanced features such as the collection view water fall layout as well as advanced animations.
The Cookem Cookalicious web app will support responsive design.
###Public API
The Cookem Cookalicious family of applications will provide users with access to the estimated nutritional content associated with the recipes that they view. For each ingredient we provide access to, we will map to an item in the USDA nutrient database [8]. 
We also plan on providing a nutrition tracking feature. This will allow users to say that they ate a recipe and specify a number of servings. We are planning integrating with the Jawbone Up API [9] to push nutrition information to a user’s Jawbone Up account.
We are also planning on integrating with the Yummy API to support recipe discovery [10].
###UPC Scanning
We are also planning on adding barcode scanning support via RedLaser [11].
###Milestones
Oct 15: Minimum Entry Requirements
Oct 26: Advanced UI/UX Design Complete
Nov 10: API Integration Complete
Nov 24: UI/UX + UPC Scanning Integration Complete
Dec 10: Final Deliverable and Report
###Division of Labor
System Architecture: Both
API Design and Integration: Both
Web App: Sean
iOS App: James
dB: Sean
SOA: James
[1]: https://developers.facebook.com/docs/facebook-login/overview/v2.1 "Facebook Login Overview"
[2]: https://pythonhosted.org/Flask-SQLAlchemy/	"Flask-SQLAlchemy"
[3]: http://flask-restful.readthedocs.org/en/latest/ "Flask-RESTful"
[4]: https://dev.twitter.com/web/sign-in "Sign in with Twitter"
[5]: https://developers.google.com/accounts/docs/OpenID "Google+ Sign-In"
[6]: https://dev.twitter.com/rest/reference/post/statuses/update "Twitter: POST statuses/update"
[7]: https://developers.facebook.com/docs/sharing "Facebook Sharing Allow your users to post to Facebook from your app."
[8]: http://ndb.nal.usda.gov/ndb/ “USDA National Nutrient Database for Standard Reference”

[9]: https://jawbone.com/up/developer “UP for Developers”

[10]: https://developer.yummly.com/ “The Yummly API” 

[11]: http://redlaser.com/developers/ “RedLaser Developers”
