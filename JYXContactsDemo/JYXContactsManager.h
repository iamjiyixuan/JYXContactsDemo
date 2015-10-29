//
//  JYXContactsManager.h
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JYXLoadContactsCompletionBlock)(NSArray *contacts, NSError *error);
typedef void (^JYXLoadContactGroupCompletionBlock)(NSArray *contactGroups, NSError *error);

@interface JYXContactsManager : NSObject

- (void)loadContactsCompleted:(JYXLoadContactsCompletionBlock)completedBlock;
- (void)loadContactGroupCompleted:(JYXLoadContactGroupCompletionBlock)completedBlock;

@end
