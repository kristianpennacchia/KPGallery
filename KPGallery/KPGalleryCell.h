//
//  KPGalleryCell.h
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/01/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPGalleryCell : UICollectionViewCell

@property (nonatomic, strong) NSString *imageName;

- (void)updateCellWithImage:(UIImage *)image;

@end
