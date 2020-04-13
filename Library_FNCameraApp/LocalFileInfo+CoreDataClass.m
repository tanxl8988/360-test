//
//  LocalFileInfo+CoreDataClass.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//
//

#import "LocalFileInfo+CoreDataClass.h"

@implementation LocalFileInfo

+ (LocalFileInfo *)createWithName:(NSString *)name type:(NSString *)type url:(NSString *)url size:(NSString *)size context:(NSManagedObjectContext *)context{
    
    LocalFileInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"LocalFileInfo" inManagedObjectContext:context];
    info.name = name;
    info.type = type;
    info.size = size;
    info.url = url;
    return info;
}

+ (long)getFileCountWithType:(int16_t)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.resultType = NSCountResultType;
    
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return 0;
        
    }else{
        
        NSNumber *number = arr.firstObject;
        return [number longValue];
    }
}

+ (LocalFileInfo *)getFirstLocalFileInfoWithType:(NSString *)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",type];
//    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
//    request.sortDescriptors = @[dateSort];
    request.fetchBatchSize = 1;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr.firstObject;
    }
}

+ (LocalFileInfo *)retrieveLocalFileInfoWithName:(NSString *)name type:(NSString *)type context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND type == %@",name,type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchBatchSize = 1;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr.firstObject;
    }
}

+ (NSArray *)retrieveLocalfileInfosWithType:(NSString *)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchOffset = offset;
    request.fetchLimit = count;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
        
    }else{
        
        return arr;
    }
}

+ (void)retrieveLocalfileInfosWithType:(int16_t)type offset:(NSInteger)offset count:(NSInteger)count context:(NSManagedObjectContext *)context completionHandler:(NSPersistentStoreAsynchronousFetchResultCompletionBlock)completionHandler{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",type];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
    request.predicate = predicate;
    request.fetchOffset = offset;
    request.fetchLimit = count;
    NSAsynchronousFetchRequest *asyncRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:completionHandler];
    NSError *error = nil;
    [context executeRequest:asyncRequest error:&error];
}

@end
