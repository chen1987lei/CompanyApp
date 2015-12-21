//
//  TDHomeModel.h
//  Tudou
//  首页数据基类，首页抽屉信息等一般性卡片信息都使用该model
//  Created by CL7RNEC on 15/4/7.
//  Copyright (c) 2015年 Youku.com inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDHomeModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,copy) NSString *publicdate;
@property (nonatomic,copy) NSString *modelId;
@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray *book;
//@property (nonatomic,copy) NSString *imageurl;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *imageUrl;              //图片
@property (nonatomic,copy) NSString *addv;



@property (nonatomic,copy) NSString *cornerImgUrl;
@property (nonatomic,copy) NSString *coverImageUrl;              //图片

@property (nonatomic,copy) NSString *module_cover_image;              //图片
@property (nonatomic,copy) NSString *imageUrlForHorizontal; //横图
@property (nonatomic,copy) NSString *imageUrlForVertical;   //竖图
@property (nonatomic,copy) NSString *parentTitle;           //上一级标题
@property (nonatomic,copy) NSString *imageBottomTitle;
@property (nonatomic,copy) NSString *imageBottomSubTitle;
@property (nonatomic,copy) NSString *iid;
//@property (nonatomic,assign) TDSkipType skipType;
@property (nonatomic,assign) BOOL isBigImage;       //是否有大图
@property (nonatomic,strong) NSMutableDictionary *skipInfo;
@property (nonatomic,copy) NSString *albumId;
@property (nonatomic,copy) NSString *playListId;
@property (nonatomic,copy) NSString *personId;
@property (nonatomic,copy) NSString *personIconUrl;
@property (nonatomic,copy) NSString *personName;
@property (nonatomic,assign) NSInteger index;
@end
