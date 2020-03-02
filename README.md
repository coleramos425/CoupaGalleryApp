# CoupaGalleryApp
 Gallery app designed to allow user to view high quality images from their phone.
 
About:
I created this app using Unsplash's API designed for swift development. Once inside of the app the user is promped to pick some of their favorite images resulting from their search query. Once selected they can swipe through theses images in the app and create a new search if they'd like to continue.

My goals were to give users a clean and intuitive experience while using something as basic as a photo viewer. Data from each url call is cached locally in a file directory specified in DataCollectionViewViewCell.swift. This way whenever a user is referencing a image URL that they've already used with the app we don't have to make another call to download information.

To refresh a search the user can simply pull down on the page to return home or they can enter a new search query in the search box. They app handels cases like when the user submits an empty search box by provide popular image results and when the query is invalid the user is prompted to try again with a different entry.

Installation Requirements:
-Xcode
-Unsplash Cocoapod (https://unsplash.com/developers
-Ruby (for gem instalation of cocoapods)
