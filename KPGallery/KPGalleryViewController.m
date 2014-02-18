//
//  KPGalleryViewController.m
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/01/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import "KPGalleryViewController.h"
#import "KPGalleryCell.h"
#import "KPImageManager.h"

// The reuse identifer that will be used to associate with KPGalleryCell
#define kCellIdentifier @"cellIdentifier"

@interface KPGalleryViewController ()

@property (nonatomic, strong) KPImageManager *imageManager;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int currentIndex;

@end

@implementation KPGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.

    // Alloc and init the image manager
    self.imageManager = [[KPImageManager alloc] init];

    // Create the empty state
    self.bgView = [[UIView alloc] initWithFrame:[self.view frame]];
    [self.bgView setBackgroundColor:[UIColor blackColor]];

    self.bgLabel = [[UILabel alloc] init];
    [self.bgLabel setText:@"No Images"];
    [self.bgLabel sizeToFit];
    [self.bgLabel setTextColor:[UIColor whiteColor]];

    // Center the bgLabel into the middle of the bgView
    // minus the width and height to get the correct offset (positioning is done
    // by the left most point of the label, so we need to offset the label by using
    // it's width and height to make sure it is centered)
    int labelX = (self.bgView.frame.size.width / 2) - self.bgLabel.frame.size.width / 2;
    int labelY = (self.bgView.frame.size.height / 2) - self.bgLabel.frame.size.height;
    [self.bgLabel setFrame:CGRectMake(labelX,
                                      labelY,
                                      self.bgLabel.frame.size.width,
                                      self.bgLabel.frame.size.height)];

    [self.bgView addSubview:self.bgLabel];
    [self.bgView bringSubviewToFront:self.bgLabel];

    [self.view addSubview:self.bgView];
    [self.view sendSubviewToBack:self.bgView];

    [self.bgView setHidden:NO];

    // TESTING: Load images from directory on startup
    // // If new images don't show up after adding them to the array, you need
    // to reloadData of collectionView or table
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    [self.imageManager addImagesFromDirectoryAtPath:path];
    [self.collectionView reloadData];

    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view delegates, data source and setup

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // This is a full screen gallery which means we will only be
    // displaying 1 image at a time, so return 1
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    long imagesCount = [self.imageManager.dataArray count];

    if (imagesCount < 1) {
        // Display the empty state
        [self.collectionView setHidden:YES];
    }
    else {
        // Display the images (collection view)
        [self.collectionView setHidden:NO];
    }

    return imagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KPGalleryCell *cell = (KPGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                                     forIndexPath:indexPath];
    [cell updateCellWithPathToImage:[self.imageManager.dataArray objectAtIndex:indexPath.row]];

    return cell;
}

/* Make the collection view cell always be the same size as the collection view */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Return the size of the collection view
    return self.collectionView.frame.size;
}

/* Configures the collection view with the necessary settings */
- (void)setupCollectionView
{
    // Tells the collection view that KPGalleryCell is associated with the
    // specified reuse identifier
    [self.collectionView registerClass:[KPGalleryCell class] forCellWithReuseIdentifier:kCellIdentifier];

    // Create the layout to be used in the collection view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    // Set the space between images in the gallery
    CGFloat spaceBetweenImages = 0.0f;
    [flowLayout setMinimumInteritemSpacing:spaceBetweenImages];
    [flowLayout setMinimumLineSpacing:spaceBetweenImages];

    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - Device rotation handling

/* When this method is run, the current index will be calculated for use when
 * the actual rotation occurs
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    // Supress warnings in the debug log. Also forces the view to update
    [[self.collectionView collectionViewLayout] invalidateLayout];

    self.currentIndex = [self calculateCurrentIndex];
    NSLog(@"currentIndex = %d", self.currentIndex);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;

    NSLog(@"currentSize.width = %f", currentSize.width);
    NSLog(@"currentSize.height = %f", currentSize.height);
    NSLog(@"offset = %f", offset);

    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
}

#pragma mark

/* Find the index of the current image being displayed */
- (int)calculateCurrentIndex
{
    CGPoint currentOffset = [self.collectionView contentOffset];
    return currentOffset.x / self.collectionView.frame.size.width;
}

@end
