//
//  KPGalleryViewController.h
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/01/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPGalleryViewController : UIViewController <UICollectionViewDataSource,
                                                        UICollectionViewDelegate,
                                                        UICollectionViewDelegateFlowLayout>

- (unsigned long)addImagesFromDirectoryAtPath:(NSString *)path;
- (BOOL)addImageAtPath:(NSString *)path;
- (BOOL)validateImage:(NSString *)path;
- (int)calculateCurrentIndex;

@end
