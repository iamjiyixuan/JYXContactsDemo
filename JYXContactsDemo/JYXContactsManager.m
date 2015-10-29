//
//  JYXContactsManager.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactsManager.h"
#import "JYXContact.h"
#import "JYXGroup.h"

static NSArray * const kContacts()
{
    // Data from `contacts.json`
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *contactsDicts = rootDict[@"contacts"];
    
    // Convert to `JYXContact`
    NSMutableArray *contacts = @[].mutableCopy;
    [contactsDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        JYXContact *contact = [[JYXContact alloc] init];
        contact.name = obj[@"name"];
        contact.avatarImageName = obj[@"avatarImageName"];
        contact.kingdom = obj[@"kingdom"];
        
        [contacts addObject:contact];
    }];
    
    return [contacts copy];
}

@implementation JYXContactsManager

- (void)loadContactsCompleted:(JYXLoadContactsCompletionBlock)completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completedBlock ?: completedBlock(kContacts(), error);
        });
    });
}

- (void)loadContactGroupCompleted:(JYXLoadContactGroupCompletionBlock)completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSArray *contacts = kContacts();
        
        NSMutableArray *contactGroup = @[].mutableCopy;
        
        {
            JYXGroup *group = [[JYXGroup alloc] init];
            group.groupName = @"魏";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"kingdom == %@", group.groupName];
            group.groupItems = [contacts filteredArrayUsingPredicate:pred];
            
            [contactGroup addObject:group];
        }
        
        {
            JYXGroup *group = [[JYXGroup alloc] init];
            group.groupName = @"蜀";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"kingdom == %@", group.groupName];
            group.groupItems = [contacts filteredArrayUsingPredicate:pred];
            
            [contactGroup addObject:group];
        }
        
        {
            JYXGroup *group = [[JYXGroup alloc] init];
            group.groupName = @"吴";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"kingdom == %@", group.groupName];
            group.groupItems = [contacts filteredArrayUsingPredicate:pred];
            
            [contactGroup addObject:group];
        }
        
        {
            JYXGroup *group = [[JYXGroup alloc] init];
            group.groupName = @"群";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"kingdom == %@", group.groupName];
            group.groupItems = [contacts filteredArrayUsingPredicate:pred];
            
            [contactGroup addObject:group];
        }
        
        {
            JYXGroup *group = [[JYXGroup alloc] init];
            group.groupName = @"神";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"kingdom == %@", group.groupName];
            group.groupItems = [contacts filteredArrayUsingPredicate:pred];
            
            [contactGroup addObject:group];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completedBlock ?: completedBlock([contactGroup copy], error);
        });
    });
}

@end
