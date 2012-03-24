//
//  FileUtil.m
//  TrackPost
//
//  Created by Osamu Noguchi on 3/24/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

- (NSData*)getDataFromUrlAndKey:(NSURL *)url key:(NSString*)key {
    NSString *path = [self getPathFromKey:key];
    
    NSData *imageData;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        imageData = [NSData dataWithContentsOfURL:url];
        
        [self createCacheFileFromPath:path data:imageData];
        
        NSLog(@"NSData from URL. URL:%@ ImageSize:%d", [url absoluteString], [imageData length]);
    } else {
        imageData = [NSData dataWithContentsOfFile:path];
        
        NSLog(@"NSData from Cache. URL:%@ ImageSize:%d", [url absoluteURL], [imageData length]);
    }
    
    return imageData;
}

- (NSData*)getDataFromKey:(NSString*)key {
    NSString *path = [self getPathFromKey:key];
    
    NSData *imageData;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        imageData = [NSData dataWithContentsOfFile:path];
        
        NSLog(@"NSData from Cache. Key:%@ ImageSize:%d", key, [imageData length]);
    } else {
        NSLog(@"Cache is not exists. Key:%@", key);
    }
    
    return imageData;
}

- (void)createCacheFileFromUrlAndKey:(NSURL *)url key:(NSString*)key {
    NSString *path = [self getPathFromKey:key];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        [self createCacheFileFromPath:path data:imageData];
        
        NSLog(@"NSData from URL. URL:%@ ImageSize:%d", [url absoluteString], [imageData length]);
    } else {
        NSLog(@"Cache exists. URL:%@", [url absoluteString]);
    }
}

- (void)createCacheFileFromPath:(NSString*)path data:(NSData*)data {
    [data writeToFile:path atomically:YES];
}

- (NSString*)getPathFromKey:(NSString*)key {
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat", key]];
    
    return path;
}

@end
