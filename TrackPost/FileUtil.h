//
//  FileUtil.h
//  TrackPost
//
//  Created by Osamu Noguchi on 3/24/12.
//  Copyright (c) 2012 atrac613.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

- (NSData*)getDataFromUrlAndKey:(NSURL *)url key:(NSString*)key;
- (NSData*)getDataFromKey:(NSString*)key;
- (void)createCacheFileFromUrlAndKey:(NSURL *)url key:(NSString*)key;
- (void)createCacheFileFromPath:(NSString*)path data:(NSData*)data;
- (NSString*)getPathFromKey:(NSString*)key;

@end
