//
//  TDCustomCell.m
//  Tudou
//
//  Created by zhang jiangshan on 12-11-30.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "TDCustomCell.h"

@implementation TDCustomCell

+(Class)layerClass
{
    return [TDCellLayer class];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)setDidTapMethod:(SEL)selector
{
    _selector = selector;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float) height
{
    return 44;
}


- (void)refresh
{
    
}
/*
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:_selector])
    {
        [self.delegate performSelector:_selector withObject:self.object];
    }
    else
    {
        [super touchesBegan:touches withEvent:event];
    }
}*/
@end
