//
//  TDRightImageLabel.m
//  Tudou
//
//  Created by yujinliang on 13-4-15.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDRightImageLabel.h"

@interface TDRightImageLabel ()

@property (nonatomic, strong) UIImageView* rightImageView;

@property (nonatomic, assign) CGFloat leftTitlelabelSizeFitText;

@end

@implementation TDRightImageLabel

@synthesize rightImageView = _rightImageView;
@synthesize leftTitleLabel = _leftTitleLabel;
@synthesize rightImageSize = _rightImageSize;
@synthesize paddingWidth = _paddingWidth;
@synthesize onImage = _onImage;
@synthesize offImage = _offImage;
@synthesize title = _title;
@synthesize on = _on;
@synthesize enableShowImage = _enableShowImage;
@synthesize leftTitlelabelSizeFitText = _leftTitlelabelSizeFitText;


+ (id) rightImageLabel:(CGRect)frame onImage:(UIImage*)on offImage:(UIImage*)off title:(NSString*)title {
    
    TDRightImageLabel* trLabel = [[TDRightImageLabel alloc] initWithFrame:frame];
    trLabel.onImage = on;
    trLabel.offImage = off;
    trLabel.title = title;
    
    return trLabel;
}
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _on = YES;
        _leftTitlelabelSizeFitText = 0;
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightImageView.backgroundColor = [UIColor clearColor];
        self.enableShowImage = NO;
        [self addSubview:self.rightImageView];
        
        self.leftTitleLabel = [[UILabel alloc] initWithFrame:frame];
        self.leftTitleLabel.backgroundColor = [UIColor clearColor];
        self.leftTitleLabel.textAlignment = UITextAlignmentCenter;
        self.leftTitleLabel.font = [UIFont systemFontOfSize:18];
        self.leftTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.leftTitleLabel];
    }
    return self;
}
- (void) layoutSubviews {
    
    [super layoutSubviews];
    [self refreshRect];
}
- (void)refreshRect{
    //---
    if (self.enableShowImage == YES) {
        
        [self.leftTitleLabel setFrame:CGRectMake(((self.bounds.size.width - self.leftTitlelabelSizeFitText) / 2), 0, self.leftTitlelabelSizeFitText, self.bounds.size.height)];
        [self.rightImageView setFrame:CGRectMake((self.leftTitleLabel.frame.origin.x + self.leftTitleLabel.frame.size.width + self.rightImageSize.width + self.paddingWidth), ((self.bounds.size.height - self.rightImageSize.height) / 2), self.rightImageSize.width, self.rightImageSize.height)];
        
    }
    else {
        
        //self.leftTitleLabel.backgroundColor = [UIColor redColor];
        [self.leftTitleLabel setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
}
- (void) setTitle:(NSString *)title {
    
    _title = title;
    //--
    self.leftTitleLabel.text = _title;
    [self.leftTitleLabel sizeToFit];
    self.leftTitlelabelSizeFitText = self.leftTitleLabel.bounds.size.width;
    
    [self layoutSubviews];
}
- (void) setOn:(BOOL)onBool {
    
    if (_on != onBool) {
        _on = onBool;
        [self.rightImageView setImage:(_on ? self.onImage : self.offImage)];
    }
}
- (BOOL)toggle {
    self.on = !self.on;
    return self.on;
}
- (void) setEnableShowImage:(BOOL)enableShowImage {
    
    _enableShowImage = enableShowImage;
    [self.rightImageView setHidden:!enableShowImage];
    //--
    [self layoutIfNeeded];
}
- (void) setRightImageSize:(CGSize)rightImageSize {
    
    _rightImageSize = rightImageSize;
    //--
    [self layoutIfNeeded];
}
- (void) setPaddingWidth:(CGFloat)paddingWidth {
    
    _paddingWidth = paddingWidth;
    //--
    [self layoutIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
