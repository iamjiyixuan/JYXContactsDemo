//
//  JYXContactCollectionViewCell.h
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/27/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYXContactCollectionViewCellEntity : NSObject

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *name;

@end

@interface JYXContactCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) JYXContactCollectionViewCellEntity *entity;

@property (nonatomic, assign) CGSize avatarImageSize;

@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) UILabel *nameLabel;

@end
