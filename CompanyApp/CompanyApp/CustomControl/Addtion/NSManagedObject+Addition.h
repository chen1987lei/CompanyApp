//
//  NSManagedObject+Addition.h
//  Tudou
//
//  Created by 李 福庆 on 13-1-8.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Addition)
@property (nonatomic, assign) BOOL traversed;

- (NSDictionary*) toDictionary;
- (void) populateFromDictionary:(NSDictionary*)dict;
+ (NSManagedObject *) createManagedObjectFromDictionary:(NSDictionary*)dict
                                                   inContext:(NSManagedObjectContext*)context;
@end
@interface NSManagedObject (RXCopying) <NSCopying>

-(void)setRelationshipsToObjectsByIDs:(id)objects;

-(id)deepCopyWithZone:(NSZone *)zone;
-(NSDictionary *)ownedIDs;

@end
