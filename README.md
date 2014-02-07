KPGallery
=========

A gallery for iOS that is made to be easily added to other projects

KPGallery is heavily modified and based on the "Creating a Paged Photo Gallery With a UICollectionView" tutorial by Tim Duckett at http://adoptioncurve.net/archives/2013/04/creating-a-paged-photo-gallery-with-a-uicollectionview/

Major changes:
- Made generic. Can be easily adapted for use in another project.
- Images are now loaded from a given path (directory or single image) instead of a fixed one, and then they are only loaded into memory when being displayed.
- Split some pieces of code into reusable functions.

TODO:
- FIX: Bug where images become misaligned when rotating the device.
