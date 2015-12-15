//
//  TDSearchAlbum.h
//  Tudou
//
//  Created by weiliang on 13-12-13.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#define SERIES_PAGE_SIZE_LIST 3
#define SERIES_PAGE_SIZE_COVER 15

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CateId) {
    Direct_DianShiJu = 1,
    Direct_DianYing = 2,
    Direct_ZongYi = 3,
    
    Direct_DongMan = 5,
    Direct_RenWu = 6,
    
    Direct_JiaoYu = 8,
    Direct_JiLuPian = 9,
    Direct_BangDan = 10,
    Direct_ZuanJi = 11,
    Direct_ZiDingYi = 12,
    Direct_cctv1 = 13,
    Direct_Gucci = 14,
    Direct_JiangXiang = 15,
    Direct_DianYingXiLie = 16,
    Direct_ZiXun = 17,
    Direct_ZiXunZuanJi = 18,
    Direct_DaCi = 19,
    
};

@class SeriesItem;
@interface TDSearchAlbum : NSObject

/**电视剧的主演，电影的导演、主演，综艺的主持人，动漫的声优，纪录片、教育、咨询为空
 * EX:主演：陈道明/何润东/段奕宏
 */


@property(nonatomic, copy)      NSString *albumid;
@property(nonatomic, copy)      NSString            *notice;
@property(nonatomic, copy)      NSString            *title;        //剧集名称

/**电视剧、动漫、纪录片、教育、咨询的集数，电影的正片/预告片标识，综艺的期数
 * EX:80集全
 */
@property(nonatomic, copy)      NSString            *stripe_top;

/**地区
 */
@property(nonatomic, strong)    NSString            *area;

/**标记是否“显示”,0不显示，1显示
 */
@property(nonatomic, assign)      BOOL              hide;

/** 注：4.0之后才开始正式启用
 *  4.0时 代表人物直达区的16：9的横图
 */
@property(nonatomic, strong)    NSString            *img;          //横图
@property(nonatomic, strong)    NSString            *vimg;         //竖图

@property(nonatomic, strong)    NSString            *score;

/**直达区分类
 */
@property(nonatomic, strong)    NSString            *cate_id;
@property(nonatomic, strong)    NSString            *vv;

/**类型
 */
@property(nonatomic, strong)    NSString            *genre;


/**items
 */
@property(nonatomic, strong)NSArray                 *itemsArray;
/**item集合的元素个数
 */
@property(nonatomic, strong)NSNumber                *item_count;


/**是否是土豆视频源， 0不是，1是
 */
@property(nonatomic, assign)BOOL                    is_tudou;

/**是否是倒叙
 */
@property(nonatomic, assign)BOOL                    is_reversed;

/**是否是预告片
 */
@property(nonatomic, assign)BOOL                    is_trailer;

/**V4.3新添字段，给电视剧，电影，动漫返回年份
 */
@property(nonatomic, assign)BOOL                    year;

/**-------------------------------is_tudou=1时有--------------------------
 */
/**剧集id
 */
@property(nonatomic, strong)NSString *album_id;

/**用户在此剧集的播放记录，标识item_id
 * 注：V4.0 友nummber型转为 string
 */
@property(nonatomic, strong)NSString *history;

/**-------------------------------is_tudou=0时有--------------------------
 */
/**站点id
 
 数据源	 参数值
 土豆网	 1
 56网	 2
 新浪网	 3
 搜狐	 6
 凤凰网	 8
 激动网	 9
 酷6	 10
 优酷网	 14
 CNTV	 15
 电影网	 16？
 乐视网	 17
 奇艺网	 19
 QQ	 27
 迅雷看看   28
 PPTV	 31
 pps	 83
 风行	 130
 华数	 131 
 暴风影音	 132 
 -----百度影音 跟快播来源 现在只是显示 “其他”
 百度影音	 1001
 快播	 1002
 
 芒果Tv   24
 */
