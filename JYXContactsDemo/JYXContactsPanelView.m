//
//  JYXContactsPanelView.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/26/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactsPanelView.h"
#import "JYXContactCollectionViewCell.h"
#import "JYXContact+JYXContactsPanelViewContact.h"

// 3rd
#import <Masonry/Masonry.h>

@interface JYXContactsPanelView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// views
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JYXContactsPanelView

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init]) {
        // add subviews
        [self addSubview:self.collectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // add subviews
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // layout subviews
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<JYXContactsPanelViewContact> contact = nil;
    if (indexPath.row < self.contacts.count) {
        contact = self.contacts[indexPath.row];
    }
    
    JYXContactCollectionViewCellEntity *entity = [[JYXContactCollectionViewCellEntity alloc] init];
    entity.avatarImage = [contact avatarImage];
    entity.name = [contact name];
    
    JYXContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JYXContactCollectionViewCell class]) forIndexPath:indexPath];
    CGFloat cellWidth = (self.frame.size.width - 10 * 3) / 4;
    cell.avatarImageSize = CGSizeMake(cellWidth * 0.65, cellWidth * 0.65);
    cell.entity = entity;
    
//    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.borderWidth = 1;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth = (self.frame.size.width - 2 * 5 - 3 * 1.0f) / 4;
    
    return CGSizeMake(cellWidth, cellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

#pragma mark - Getters & Setters

- (void)setContacts:(NSMutableArray *)contacts
{
    _contacts = contacts.mutableCopy;
    
    // +
    JYXContact *add = [[JYXContact alloc] init];
    add.avatarImageName = @"IconAdd";
    [_contacts addObject:add];
    
    if (contacts.count > 0) {
        
        JYXContact *remove = [[JYXContact alloc] init];
        remove.avatarImageName = @"IconRemove";
        [_contacts addObject:remove];
        
    }    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = [UIColor blueColor].CGColor;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView registerClass:[JYXContactCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JYXContactCollectionViewCell class])];
    }
    return _collectionView;
}

@end
