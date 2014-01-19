KPGallery
=========

A gallery for iOS that is made to be easily added to other projects

KPGallery is heavily modified and based on the "Creating a Paged Photo Gallery With a UICollectionView" tutorial by Tim Duckett at http://adoptioncurve.net/archives/2013/04/creating-a-paged-photo-gallery-with-a-uicollectionview/

Major changes:
- Made generic. Can be easily adapted for use in another project.
- Images are now loaded from a given path (directory or single image) and then stored in memory.
- Split some pieces of code into reusable functions.

TODO:
- FIX: Bug where images become misaligned when rotating the device.
- CHANGE: Store the images in a cache folder and then load them as needed. This is more efficient as it will save memory.
- CHANGE: Provide an “empty state” message when there are no images to display.
- FEATURE: Add a navigation toolbar with a share button which will allow the user to share the current image (work already begun).
