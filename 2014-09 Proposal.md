#Cookem Cookalicious Project Proposal
**Created 29 September 2014**

**Last Updated 9 October 2014**
##Basic Information
*Team Members*: 	Sean Herman (sjh293) & James Kizer (jdk288)
*Product Name*:	Cook-em' Cookalicious (tentative)

##One Line Description
Cookem Cookalicious (CC) is a iOS app and companion website that allows cooks to journal and share their home kitchen creations. 

###Detailed Description
There are countless recipe and cooking how-to resources available apps and sites available already, but few tools that allow home cooks to simply write about and share their best (and worst) creations. This new product aims to provide a new social discovery and content creation platform focused exclusively on home cooking and baking.
The process of journaling or documenting a night's cooking will be very approachable. Users may take pictures with their normal phone camera, or using the app's built in camera utility. When adding a new journal entry, users will see pictures grouped together in a chronological timeline. After selecting an entry in this timeline, users select one or more photos to begin seed a draft post. Additional pictures may be added, either from the gallery or using a bare bones built-in camera utility. Captions or descriptions may be added to 1 or a group of photos, describing each part of the cooking process. Users can also include detailed recipe information with entries, including ingredients and preparation instructions. Submitted entries will also be publishable into other existing social networks (esp. Facebook).
Beyond this journaling/creation experience, we also hope the app and website will provide a rich cooking discovery experience. By leveraging users' existing social network connections on Facebook, our CC tools will allow users to browse posts by other home cooks. While browsing, users may bookmark posts from other users.
The web experience will be focused primarily on the passive or read-only aspects of the CC product, while the app will provide the necessary features for content creation.
###Minimum Entry Requirements
####User Accounts/Management
CC uses a combination of native, server-side authentication, and Facebook authentication. In other words, users may sign up and login to CC using either a login/password combination or by authenticating through Facebook [1]. 

To facilitate this approach, we are using the Passport module for Node (passportjs.org). Whether the user registers through our website directly, or indirectly via Facebook, we store these credentials in our Mongo database. The Passport module comes built in with Session support, meaning that once users are authenticated, a persistent cookie issued by our server is used to verify that session during subsequent requests. This Session functionality is used to protect API endpoints (i.e., POST requests to /photos), and to display user-specific content on the web and in the mobile app.

####Native App on iOS or Android
Our native application is developed in iOS. We intend to continue focusing the app on the content creation side of the product. At present, the application supports user authentication through Facebook. After login, the app also leverages our user-aware API endpoints to populate the mobile app with photos and articles contributed by the authenticated user. This includes the ability to upload photos captured on the device to the CC web server.

####Meal description/metadata logging
CC's meal description and metadata logging functionality is currently limited to a simple blog-like platform. Users can currently add  text-only articles to the server. Articles posted by authenticated users are visible to every other user logged into the site. These articles are very simple at present, including only a plain-text title and body (plus related metadata, like timestamps and user data). 

We hope to build upon this article foundation to specialize the product for kitchen journaling. Specifically, we will allow users to (optionally) add a "recipe" to journal entries. These recipes will either be added manually by the user, or will be derived from existing recipes sourced to the Yummly API (detailed later) [8].

Though it's not yet supported, we intend to allow photos to be connected to journal entries in some way. At the very least, users will be able to connect one or more images to a journal entry/article, with these images appearing in a simple gallery within or alongside the recipe and journal text. One alternative to this journal entry gallery would be to allow users to indicate where images belong within the body of each new article, though this would require some more complicated content creation functionality.

####Photo capture/storage
Our iOS application allows users to capture photos on the device, and upload these photos to our web server. These photos are stored in our MongoDB database hosted by Compose.IO, and associated with that user. At present, we expose these photos in simple photo galleries available to authenticated users in our iOS and web apps.

####Thumbnailing
We have not yet implemented a thumbnailing service, but have started work on both server-side and client-side iOS thumbnailing functionality.

