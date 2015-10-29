//
//  JYXContactCollectionViewCell.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/27/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactCollectionViewCell.h"

// 3rd
#import <Masonry/Masonry.h>

@implementation JYXContactCollectionViewCellEntity

@end

@implementation JYXContactCollectionViewCell

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        
        self.avatarImageSize = CGSizeMake(35.0f, 35.0f);
        
        // add subvews
        [self addSubview:self.avatarImageButton];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.avatarImageSize = CGSizeMake(35.0f, 35.0f);
        
        // add subvews
        [self addSubview:self.avatarImageButton];
        [self addSubview:self.nameLabel];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // layout subviews
    __weak typeof(self) weakSelf = self;
    [self.avatarImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.avatarImageSize);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(5);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.avatarImageButton.mas_bottom).offset(5);
        make.width.mas_equalTo(weakSelf.contentView.mas_width);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
}

#pragma mark - Getters & Setters

- (void)setEntity:(JYXContactCollectionViewCellEntity *)entity
{
    _entity = entity;
    
    [self.avatarImageButton setBackgroundImage:entity.avatarImage forState:UIControlStateNormal];
    self.nameLabel.text = entity.name;
}

- (void)setAvatarImageSize:(CGSize)avatarImageSize
{
    _avatarImageSize = avatarImageSize;
    
    self.avatarImageButton.layer.cornerRadius = self.avatarImageSize.width / 2;
}

- (UIButton *)avatarImageButton
{
    if (!_avatarImageButton) {
        _avatarImageButton = [[UIButton alloc] init];
        _avatarImageButton.layer.cornerRadius = self.avatarImageSize.width / 2;
        _avatarImageButton.layer.masksToBounds = YES;
    }
    return _avatarImageButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.text = @"nameLabel";
    }
    return _nameLabel;
}

@end
