//
//  NSManagedObject+Addition.m
//  Tudou
//
//  Created by 李 福庆 on 13-1-8.
//  Copyright (c) 2013年 Youku.com inc. All rights reserved.
//

#import "NSManagedObject+Addition.h"

@implementation NSManagedObject (Addition)
@dynamic traversed;
- (NSDictionary*) toDictionary
{
//    unsigned int count;
//    
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    
//    for (int i = 0; i<count; i++) {
//        objc_property_t property = properties[i];
//        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        id obj = [self valueForKey:name];
//        if (obj) {
//            
//            if (![[obj class] isSubclassOfClass:[NSData class]]) {
//                if ([[obj class] isSubclassOfClass:[NSManagedObject class]]) {
//                    
//                    NSArray *relationships = [[obj entity] relationshipsWithDestinationEntity:[self entity]];
//                    if ([relationships count] > 0) {
//                        NSString *relName = [[relationships objectAtIndex:0] name];
//                        
//                        NSDictionary *namedRelationships = [[obj entity] relationshipsByName];
//                        BOOL isParent = [[[(NSRelationshipDescription *)[namedRelationships objectForKey:relName] destinationEntity] name] isEqualToString:NSStringFromClass([self class])];
//                        if (!isParent)
//                            [dictionary setObject:[(NSManagedObject *)obj dictionaryExport] forKey:name];
//                    }
//                    else {
//                        [dictionary setObject:[(NSManagedObject *)obj dictionaryExport] forKey:name];
//                    }
//                }
//                else if ([[obj class] isSubclassOfClass:[NSSet class]]) {
//                    if ([obj count] > 0) {
//                        NSArray *array = [(NSSet *)obj allObjects];
//                        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[array count]];
//                        for (id o in array)
//                            [mutableArray addObject:[(NSManagedObject *)o dictionaryExport]];
//                        
//                        [dictionary setObject:[NSArray arrayWithArray:mutableArray] forKey:name];
//                    }
//                }
//                else if ([[obj class] isSubclassOfClass:[NSDate class]]) {
//                    [dictionary setObject:[obj description] forKey:name];
//                }
//                else {
//                    [dictionary setObject:obj forKey:name];
//                }
//            }
//        }
//    }
//    free(properties);
//    
//    return dictionary;
    
    NSArray* attributes = [[[self entity] attributesByName] allKeys];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:
                                 [attributes count]];
    
    for (NSString* attr in attributes) {
        NSObject* value = [self valueForKey:attr];
        
        if (value != nil) {
            [dict setObject:value forKey:attr];
        }
    }
    
    
    return dict;
}


- (void) populateFromDictionary:(NSDictionary*)dict
{
    NSManagedObjectContext* context = [self managedObjectContext];
    
    for (NSString* key in dict) {
        if ([key isEqualToString:@"class"]) {
            continue;
        }
        
        NSObject* value = [dict objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            // This is a to-one relationship
            NSManagedObject* relatedObject =
            [NSManagedObject createManagedObjectFromDictionary:(NSDictionary*)value
                                                           inContext:context];
            
            [self setValue:relatedObject forKey:key];
        }
        else if ([value isKindOfClass:[NSSet class]]) {
            // This is a to-many relationship
            NSSet* relatedObjectDictionaries = (NSSet*) value;
            
            // Get a proxy set that represents the relationship, and add related objects to it.
            // (Note: this is provided by Core Data)
            NSMutableSet* relatedObjects = [self mutableSetValueForKey:key];
            
            for (NSDictionary* relatedObjectDict in relatedObjectDictionaries) {
                NSManagedObject* relatedObject =
                [NSManagedObject createManagedObjectFromDictionary:relatedObjectDict
                                                               inContext:context];
                [relatedObjects addObject:relatedObject];
            }
        }
        else if (value != nil) {
            // This is an attribute
            [self setValue:value forKey:key];
        }
    }
}

+ (NSManagedObject *) createManagedObjectFromDictionary:(NSDictionary*)dict
                                                   inContext:(NSManagedObjectContext*)context
{
    NSString* class = [dict objectForKey:@"class"];
    NSManagedObject * newObject =
    (NSManagedObject *)[NSEntityDescription insertNewObjectForEntityForName:class
                                                          inManagedObjectContext:context];
    
    [newObject populateFromDictionary:dict];
    
    return newObject;
}


@end

@implementation NSManagedObject (RXCopying)

// copying
-(id)deepCopyWithZone:(NSZone *)zone {
	NSMutableDictionary *ownedIDs = [[self ownedIDs] mutableCopy];
	NSManagedObjectContext *context = [self managedObjectContext];
	id copied = [self copyWithZone: zone]; // -copyWithZone: copies the attributes for us
    
	for(NSManagedObjectID *key in [ownedIDs allKeys]) { // deep copy relationships
		id copiedObject = [[context objectWithID: key] copyWithZone: zone];
		[ownedIDs setObject: copiedObject forKey: key];
        //		[copiedObject release];
	}
    
	[copied setRelationshipsToObjectsByIDs: ownedIDs];
	for(NSManagedObjectID *key in [ownedIDs allKeys]) {
		[[ownedIDs objectForKey: key] setRelationshipsToObjectsByIDs: ownedIDs];
	}
	return copied;
}

-(id)copyWithZone:(NSZone *)zone { // shallow copy
	NSManagedObjectContext *context = [self managedObjectContext];
	id copied = [[[self class] allocWithZone: zone] initWithEntity: [self entity] insertIntoManagedObjectContext: context];
    
	for(NSString *key in [[[self entity] attributesByName] allKeys]) {
		[copied setValue: [self valueForKey: key] forKey: key];
	}
    
	for(NSString *key in [[[self entity] relationshipsByName] allKeys]) {
		[copied setValue: [self valueForKey: key] forKey: key];
	}
	return copied;
}

-(void)setRelationshipsToObjectsByIDs:(id)objects {
	id newReference = nil;
	NSDictionary *relationships = [[self entity] relationshipsByName];
	for(NSString *key in [relationships allKeys]) {
		if([[relationships objectForKey: key] isToMany]) {
			id references = [NSMutableSet set];
			for(id reference in [self valueForKey: key]) {
				if((newReference = [objects objectForKey: [reference objectID]])) {
					[references addObject: newReference];
				} else {
					[references addObject: reference];
				}
			}
			[self setValue: references forKey: key];
		} else {
			if((newReference = [objects objectForKey: [[self valueForKey: key] objectID]])) {
				[self setValue: newReference forKey: key];
			}
		}
	}
}

-(NSDictionary *)ownedIDs {
	NSDictionary *relationships = [[self entity] relationshipsByName];
	NSMutableDictionary *ownedIDs = [NSMutableDictionary dictionary];
	for(NSString *key in [relationships allKeys]) {
		id relationship = [relationships objectForKey: key];
		if([relationship deleteRule] == NSCascadeDeleteRule) { // ownership
			if([relationship isToMany]) {
				for(id child in [self valueForKey: key]) {
					[ownedIDs setObject: child forKey: [child objectID]];
					[ownedIDs addEntriesFromDictionary: [child ownedIDs]];
				}
			} else {
				id reference = [self valueForKey: key];
				[ownedIDs setObject: reference forKey: [reference objectID]];
			}
		}
	}
	return ownedIDs;
}

@end