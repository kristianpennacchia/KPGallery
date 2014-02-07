//
//  KPGalleryCell.m
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/01/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import "KPGalleryCell.h"

@interface KPGalleryCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation KPGalleryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        // Retrieve the contents of the nib file into an array
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"KPGalleryCell"
                                                              owner:self
                                                            options:nil];

        // Check if loading the nib failed or the objects weren't retrieved
        if ([arrayOfViews count] < 1) {
            return nil;
        }

        // Check if the retrieved object is the Cell we created (KPGalleryCell)
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }

        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

/* Loads the image from the given path into a UIImage and passes it on */
- (void)updateCellWithPathToImage:(NSString *)path
{
    [self updateCellWithImage:[UIImage imageWithContentsOfFile:path]];
}

/* Displays the given image */
- (void)updateCellWithImage:(UIImage *)image
{
    [self.imageView setImage:image];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

@end
