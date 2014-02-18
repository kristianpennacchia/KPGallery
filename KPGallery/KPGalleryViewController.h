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

@property (strong, nonatomic) UIView *bgView;   // Used for the empty state
@property (strong, nonatomic) UILabel *bgLabel; // Will hold the message to display for the empty state

- (int)calculateCurrentIndex;

@end
