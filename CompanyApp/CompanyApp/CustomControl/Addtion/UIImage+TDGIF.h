//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TDGIF)
/**
 *  注意名字不能包含扩展名,并且后缀只能为gif 例如aaa.gif ,name只需要写aaa即可
 *
 *  @param name 不包含扩展名
 *
 *  @return 一个动态的UIImage
 */
+(UIImage*)animatedGIFNamed:(NSString*)name;
+(UIImage*)animatedGIFWithData:(NSData *)data;

-(UIImage*)animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
