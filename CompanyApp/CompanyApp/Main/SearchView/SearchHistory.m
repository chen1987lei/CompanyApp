//
//  SearchHistory.m
//  Tudou
//
//  Created by zhang jiangshan on 12-12-6.
//  Copyright (c) 2012年 Youku.com inc. All rights reserved.
//

#import "SearchHistory.h"

NSString *const SearchHistoryDidChangeNotification = @"SearchHistoryDidChangeNotification";


@implementation SearchHistory
@dynamic title, typeSearch;
- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

/*
+ (void)getSearchHistory:(void (^)(NSArray *array, BOOL success))success
{
    NSArray * result =[[CoreDataAccess sharedInstance] getRecordsFromTable:@"SearchHistory" withFaulting:NO];
    if(result.count > [self numLimit])
    {
        __block int more = (int)result.count - [self numLimit];
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:[self numLimit]];
        [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if(idx < more)
             {
                 [[CoreDataAccess sharedInstance] deleteRecord:obj];
             }
             else
                 [temp addObject:obj];
         }];
        success([NSArray arrayWithArray:temp], YES);
    }
    else {
        success([result reverse], YES);
    }
}

+ (NSArray *)getRecords
{
    NSArray * result =[[CoreDataAccess sharedInstance] getRecordsFromTable:@"SearchHistory" withFaulting:NO];
    if(result.count > [self numLimit])
    {
        __block int more = (int)result.count - [self numLimit];
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:[self numLimit]];
        [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            if(idx < more)
            {
                [[CoreDataAccess sharedInstance] deleteRecord:obj];
            }
            else
                [temp addObject:obj];
        }];
        return [NSArray arrayWithArray:temp];
    }
    else
        return [result reverse];
}

+ (void)addHistory:(NSString *)text type:(NSInteger)typeSearch
{
    if(IsStringWithAnyText(text))
    {
        NSArray * records = nil;
        if([self isSaved:text typeSearch:typeSearch record:&records])
        {
            for(NSManagedObject * obj in records)
            {
                [[CoreDataAccess sharedInstance] deleteRecord:obj];
            }
        }
        [[CoreDataAccess sharedInstance] addRecordWithCallback:^(NSManagedObject * object) {
            [object performSelector:@selector(setTitle:) withObject:text];
            [(SearchHistory*)object setTitle:text];
            [(SearchHistory*)object setTypeSearch:/*[NSNumber numberWithInt:typeSearch]*/
//            [object performSelector:@selector(setType:) withObject:@(typeSearch)];


+ (int)numLimit
{
    return 30;
}



@end
