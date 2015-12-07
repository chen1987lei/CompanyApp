//
//  UIImage+Addition.h
//  Tudou
//
//  Created by zhang jiangshan on 12-11-19.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Addtion)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizeImageWithNewSize:(CGSize)newSize;
- (UIImage *)getImageWithMaskColor:(UIColor *)color;
- (UIImage *)getGrayImage;
//包含iOS 5- – stretchableImageWithLeftCapWidth:topCapHeight:, ios5+ – resizableImageWithCapInsets:
- (UIImage *)resizableImageWithCap2x2;
- (UIImage *)resizableImageWithCapLeft:(float)left Top:(float)top;
+ (UIImage *)createImageWithColor:(UIColor *)color;
@end

@interface UIImage (Tudou)
//土豆 背景图
+ (UIImage *)imageFromMediaURL:(NSURL *)url;
+ (UIImage *)imageWithTudouBackgroundImage;//白色背景 有阴影
+ (UIImage *)imageWithTudouSelectedBackgroundImage;//选择背景
+ (UIImage *)imageWithTudouVeritcal;//默认竖图
+ (UIImage *)imageWithTudouBigVeritcal;  //默认大竖图
+ (UIImage *)imageWithTudouHorizontal;//默认横图
+ (UIImage *)imageWithTudouTopBack;//titlebar 返回按钮
+ (UIImage *)imageWithTudouTopBackBlack;
+ (UIImage *)imageWithTudouTopBackHighLight;//titlebar 返回按钮 高亮
+ (UIImage *)imageWithTudouYaoFeng; //返回土豆腰封图片
+ (UIImage *)imageWithTudouDefaultHorizontal;
+ (UIImage *)imageWithShareDefaultImage;//分享默认缩略图
@end

@interface UIImage (FX)

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToFitSize:(CGSize)size;
- (UIImage *)imageScaledToFillSize:(CGSize)size;
- (UIImage *)imageCroppedAndScaledToSize:(CGSize)size
                             contentMode:(UIViewContentMode)contentMode
                                padToFit:(BOOL)padToFit;

- (UIImage *)reflectedImageWithScale:(CGFloat)scale;
- (UIImage *)imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
- (UIImage *)imageWithMask:(UIImage *)maskImage;

- (UIImage *)maskImageFromImageAlpha;


- (UIImage*) imageWith3x3GaussianBlur;
- (UIImage*) imageWith5x5GaussianBlur;

@end

@interface UIImage (ImageEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end