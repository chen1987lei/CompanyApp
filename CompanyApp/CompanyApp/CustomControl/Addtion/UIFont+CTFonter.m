//
//  NSObject+UIFont_CTFonter.m
//  Tudou
//
//  Created by zhangjiwang on 13-9-27.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "UIFont+CTFonter.h"
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>

@implementation UIFont (CTFonter)

- (CTFontRef)CTFonter
{
    CTFontRef fonter = CTFontCreateWithName((CFStringRef)self.fontName,
                                            self.pointSize, NULL);
    
    return (__bridge CTFontRef)NSMakeCollectable(fonter);
}

@end
