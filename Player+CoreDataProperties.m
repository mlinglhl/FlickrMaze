//
//  Player+CoreDataProperties.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-04.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Player+CoreDataProperties.h"

@implementation Player (CoreDataProperties)

+ (NSFetchRequest<Player *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Player"];
}

@dynamic currentX;
@dynamic currentY;

@end
