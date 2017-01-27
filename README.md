# PresentedCollection

CLCollection displays its items in a horizontal direction using pagingEnable and tries to fetch items from URL if it is provided.
If it loads items from URL successfully, it will cache items on disks for reuse later.

# Requirements
- iOS 10+
- Swift 3.0+

# Usage
Set CLCollection to a property of an instance of UIViewController subclass by code.
````
var collection: CLCollection!
````

Set the dataSource to CLCollection  
````
collection.dataSource 
````

then call CLCollection's present method

````
collection.present()
````

# PresentedCollection
`PresentedCollection` project comes with a demo app that has a lot of set required to present the CLCollection. 