####Service-Oriented Architecture (SOA)
Our iOS application and website both currently touch all the same API endpoints, and utilize the same server-side tools for articles, photo upload, display, and user authentication.

####Web presence
The web portion of our product will focus on content discovery. As mentioned abovem, we will be utilizing a MEAN stack. Thus, our front end will be implemented in Javascript, utilizing the AngularJS framework. 

The Web app will support recipe and photo viewing, in addition to being the single interface for data export. 

####API for Data Export
We have added a rudimentary data export feature to our website. This export feature is only enabled for users logged in to the site. When the /export endpoint is accessed, we query the database for all the article (i.e., journal entries) and photo objects for that user in our database. Our server responds with a JSON object which includes all this data. Currently, users will need to download each image manually, using the URLs provided in the JSON we deliver. We would eventually like to package all that data up ourselves, and deliver an archive of some kind, in addition to or instead of the JSON data.

####3rd-Party API Integration
We implemented Facebook's Login API, and this is being used for authentication on the web and in our mobile iOS app.

We hope to further leverage the Facebook API to allow our content to be shared to the user's existing network of friends.

###Deep Dives
####Advanced UX
The Cookem Cookalicious mobile app will be implemented as a universal iOS app and will include both iPhone and iPad specific interfaces. These interfaces may include advanced features such as the collection view water fall layout as well as advanced animations.

The Cookem Cookalicious web app will support responsive design via AngularJS.

Per the milestones below, we are planning on having UX design completed by Nov 14th. Both web and iOS will combine built-in views, 3rd party views, and custom views. We will design the UX with the full knowledge of built-in views and 3rd party views that are available to us.

#### Social Networking
Presently, the CC exposes journal entries (articles) posted by all users across the entire site. In place of this arrangement, we intend to implement a basic friending or following mechanism, allowing users to follow one another, or to establish a 1-to-1 friendship. Adding friends on CC will allow for more a more personalized browsing experience.

Implementing this functionality will require new database models that captures relationships between users, modifications to existing API endpoints (or entirely new "friend aware" endpoints), and new views in the iOS and web versions of CC.

####Public API
CC will allow users to search for and repurpose recipes sourced to the Yummly API, and to add new recipes from scratch. These recipes, in addition to the cooking journals and photos added by users will be content that we will expose via a set of public APIs.

###Milestones
* Oct 15:
		1) ~~MEAN Stack up~~
		2) ~~User Accounts (authentication via Facebook)~~
		3) ~~Photo capture~~ and thumbnailing
			3.1) ~~Capture via iOS app~~
			3.2) ~~Viewing via Web app~~ 
* Oct 22: 
		1) Recipe Logging on iOS
			1.1) ~~Viewing on Web~~
		2) Integrate with Yummy API for recipe creation
		3) ~~API For Data Export~~
			3.1) ~~Download interface on Web~~

* Nov 9: Photo thumbnailing service, iOS journal entry creation (text + image). Search via Yummly API [8]. Recipe creation. Add recipe data to journal entries.
* Nov 15: Friending/following mechanism, and filtered friend views. Share to Facebook support.
* Dec 10: Final Deliverable and Report.
###Division of Labor
System Architecture: Both
API Design and Integration: Both
Web App: Sean
iOS App: James
dB: Sean
SOA: James
[1]: https://developers.facebook.com/docs/facebook-login/overview/v2.1 "Facebook Login Overview"
[4]: https://dev.twitter.com/web/sign-in "Sign in with Twitter"
[5]: https://developers.google.com/accounts/docs/OpenID "Google+ Sign-In"
[6]: https://dev.twitter.com/rest/reference/post/statuses/update "Twitter: POST statuses/update"
[7]: https://developers.facebook.com/docs/sharing "Facebook Sharing Allow your users to post to Facebook from your app."
[8]: https://developer.yummly.com "Yummy API"
[11]: http://redlaser.com/developers/ "RedLaser Developers"
