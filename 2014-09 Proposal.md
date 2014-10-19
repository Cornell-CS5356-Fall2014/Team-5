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

When a photo is captured and uploaded to the server, the server will also scale the image down to thumbnail size and store this copy as well. Both regular and thumbnail URLs will be provided in the JSON metadata returned to the client.
####Service-Oriented Architecture (SOA)
In order to allow for development on 2 platforms simultaneously (iOS, web), we intend to develop a universal set of API endpoints. Using these endpoints, requests from either mobile or the web will hit the same pieces of back-end query and update logic.
To facilitate this design pattern, we will be running a MEAN stack on Heroku. 

We will need to include an image processing service to support thumbnailing.
####Web presence
The web portion of our product will focus on content discovery. As mentioned abovem, we will be utilizing a MEAN stack. Thus, our front end will be implemented in Javascript, utilizing the AngularJS framework. 

The Web app will support recipe and photo viewing, in addition to being the single interface for data export. 

####API for Data Export
The data export API will also be served by Node. We expect that a certain endpoint will simply provide a full zipped-archive a CSV data representing all of that user's non-photographic content. Photographs will not be included in data export.
####3rd-Party API Integration
As mentioned previously, we intend to leverage Facebook's Login API. Depending on the difficulty encountered in implementing Facebook login (which uses the non-standard Facebook Connect interface), we might also implement one or both of Twitter[4] Google's[5] competing sign-in products.
Furthermore, we intend to provide some hooks to social network APIs that allow users to republish[6]  content created within the application more widely[7].
###Deep Dives
###Advanced UX
The Cookem Cookalicious mobile app will be implemented as a universal iOS app and will include both iPhone and iPad specific interfaces. These interfaces may include advanced features such as the collection view water fall layout as well as advanced animations.

The Cookem Cookalicious web app will support responsive design via AngularJS.

Per the milestones below, we are planning on having UX design completed by Oct. 29. Both web and iOS will combine built-in views, 3rd party views, and custom views. We will design the UX with the full knowlege of built-in views and 3rd party views that are available to us.

###Public API
The Cookem Cookalicious family of applications will provide users with access to the estimated nutritional content associated with the recipes that they view. For each ingredient we provide access to, we will map to an item in the USDA nutrient database [8]. 
We also plan on providing a nutrition tracking feature. This will allow users to say that they ate a recipe and specify a number of servings. We are planning integrating with the Jawbone Up API [9] to push nutrition information to a user’s Jawbone Up account.
We are also planning on integrating with the Yummy API to support recipe discovery [10].
###UPC Scanning
One of the convenieces that we can provide to our users when creating a recipe is that rather than doing a text based search for an ingredient, the user could simply scan the UPC code and the system would find the item automatically. To support this, we are planning on adding barcode scanning support via RedLaser [11]. RedLaser outputs a UPC code, which we will use to perform the item lookup. Item lookup support via the Nutritionix API. Nutritionix provides item information as well as nutritional information.
###Milestones
* Oct 15:

		1) MEAN Stack up
		2) User Accounts (authentication via Facebook)
		3) Photo capture and thumbnailing
			3.1) Capture via iOS app
			3.2) Viewing via Web app
	  
* Oct 22: 

		1) Recipe Logging on iOS
			1.1) Viewing on Web
		2) Integrate with Yummy API for recipe creation
		3) API For Data Export
			3.1) Download interface on Web

* Oct 29: Advanced UI/UX Design Complete
* Nov 10: API Integration Complete
* Nov 24: UI/UX + UPC Scanning Integration Complete
* Dec 10: Final Deliverable and Report
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
[8]: http://ndb.nal.usda.gov/ndb/ “USDA National Nutrient Database for Standard Reference”

[9]: https://jawbone.com/up/developer “UP for Developers”

[10]: https://developer.yummly.com/ “The Yummly API” 

[11]: http://redlaser.com/developers/ “RedLaser Developers”
