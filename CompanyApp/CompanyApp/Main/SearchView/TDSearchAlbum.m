//
//  TDSearchAlbum.m
//  Tudou
//
//  Created by weiliang on 13-12-13.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "TDSearchAlbum.h"

@implementation TDSearchAlbum
@synthesize albumid;

-(void)parseWithDictionary:(NSDictionary *)dict
{
//    [super parseWithDictionary:dict];
  
    self.notice  = dict[@"notice"];
    self.hide = [dict[@"hide"] boolValue];
    self.area = dict[@"area"];
    self.img = dict[@"img"];
    self.vimg = dict[@"vimg"];
    self.title = dict[@"title"];
    
    self.stripe_top = dict[@"stripe_top"];
    self.score = dict[@"score"];
    self.cate_id = dict[@"cate_id"];
    self.vv = dict[@"vv"];
    self.genre = dict[@"genre"];
    if (dict[@"year"]) {
        NSInteger cateID = [self.cate_id intValue];
        if (cateID == Direct_DianShiJu ||
            cateID == Direct_DianYing ||
            cateID == Direct_DongMan ||
            cateID == Direct_DianYingXiLie) {
            //Direct_DianYingXiLie 类比电影
            self.title = [NSString stringWithFormat:@"%@ (%@)",dict[@"title"],dict[@"year"]];
        }
        self.year = dict[@"year"];
    }
    
    NSMutableArray* arraycopy = [NSMutableArray arrayWithCapacity:2];

    if (dict[@"sources"]) {
        self.is_tudou = [dict[@"sources"][@"is_tudou"] boolValue];
        self.item_count = [NSNumber numberWithInt:[dict[@"sources"][@"item_count"] intValue]];
        
        if (self.is_tudou) {
            self.albumid = dict[@"sources"][@"aid"];//给tdbasevideo
            self.album_id = dict[@"sources"][@"aid"];
            self.history = dict[@"sources"][@"history"];
            
            if ([[dict[@"sources"] allKeys] containsObject:@"pay_type"]) {
                int ptype = [dict[@"sources"][@"pay_type"] intValue];
                if (ptype>=0) {
                    self.payType = ptype;
                }else{
                    self.payType = 0;
                }
            }else{
                self.payType = 0;
            }

        }
        else
        {
            self.site_id = [NSNumber numberWithInt:[dict[@"sources"][@"site_id"] intValue]];
            self.site_name = dict[@"sources"][@"site_name"];
            self.payType = 0;
        }
        self.play_mode = dict[@"sources"][@"play_mode"];
        self.is_trailer = [dict[@"sources"][@"is_trailer"] boolValue];
        self.is_reversed = [dict[@"sources"][@"reversed"] boolValue];
        
        NSArray* array = [NSArray arrayWithArray:[dict[@"sources"] objectForKey:@"items"]];
        
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *itemDic = [array objectAtIndex:i];
            SeriesItem *item = [self parseSeriesItem:itemDic];
            item.isTrailer = NO;
            [arraycopy addObject:item];
        }
    }
    
    //解析预告片
    if (dict[@"trailers"]) {
        self.album_id = dict[@"sources"][@"aid"];
        NSArray* array = [NSArray arrayWithArray:[dict[@"trailers"] objectForKey:@"items"]];
        for (NSInteger i = [array count]-1; i >= 0; i--) {
            NSDictionary *itemDic = [array objectAtIndex:i];
            SeriesItem *item = [self parseSeriesItem:itemDic];
            item.isTrailer = YES;
            [arraycopy insertObject:item atIndex:0];
        }
    }
    
    if (arraycopy && arraycopy.count > 0) {
        self.itemsArray = [NSArray arrayWithArray:arraycopy];
    }

    self.currentSelect = 0;
    self.currentOffset = 0.0f;
}

- (SeriesItem*)parseSeriesItem:(NSDictionary*)itemDic
{
    SeriesItem* item = [[SeriesItem alloc] init];
    item.show_seq = [itemDic objectForKey:@"show_stage"];
    if ([[itemDic objectForKey:@"show_stage"] isKindOfClass:[NSString class]]) {
        if ([[itemDic objectForKey:@"show_stage"] isNotBlankString]) {
            item.show_stage = [itemDic objectForKey:@"show_stage"];
        }
    }
    else if ([[itemDic objectForKey:@"show_stage"] isKindOfClass:[NSNumber class]]) {
        if ([[itemDic objectForKey:@"show_stage"] integerValue] != 0) {
            item.show_stage = [NSString stringWithFormat:@"%0.lf",[[itemDic objectForKey:@"show_stage"] floatValue]];
        }
    }
    item.title = [itemDic objectForKey:@"title"];
    
    if ([[itemDic allKeys] containsObject:@"iid"]) {
        item.item_id = [itemDic objectForKey:@"iid"];
    }
    
//    if([[itemDic allKeys] containsObject:@"url"]) {
//        item.url = KISDictionaryNullValue(itemDic, @"url");
//    }

    return item;
}

@end

@implementation SeriesItem


@end


@implementation TDSearchAlbumForPerson
-(void)parseWithDictionary:(NSDictionary *)dict
{
//    [super parseWithDictionary:dict];

    self.name  = dict[@"name"];
    self.year = dict[@"year"];
    self.img = dict[@"img"];
    self.stripe_top = dict[@"stripe_top"];
    self.score = dict[@"score"];
    self.genre = dict[@"genre"];
    if (dict[@"source"]) {
        
        self.is_tudou = [dict[@"source"][@"is_tudou"] boolValue];
 
        
        if (self.is_tudou) {
            self.albumid = dict[@"source"][@"aid"];//给tdbasevideo
            self.album_id = dict[@"source"][@"aid"];
        }
        else
        {
            self.site_id = [NSNumber numberWithInt:[dict[@"source"][@"site_id"] intValue]];
            self.site_name = dict[@"source"][@"site_name"];
            self.outPlayUrl = dict[@"source"][@"url"];
        }
        
        self.play_mode = dict[@"source"][@"play_mode"];

        if ([[dict[@"sources"] allKeys] containsObject:@"pay_type"]) {
            int ptype = [dict[@"sources"][@"pay_type"] intValue];
            if (ptype>=0) {
                self.payType = ptype;
            }else{
                self.payType = 0;
            }
        }else{
            self.payType = 0;
        }

    }
}

@end
