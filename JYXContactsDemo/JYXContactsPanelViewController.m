//
//  JYXContactsPanelViewController.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/26/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactsPanelViewController.h"
#import "JYXContactsManager.h"
#import "JYXContactsPanelView.h"

// 3rd
#import <Masonry/Masonry.h>

@interface JYXContactsPanelViewController ()

@property (nonatomic, strong) JYXContactsPanelView *contactsPanelView;

// manager
@property (nonatomic, strong) JYXContactsManager *contactsManager;

// data
@property (nonatomic, strong) NSArray *contacts;

@end

@implementation JYXContactsPanelViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add subviews
    [self.view addSubview:self.contactsPanelView];
    
    __weak typeof(self) weakSelf = self;
    [self.contactsManager loadContactsCompleted:^(NSArray *contacts, NSError *error) {
        weakSelf.contacts = contacts;
        self.contactsPanelView.contacts = contacts.mutableCopy;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // layout subviews
    __weak typeof(self) weakSelf = self;
    [self.contactsPanelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(20.0f + 44.0f);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(0.0f);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(0.0f);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(0.0f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (JYXContactsManager *)contactsManager
{
    if (!_contactsManager) {
        _contactsManager = [[JYXContactsManager alloc] init];
    }
    return _contactsManager;
}

- (JYXContactsPanelView *)contactsPanelView
{
    if (!_contactsPanelView) {
        _contactsPanelView = [[JYXContactsPanelView alloc] init];
        _contactsPanelView.layer.borderColor = [UIColor redColor].CGColor;
        _contactsPanelView.layer.borderWidth = 1.0f;
    }
    return _contactsPanelView;
}

@end
