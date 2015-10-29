//
//  JYXContactsPanelView.h
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/26/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYXContactsPanelViewContact <NSObject>

@required
@property (nonatomic, strong, readonly) UIImage *avatarImage;
@property (nonatomic, copy) NSString *name;

@end

@interface JYXContactsPanelView : UIView

@property (nonatomic, strong) NSMutableArray *contacts;

@end
