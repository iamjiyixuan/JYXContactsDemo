//
//  JYXContactTableViewCell.h
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYXContactTableViewCellEntity : NSObject

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *name;

@end

@interface JYXContactTableViewCell : UITableViewCell

@property (nonatomic, strong) JYXContactTableViewCellEntity *entity;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end
