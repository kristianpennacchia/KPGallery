//
//  KPGalleryViewController.m
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/01/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import "KPGalleryViewController.h"
#import "KPGalleryCell.h"

// The reuse identifer that will be used to associate with KPGalleryCell
#define kCellIdentifier @"cellIdentifier"

@interface KPGalleryViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;    // Will hold string paths to the images
@property (nonatomic) int currentIndex;

@end

@implementation KPGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.

    self.dataArray = [[NSMutableArray alloc] init];

    // TESTING: Load images from directory on startup
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
    [self addImagesFromDirectoryAtPath:path];

    [self setupCollectionView];

    // WIP:
    // Add the share button to the navigation bar
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share)];
    [self.navigationItem setRightBarButtonItem:shareButton animated:YES];
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
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KPGalleryCell *cell = (KPGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                                     forIndexPath:indexPath];
    [cell updateCellWithPathToImage:[self.dataArray objectAtIndex:indexPath.row]];

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

#pragma mark - Toolbar buttons

/* This method is called when the share button in the navigation bar is pressed.
 * It will open the share sheet which will allow you to share the current image
 */
- (void)share
{
    NSArray *activityItems = [[NSArray alloc] initWithObjects:
                              [self.dataArray objectAtIndex:[self calculateCurrentIndex]], nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:activityItems applicationActivities:nil];

    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Adding images to the array

/* Adds images from the specified directory onto the end of the dataArray
 * returns the amount of images that were added to the dataArray */
- (unsigned long)addImagesFromDirectoryAtPath:(NSString *)path
{
    // Record the current image count in the dataArray so we cna figure out how
    // many images were added
    unsigned long imageCountBefore = [self.dataArray count];

    // This array will hold the names of the files in the directory
    NSArray *filenamesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];

    // Enumerate through the filename array and create an image from each filename
    for (NSString *filename in filenamesArray) {
        [self addImageAtPath:[path stringByAppendingPathComponent:filename]];
    }

    // Return amount of images added
    return [self.dataArray count] - imageCountBefore;
}


/* Adds the specified image path onto the end of the dataArray */
- (BOOL)addImageAtPath:(NSString *)path
{
    // First check if string path exists in dataArray already
    if ([[self dataArray] containsObject:path]) {
        // Is already in array, no need to continue.
        return true;
    }

    if (![self validateImage:path]) {
        return false;
    }

    // Image is valid, add the string path to the dataArray
    [self.dataArray addObject:path];

    return true;
}

- (BOOL)validateImage:(NSString *)path
{
    // Verify the path
    if (![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        // Not valid
        return false;
    }

    // Check if image is valid (is there a better way to do this?)
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        // image is not valid
        return false;
    }

    // Image is valid
    return true;
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
