//
//  LocalFileInfo+CoreDataProperties.m
//  Library_FNCameraApp
//
//  Created by apical on 2019/8/21.
//  Copyright © 2019年 Choco Yang. All rights reserved.
//
//

#import "LocalFileInfo+CoreDataProperties.h"

@implementation LocalFileInfo (CoreDataProperties)

+ (NSFetchRequest<LocalFileInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LocalFileInfo"];
}

@dynamic name;
@dynamic url;
@dynamic size;
@dynamic type;
@end
