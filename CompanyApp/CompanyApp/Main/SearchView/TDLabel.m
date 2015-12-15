//
//  TDLabel.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-10.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDLabel.h"

@implementation TDLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setVerticalAlignment:(VerticalAlignment)value
{
    _verticalAlignment = value;
    [self setNeedsDisplay];
}

// align text block according to vertical alignment settings
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    CGRect result;
    switch (_verticalAlignment)
    {
        case VerticalAlignmentTop:
            result = CGRectMake(bounds.origin.x, bounds.origin.y, rect.size.width, rect.size.height);
            break;
        case VerticalAlignmentMiddle:
            result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height) / 2, rect.size.width, rect.size.height);
            break;
        case VerticalAlignmentBottom:
            result = CGRectMake(bounds.origin.x, bounds.origin.y + (bounds.size.height - rect.size.height), rect.size.width, rect.size.height);
            break;
        default:
            result = bounds;
            break;
    }
    UIEdgeInsets insets = _textEdgeInsets;
    result.origin.x    += insets.left;
    result.origin.y    += insets.top;
    result.size.width  = MIN(bounds.size.width  - (insets.left + insets.right),  result.size.width);
    result.size.height = MIN(bounds.size.height - (insets.top  + insets.bottom), result.size.height);
    
    return result;
}

-(void)drawTextInRect:(CGRect)rect
{
    CGRect r = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:r];
}
- (void)setTextEdgeInsets:(UIEdgeInsets)textEdgeInsets{
    _textEdgeInsets = textEdgeInsets;
    [self setNeedsDisplay];
}
@end
