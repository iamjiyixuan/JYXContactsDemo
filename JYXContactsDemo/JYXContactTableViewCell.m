//
//  JYXContactTableViewCell.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactTableViewCell.h"
#import <Masonry/Masonry.h>

static CGSize kJYXContactTableViewCellAvatarImageSize = {55.0f, 55.0f};

@implementation JYXContactTableViewCellEntity

@end

@implementation JYXContactTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // add subviews
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // layout subviews
    __weak typeof(self) weakSelf = self;
    [self.avatarImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kJYXContactTableViewCellAvatarImageSize);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(20.0f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImageView.mas_right).offset(20.0f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20.0f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
    }];
}

#pragma mark - Getters & Setters

- (void)setEntity:(JYXContactTableViewCellEntity *)entity
{
    _entity = entity;
    
    self.avatarImageView.image = entity.avatarImage;
    self.nameLabel.text = entity.name;
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = kJYXContactTableViewCellAvatarImageSize.width / 2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

@end