@property(nonatomic, strong)NSNumber *site_id;

/**站点名称
 */
@property(nonatomic, strong)NSString *site_name;

/**使用内置或系统浏览器
 * 0: 内嵌浏览器播放;1: 外置浏览器播放; 2: app内播放 ; 3: 内嵌浏览器跳转后app内播放 4：百度快播跳转播放
 */
@property(nonatomic, strong)NSString *play_mode;//只有is_tudou=0时有

/**
 * 以下两个属性，跟数据无关，是UI层的
 */
@property(nonatomic,assign) BOOL isShowMore;

@property(nonatomic,assign) BOOL isSubscribed;

/**
 *  在整个直达区的位置
 */
@property(nonatomic,assign) int posIndex;

/**当前选择的剧集段
* 默认是0
*/
 @property(nonatomic,assign) NSInteger currentSelect;

/**当前选集title滑动的距离
 * 默认是0
 */
@property(nonatomic,assign) CGFloat currentOffset;

/**
 *  视频付费类型 0=免费, 1=点播, 10=包月(会员免费), 100=all(会员+点播)
 */
@property (nonatomic,assign) int payType;
@end

/**视频源
 * 格式："sources": {"items": [{"item_id": 130711852,"show_seq": 1,"show_stage": 1,"title": "楚汉传奇-第1集"},、、、、] "is_tudou": 1,
 "item_count": 80,
 "album_id": "85663",
 "history": -1}
 *
 */
@interface SeriesItem : NSObject

@property(nonatomic, strong)NSString *show_seq;//视频序列
@property(nonatomic, strong)NSString *show_stage;//视频集数或期数
@property(nonatomic, strong)NSString *title;

@property(nonatomic, strong)NSString *url;//is_tudou=0时有
@property(nonatomic, strong)NSString *item_id;// 只有is_tudou=1时有

@property(nonatomic, assign)BOOL isTrailer;//是否为预告片

@end



/**-------------------------------for albumPerson--------------------------
 */
@interface TDSearchAlbumForPerson : NSObject

/**
 * 片名
 */

@property (nonatomic, copy)      NSString            *albumid;
@property(nonatomic, copy)      NSString            *name;

/**电视剧、动漫、纪录片、教育、咨询的集数，电影的正片/预告片标识，综艺的期数
 * EX:80集全
 */
@property(nonatomic, copy)      NSString            *stripe_top;
 
/**
 *  4.0时 代表人物直达区的16：9的横图
 */
@property(nonatomic, strong)    NSString            *img;          //横图

/**类型
 */
@property(nonatomic, strong)    NSString            *genre;

@property(nonatomic, strong)    NSString            *score;

@property(nonatomic, strong)    NSString            *year;
 
/**是否是土豆视频源， 0不是，1是
 */
@property(nonatomic, assign)BOOL                    is_tudou;
///**是否是预告片
// */
//@property(nonatomic, assign)BOOL                    is_trailer;
/**-------------------------------is_tudou=1时有--------------------------
 */
/**剧集id
 */
@property(nonatomic, strong)NSString *album_id;

/**-------------------------------is_tudou=0时有--------------------------
 */
/**站点id
 */
@property(nonatomic, strong)NSNumber *site_id;

/**站点名称
 */
@property(nonatomic, strong)NSString *site_name;

/**使用内置或系统浏览器
 * 0: 内嵌浏览器播放;1: 外置浏览器播放; 2: app内播放 ; 3: 内嵌浏览器跳转后app内播放 4：百度快播跳转播放
 */
@property(nonatomic, strong)NSString *play_mode;//只有is_tudou=0时有

/**
 *  视频付费类型 0=免费, 1=点播, 10=包月(会员免费), 100=all(会员+点播)
 */
@property (nonatomic,assign) int payType;

/** 4.0启用
 *  外部视频播放地址
 */
@property(nonatomic, strong)    NSString            *outPlayUrl;

@end