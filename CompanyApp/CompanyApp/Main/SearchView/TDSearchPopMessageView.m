//
//  TDSearchPopMessageView.m
//  Tudou
//
//  Created by lihang on 14/12/2.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDSearchPopMessageView.h"
#import "NCTabBar.h"
#import "Universal.h"
#import "TTTAttributedLabel.h"
#define kCellTextColor RGBS(60)
#define kCellBGColor RGBA(255, 255, 255, 95)
#define kCellborderLineColor RGBS(217)

#define kCellTextFontSize 13.0f

#define kCellHeight 37.5f
#define kCellMarginLeftForTitle 5.f
#define kCellMarginLeftForLogo 10.f
#define kCellMarginTopForLogo 9.f
#define kCellLogoWidth 18.f
#define kCellLogoHeight 18.f
#define kCellMarginLeftRightForCloseButton 9.0

#define kCloseButtonImage Image(@"mine_prompt_close")
#define TitleBar_Height 40
@interface TDSearchPopMessageView()
{
    CGFloat defaultHeight;
    CGFloat defaultOriginY;
    UIView *topView;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation TDSearchPopMessageView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withDelegate:nil];
}
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kCellBGColor;
        _delegate = delegate;
        defaultHeight = kCellHeight;
        defaultOriginY = frame.origin.y;
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = kCellHeight;
        _tableview.scrollEnabled = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview setEditing:NO];
        
        _tableview.tableFooterView = nil;
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kCloseButtonImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(self.frame.origin.x, TitleBar_Height, self.frame.size.width, defaultHeight);   //没有打开时，应该在屏幕外，也就是y = 0再减去cell的高度
        
        self.alpha = 0.f;
    }
    return self;
}

- (void)reloadData {
    [self.tableview reloadData];
}
- (void)refreshUI
{
    [self reloadData];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithCapacity:0];
    }
    return _datasource;
}


- (void)layoutSubviews
{
    self.tableview.frame = CGRectMake(0, 0, self.frame.size.width - 2 * kCellMarginLeftRightForCloseButton - kCloseButtonImage.size.width, defaultHeight - 1);
    self.closeButton.frame = CGRectMake(self.frame.size.width - kCellMarginLeftRightForCloseButton - kCloseButtonImage.size.width,
                                        0,
                                        kCloseButtonImage.size.width,
                                        kCellHeight);
    if (self.datasource.count == 0) {
        self.hidden = YES;
        [self hiddenList];
    }
    else {
        self.hidden = NO;
    }
    
}

- (void)showList
{
    if (!_dropListIsOpen) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.95f;
        } completion:^(BOOL finished) {
            _dropListIsOpen = YES;
        }];
    }
    
}

- (void)hiddenList
{
    if (_dropListIsOpen) {
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            _dropListIsOpen = NO;
        }];
    }
    
}
- (void)hiddenView
{
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        _dropListIsOpen = NO;
        [self removeFromSuperview];
    }];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kCellHeight - 1);
    CGContextAddLineToPoint(context, self.width, kCellHeight);
    CGContextSetStrokeColorWithColor(context, kCellborderLineColor.CGColor);
    CGContextSetShadow(context, CGSizeMake(0, 0.5), 0.5);
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
    
    if (![[self subviews] containsObject:self.closeButton]) {
        [self addSubview:self.closeButton];
    }
    if (![[self subviews] containsObject:self.tableview]) {
        [self addSubview:self.tableview];
    }
    
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (_dropListIsOpen) {
//        [self hiddenList];
//    }else{
//        [self showList];
//    }
//}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBackgroundView.image = [UIImage imageWithTudouSelectedBackgroundImage];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        TTTAttributedLabel *labelTitle = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(kCellMarginLeftForLogo+kCellMarginLeftForTitle-3, 0, self.tableview.width-kCellMarginLeftForTitle, kCellHeight - 1)];
        labelTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.lineBreakMode = UILineBreakModeTailTruncation;
        labelTitle.textColor = kCellTextColor;
        labelTitle.font = [UIFont systemFontOfSize:kCellTextFontSize];
        labelTitle.numberOfLines = 2;
        labelTitle.tag = 3;
        labelTitle.delegate = self;
        labelTitle.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES],
                                      (NSString*)kCTForegroundColorAttributeName : (id)[[UIColor TDOrange] CGColor]};
        labelTitle.highlighted = NO;
        [cell.contentView addSubview:labelTitle];
    }
    
    CorrectionData *object = (CorrectionData *)self.datasource[indexPath.row];
    NSString *str = nil;
//    if (object.corr_type == 0) {
//        str = [NSString stringWithFormat:@"你是不是要找：“%@”",object.corrWord];
//    }else if(object.corr_type ==1){
//        str = [NSString stringWithFormat:@"智能匹配“%@”的结果。仍然搜索：“%@”",object.corrWord,object.keyWord];
//    }
    TTTAttributedLabel *labelTitle = (TTTAttributedLabel *)[cell.contentView viewWithTag:3];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
//        labelTitle.attributedText = str==nil?nil:[self addAttributes:str data:object];
        [labelTitle setText:str];
//        NSRange range = NSMakeRange(0, 0);
//        if (object.corr_type==0) {
//            range = NSMakeRange(8, object.corrWord.length);
//        }else if(object.corr_type==1){
//            range = NSMakeRange(16+object.corrWord.length, object.keyWord.length);
//        }
//        [labelTitle addLinkToURL:[NSURL URLWithString:@"http://www.baidu.com"] withRange:range];
    }else{
        labelTitle.text = str;
    }
    
    return cell;
}

- (NSAttributedString*)addAttributes:(NSString*)text data:(CorrectionData*)object
{
    NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:text];
//    if (object.corr_type==0) {
//        [astr addAttribute:NSForegroundColorAttributeName
//                     value:[UIColor TDOrange]
//                     range:NSMakeRange(8, object.corrWord.length)];
//        [astr addAttribute:NSUnderlineStyleAttributeName
//                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
//                     range:NSMakeRange(8, object.corrWord.length)];
//    }else if(object.corr_type==1){
//        [astr addAttribute:NSForegroundColorAttributeName
//                     value:[UIColor TDOrange]
//                     range:NSMakeRange(16+object.corrWord.length, object.keyWord.length)];
//        [astr addAttribute:NSUnderlineStyleAttributeName
//                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
//                     range:NSMakeRange(16+object.corrWord.length, object.keyWord.length)];
//    }
    return astr;
}

- (void)addClickAction:(UILabel*)lab
{
    [lab removeAllSubviews];

}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    CorrectionData *data = self.datasource[0];
    if (_delegate && [_delegate respondsToSelector:@selector(searchPopViewDidSelectMessage:)]) {
        [_delegate searchPopViewDidSelectMessage:data];
    }
}

#pragma mark -UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CorrectionData *data = self.datasource[indexPath.row];
//    if (_delegate && [_delegate respondsToSelector:@selector(searchPopViewDidSelectMessage:)]) {
//        [_delegate searchPopViewDidSelectMessage:data];
//    }
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    [self hiddenList];
//}


@end
