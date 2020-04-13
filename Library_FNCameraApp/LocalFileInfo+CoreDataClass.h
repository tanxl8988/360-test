//
//  LocalFileInfo+CoreDataClass.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalFileInfo : NSManagedObject

@property (nonatomic,strong) NSString *url;

+ (long)getFileCountWithType:(int16_t)type context:(NSManagedObjectContext *)context;
+ (LocalFileInfo *)getFirstLocalFileInfoWithType:(NSString *)type context:(NSManagedObjectContext *)context;

+ (LocalFileInfo *)createWithName:(NSString *)name type:(NSString *)type url:(NSString *)url size:(NSString *)size context:(NSManagedObjectContext *)context;

+ (LocalFileInfo *)retrieveLocalFileInfoWithName:(NSString *)name type:(NSString *)type context:(NSManagedObjectContext *)context;
+ (NSArray *)retrieveLocalfileInfosWithType:(NSString *)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context;

+ (void)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context completionHandler:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completionHandler;
@end

NS_ASSUME_NONNULL_END

#import "LocalFileInfo+CoreDataProperties.h"
