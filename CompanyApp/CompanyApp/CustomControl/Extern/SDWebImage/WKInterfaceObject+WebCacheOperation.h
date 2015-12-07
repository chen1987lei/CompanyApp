//
//  WKInterfaceObject+WebCacheOperation.h
//  SDWebImage
//
//  Created by Tudou-Wangjun on 12/3/14.
//  Copyright (c) 2014 Dailymotion. All rights reserved.
//

#import <WatchKit/WatchKit.h>

#import "SDWebImageManager.h"

@interface WKInterfaceObject (WebCacheOperation)
/**
 *  Set the image load operation (storage in a UIView based dictionary)
 *
 *  @param operation the operation
 *  @param key       key for storing the operation
 */
- (void)sd_setImageLoadOperation:(id)operation forKey:(NSString *)key;

/**
 *  Cancel all operations for the current UIView and key
 *
 *  @param key key for identifying the operations
 */
- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key;

/**
 *  Just remove the operations corresponding to the current UIView and key without cancelling them
 *
 *  @param key key for identifying the operations
 */
- (void)sd_removeImageLoadOperationWithKey:(NSString *)key;
@end
