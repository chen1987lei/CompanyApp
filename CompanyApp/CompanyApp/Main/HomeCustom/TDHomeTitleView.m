//
//  TDHomeTitleView.m
//  Tudou
//
//  Created by CL7RNEC on 15/5/8.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import "TDHomeTitleView.h"
#import "TDHomeTitleModel.h"

static NSInteger kMaxItemCount = 5;

@interface TDHomeTitleView()

@property (nonatomic,strong) UIView *searchBar;
@property (nonatomic,strong) UIImageView *imgIcon;
@property (nonatomic,strong) UILabel *labText;
@property (nonatomic,strong) UIImageView *logoIcon;
@property (nonatomic,strong) NSMutableArray *cmsTitleModelArray;

@end

@implementation TDHomeTitleView

-(id)init{
    if (self=[super init]) {
        [self createSearchBar];
    }
    return self;
}

-(void)createSearchBar{
    if (!_searchBar) {
        _searchBar=[[UIView alloc] initWithFrame:CGRectMake(10, 6, self.width-49, 31)];
        [self setLeftLogView:_searchBar];
        _logoIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 24)];
        _logoIcon.image=Image(@"logo");
        [self setLeftLogView:_logoIcon];
        _logoIcon.centerY=142;
        _searchBar.opaque=YES;
        _searchBar.clipsToBounds=YES;
        UIView *view=[[UIView alloc] initWithFrame:_searchBar.bounds];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2;
        view.backgroundColor = RGB(229, 91, 0);
        view.layer.borderColor=RGB(229, 91, 0).CGColor;
        view.layer.borderWidth=1;
        [_searchBar addSubview:view];
        WS(weakSelf)
        _imgIcon=[[UIImageView alloc] init];
        [_searchBar addSubview:_imgIcon];
        [_imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@14);
            make.height.equalTo(@14);
            make.left.equalTo(@10);
            make.centerY.equalTo(weakSelf.searchBar);
        }];
        _imgIcon.image=Image(@"ic_home_search");
        _labText=[[UILabel alloc] init];
        [_searchBar addSubview:_labText];
        [_labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(weakSelf.width-100));
            make.centerY.equalTo(weakSelf.imgIcon);
            make.left.equalTo(weakSelf.imgIcon.mas_right).offset(7);
        }];
        _labText.backgroundColor=[UIColor clearColor];
        _labText.font=[UIFont systemFontOfSize:is_iphone6OrIs_iphone6Plus()?15:14];
        _labText.textColor=RGBS(255);
    }
}

-(void)refreshHomeTitleWithImgIcon:(NSString *)imgIcon withText:(NSString *)text{
    //[_logoIcon td_setImageWithURL:[NSURL URLWithString:imgIcon] placeholderImage:Image(@"logo")];
    _labText.text=text;
}

- (void)setDefaultTitleItems
{
    [self addRightItemWithImage:Image(@"ic_title_history") selectedImage:Image(@"ic_title_history_press")];
    [self addRightItemWithImage:Image(@"ic_title_history") selectedImage:Image(@"ic_title_history_press")];
    [self addRightItemWithImage:Image(@"ic_title_search") selectedImage:Image(@"ic_title_search_press")];
    
//    [self addRightItemWithImage:Image(@"ic_title_app") selectedImage:Image(@"ic_title_app_press")];
    
    [[self getRightItemWithIndex:0] setHidden:NO];
}

- (void)setTitleItemsWithCMS:(NSArray *)titleModelArray
{
    _cmsTitleModelArray = [titleModelArray copy];
    
    for (int i = 0; i < [titleModelArray count]; i++) {
        
        if (i >= kMaxItemCount) {
            break;
        }
        
        TDHomeTitleModel *model = [titleModelArray objectAtSafeIndex:i];
        
//        [self setRightItemImage:[[TDImageCache sharedImageCache] imageFromKey:model.icon]
//                  selectedImage:[[TDImageCache sharedImageCache] imageFromKey:model.selectedIcon]
//                        atIndex:i];
//        [[self getRightItemWithIndex:i] setHidden:YES];
    }
    
    [self setRightItemImage:Image(@"ic_title_history") selectedImage:Image(@"ic_title_history") atIndex:0];
    
    self.isCMSTitle = YES;
}

-(void)transformTitleFirstType{
    [UIView animateWithDuration:0.4 animations:^{
        _logoIcon.centerY=142;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _searchBar.centerY=42-sSTATUS_BAR_MARGIN_TOP;
    } completion:^(BOOL finished) {
        
        //第一种形态最右边的始终显示历史纪录
        [self setRightItemImage:Image(@"ic_title_history") selectedImage:Image(@"ic_title_history_press") atIndex:0];
        
        //其他的隐藏
        for (int i = 1; i < [self.rightItemArray count]; i++) {
            UIButton *button = [self.rightItemArray objectAtIndex:i];
            button.hidden = YES;
        }
        
        self.titleType = TDHomeTitleFirstType;
    }];
}

-(void)transformTitleSectondType{
    [UIView animateWithDuration:0.4 animations:^{
        _searchBar.centerY=-56;
    } completion:^(BOOL finished) {
    }];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _logoIcon.centerY=42-sSTATUS_BAR_MARGIN_TOP;
    } completion:^(BOOL finished) {
        
        //显示全部
        for (int i = 0; i < [self.rightItemArray count]; i++) {
            UIButton *button = [self.rightItemArray objectAtIndex:i];
            button.hidden = NO;
        }
        
        //默认情况的处理，最右边显示分类
        if (!_isCMSTitle) {
            [self setRightItemImage:Image(@"ic_title_sort") selectedImage:Image(@"ic_title_sort_press") atIndex:0];
        }else {
            TDHomeTitleModel *model = [_cmsTitleModelArray objectAtSafeIndex:0];
//            [self setRightItemImage:[[TDImageCache sharedImageCache] imageFromKey:model.icon]
//                      selectedImage:[[TDImageCache sharedImageCache] imageFromKey:model.selectedIcon]
//                            atIndex:0];
        }
        
        self.titleType = TDHomeTitleSecondType;
    }];        
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_titleDelegate&&[_titleDelegate respondsToSelector:@selector(searchBarDidClick)]) {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(_searchBar.frame, point)) {
            [_titleDelegate searchBarDidClick];
        }
    }
}
@end
