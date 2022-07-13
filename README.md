# Shopping App

## About
Shopping App is a Flutter app that runs on android and iOS devices. 
It handles two user types. User,Admin
Uses Firebase for backend 

User can sign up or log in, and can browse through products to favor and purchase.
User can view passed orders. (These orders are not persisted in the database)

https://user-images.githubusercontent.com/30713943/173258378-4d41dcb8-8f24-4df8-a9cb-e7eec34c444c.mov



Admin users have the same privileges a regular user has, except they can edit, add and delete products.



https://user-images.githubusercontent.com/30713943/173258629-464958a1-e8e1-4698-9f0f-a5f7940b3d62.mov




https://user-images.githubusercontent.com/30713943/173258672-2bcee4de-aac4-4b95-842c-d2af03662ff4.mov





## Firebase
Firebase Authentication - for registration and login functionalities

Firestore Database - storing user and product info, Rules are set where only user's with an admin role can add, delete products.
<img width="500" alt="rules" src="https://user-images.githubusercontent.com/30713943/173258368-431693cd-d730-41e6-8637-6f21a92fe4d0.png">


Cloud Functions - to set user roles in the user's token custom claims
<img width="500" alt="cloud-functions" src="https://user-images.githubusercontent.com/30713943/173258360-91ee85e3-764b-415c-a5e8-d0a53161bd03.png">



## Packages
* firebase_core
* firebase_auth
* cloud_firestore
* cloud_functions
* provider
* intl
* cached_network_image
   
### Widgets
* buildTransitions
* SlideTransition
* CircularProgressIndicator
* LinearProgressIndicator
* TweenAnimationBuilder
* AnimatedContainer
* CachedNetworkImage
* Dismissible
* AlertDialog
* SnackBar
* DefaultTabController
* StreamBuilder
* ListView.builder
* Form
* Drawer
* ListTile
* Stack
* ExpandIcon
* CircleAvatar
* Chip
* Spacer
* Divider










# shopping-app
