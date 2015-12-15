//
//  NSString+Color.m
//  Tudou
//
//  Created by Lambertgan on 14-11-7.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "NSString+Color.h"

@implementation NSString (Color)

-(UIColor *)dmColor{
    
        NSString *str = [NSString stringWithFormat:@"%lx",(long)[self integerValue]];
        
        
        while (str.length < 8) {
            str = [@"0" stringByAppendingString:str];
        }
        
        NSString *red_16 = [str substringWithRange:NSMakeRange(2, 2)];
        
        
        NSString * red = [NSString stringWithFormat:@"%lu",strtoul([red_16 UTF8String],0,16)];
        
        NSString *green_16 = [str substringWithRange:NSMakeRange(4, 2)];
        
        
        NSString * green = [NSString stringWithFormat:@"%lu",strtoul([green_16 UTF8String],0,16)];
        
        NSString *blue_16 = [str substringWithRange:NSMakeRange(6, 2)];
        
        
        NSString * blue = [NSString stringWithFormat:@"%lu",strtoul([blue_16 UTF8String],0,16)];
        
        
        return  RGB([red integerValue], [green integerValue], [blue integerValue]);
    

}

@end
