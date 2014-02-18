//
//  KPImageManager.h
//  KPGallery
//
//  Created by Kristian Pennacchia on 18/02/2014.
//  Copyright (c) 2014 Kristian Pennacchia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPImageManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;    // Will hold string paths to the images

- (unsigned long)addImagesFromDirectoryAtPath:(NSString *)path;
- (BOOL)addImageAtPath:(NSString *)path;
- (BOOL)validateImage:(NSString *)path;
- (BOOL)saveImageToCache:(UIImage *)image withName:(NSString *)name;
- (BOOL)saveImage:(UIImage *)image toPath:(NSString *)path withName:(NSString *)name;

@end
