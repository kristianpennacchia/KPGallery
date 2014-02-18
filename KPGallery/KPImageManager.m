//
//  KPImageManager.m
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/02/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import "KPImageManager.h"

@interface KPImageManager()
@end

@implementation KPImageManager

- (id)init
{
    self = [super init];
    if (self) {
        // Alloc and init the dataArray
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Adding images to the array

/* Adds images from the specified directory onto the end of the dataArray
 * returns the amount of images that were added to the dataArray */
- (unsigned long)addImagesFromDirectoryAtPath:(NSString *)path
{
    // Record the current image count in the dataArray so we can figure out how
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

- (BOOL)saveImageToCache:(UIImage *)image withName:(NSString *)name
{
    // Get the path to the caches directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];

    return [self saveImage:image toPath:cacheDirectory withName:name];
}

- (BOOL)saveImage:(UIImage *)image toPath:(NSString *)path withName:(NSString *)name
{
    // Cast UIImage to NSData so we can write to the file system
    NSData *data = [NSData dataWithData:(NSData *)image];

    // Make the final path name
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@", path, name];

    return [data writeToFile:finalPath atomically:YES];
}

@end
