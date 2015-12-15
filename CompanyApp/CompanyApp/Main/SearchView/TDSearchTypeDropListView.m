//
//  TDSearchTypeDropListView.m
//  Tudou
//
//  Created by weiliangMac on 14-7-7.
//  Copyright (c) 2014年 Youku.com inc. All rights reserved.
//

#import "TDSearchTypeDropListView.h"
#import "TDSearchViewController.h"
@interface TDSearchTypeDropListView()
{
    UIButton*           imageVideoView;
    UIButton*           videoButton;
    
    UIButton*        imageChannelView;
    UIButton*           channelButton;
}
@end
@implementation TDSearchTypeDropListView

#define kSearchTypeDropBoxViewSize CGSizeMake(131, 109)
#define kSearchTypeDropBoxSanJiaoHeight 12
#define kSearchTypeDropBoxLeftMargin    21
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UIView* searchTypeDropBoxListView = [[UIView alloc] initWithFrame:CGRectMake(5,
                                                                                     TitleBar_Height - kSearchTypeDropBoxSanJiaoHeight,
                                                                                     kSearchTypeDropBoxViewSize.width,
                                                                                     kSearchTypeDropBoxViewSize.height)];
        searchTypeDropBoxListView.backgroundColor = [UIColor clearColor];
        searchTypeDropBoxListView.userInteractionEnabled = YES;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:searchTypeDropBoxListView.bounds];
        imageView.image = Image(@"searchdropbox_tanchukuang");
        imageView.userInteractionEnabled = YES;
        [searchTypeDropBoxListView addSubview:imageView];
        //视频
        videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [videoButton setTitle:@"视频" forState:UIControlStateNormal];
        videoButton.tag = SearchType_VIDEO;
        [videoButton setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
        [videoButton addTarget:self action:@selector(searchTypeDropBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        videoButton.frame = CGRectMake(0,
                                       kSearchTypeDropBoxSanJiaoHeight,
                                       kSearchTypeDropBoxViewSize.width,
                                       (kSearchTypeDropBoxViewSize.height - kSearchTypeDropBoxSanJiaoHeight)/2);
        videoButton.backgroundColor = [UIColor clearColor];
        videoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIImage* imageVideoIco = Image(@"searchdropbox_video_selected");
        imageVideoView = [UIButton buttonWithType:UIButtonTypeCustom];
        imageVideoView.frame = CGRectMake(kSearchTypeDropBoxLeftMargin,
                                          (videoButton.height - imageVideoIco.size.height)/2,
                                          imageVideoIco.size.width,
                                          imageVideoIco.size.height);
        imageVideoView.userInteractionEnabled = NO;
        [imageVideoView setImage:imageVideoIco forState:UIControlStateNormal];
        imageVideoView.frame = CGRectMake(kSearchTypeDropBoxLeftMargin,
                                          (videoButton.height - imageVideoIco.size.height)/2,
                                          imageVideoIco.size.width,
                                          imageVideoIco.size.height);
        imageVideoView.backgroundColor = [UIColor clearColor];
        [videoButton addSubview:imageVideoView];
        videoButton.titleEdgeInsets = UIEdgeInsetsMake(0,kSearchTypeDropBoxLeftMargin + imageVideoIco.size.width + 15, 0, 0);
        
        //自频道
        channelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [channelButton setTitle:@"自频道" forState:UIControlStateNormal];
        [channelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        channelButton.tag = SearchType_CHANNEL;
        
        [channelButton addTarget:self action:@selector(searchTypeDropBoxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        channelButton.frame = CGRectMake(0,
                                         (kSearchTypeDropBoxViewSize.height - kSearchTypeDropBoxSanJiaoHeight)/2 + 8,
                                         kSearchTypeDropBoxViewSize.width,
                                         (kSearchTypeDropBoxViewSize.height - kSearchTypeDropBoxSanJiaoHeight)/2);
        channelButton.backgroundColor = [UIColor clearColor];
        channelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        UIImage* imageChannelIco = Image(@"searchdropbox_channel");
        imageChannelView = [UIButton buttonWithType:UIButtonTypeCustom];
        imageChannelView.frame = CGRectMake(kSearchTypeDropBoxLeftMargin,
                                          (videoButton.height - imageChannelIco.size.height)/2,
                                          imageChannelIco.size.width,
                                          imageChannelIco.size.height);
        [imageChannelView setImage:imageChannelIco forState:UIControlStateNormal];
        imageChannelView.backgroundColor = [UIColor clearColor];
        imageChannelView.userInteractionEnabled = NO;
        [channelButton addSubview:imageChannelView];
        channelButton.titleEdgeInsets = UIEdgeInsetsMake(0,kSearchTypeDropBoxLeftMargin + imageChannelIco.size.width + 15, 0, 0);

        [searchTypeDropBoxListView addSubview:videoButton];
        [searchTypeDropBoxListView addSubview:channelButton];
        [self addSubview:searchTypeDropBoxListView];
        
        UIPanGestureRecognizer * swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent)];
        swipeRecognizer.delegate = (id)self;
        [self addGestureRecognizer:swipeRecognizer];
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent)];
        tapRecognizer.delegate = (id)self;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}
//用来判断区分事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        //为ios5的设备添加
        return NO;
    }
    return YES;
}

- (void)tapGestureRecognizerEvent
{
    if (self.delegateType && [self.delegateType respondsToSelector:@selector(tapGestureRecognizerEvent)]) {
        [self.delegateType tapGestureRecognizerEvent];
    }
}
- (void)searchTypeDropBoxButtonClick:(UIButton*)button
{
    [self setSelectSearchTypeDropButton:button.tag];
    if (self.delegateType && [self.delegateType respondsToSelector:@selector(searchTypeDropBoxButtonClick:)]) {
        [self.delegateType searchTypeDropBoxButtonClick:button.tag];
    }
}

- (void)setSelectSearchTypeDropButton:(SearchType)type
{
    if (type == SearchType_VIDEO) {
        [videoButton setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
        [imageVideoView setImage:Image(@"searchdropbox_video_selected") forState:UIControlStateNormal];
        
        [channelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageChannelView setImage:Image(@"searchdropbox_channel") forState:UIControlStateNormal];
    }
    if (type == SearchType_CHANNEL) {
        [videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageVideoView setImage:Image(@"searchdropbox_video") forState:UIControlStateNormal];
        
        [channelButton setTitleColor:[UIColor TDOrange] forState:UIControlStateNormal];
        [imageChannelView setImage:Image(@"searchdropbox_channel_selected") forState:UIControlStateNormal];
    }
}
@end
