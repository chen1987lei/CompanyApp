//
//  WKInterfaceImage+WebCache.m
//  Tudou
//
//  Created by Tudou-Wangjun on 3/4/15.
//  Copyright (c) 2015 Youku.com inc. All rights reserved.
//

#import "WKInterfaceImage+WebCache.h"

#import "objc/runtime.h"
#import "WKInterfaceObject+WebCacheOperation.h"

static char imageURLKey;

@implementation WKInterfaceImage (WebCache)
- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImageName:(NSString *)placeholderName {
    [self sd_setImageWithURL:url placeholderImageName:placeholderName options:0 completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setImage:placeholder];
    if (url) {
        __weak WKInterfaceImage *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong WKInterfaceImage *sself = wself;
                if (!sself) return;
                if (image) {
                    [sself setImage:image];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"WKInterfaceImageImage"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImageName:(NSString *)placeholderName options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];
    
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setImageNamed:placeholderName];
    if (url) {
        __weak WKInterfaceImage *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong WKInterfaceImage *sself = wself;
                if (!sself) return;
                if (image) {
                    [sself setImage:image];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"WKInterfaceImageImage"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"WKInterfaceImageImage"];
}
@end
