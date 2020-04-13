//
//  LocalFileInfo+CoreDataProperties.h
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//
//

#import "LocalFileInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocalFileInfo (CoreDataProperties)

+ (NSFetchRequest<LocalFileInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *size;
@property (nullable, nonatomic, copy) NSString *type;



@end

NS_ASSUME_NONNULL_END
