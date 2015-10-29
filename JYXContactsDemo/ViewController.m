//
//  ViewController.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "ViewController.h"
#import "JYXContactsViewController.h"
#import "JYXContactsPanelViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add subviews
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *item = nil;
    if (indexPath.row < self.items.count) {
        item = self.items[indexPath.row];
    }
    
    NSString *identifier = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = item;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        JYXContactsViewController *contactsViewController = [[JYXContactsViewController alloc] init];
        [self.navigationController pushViewController:contactsViewController animated:YES];
        
    } else if (indexPath.row == 1) {
        
        JYXContactsPanelViewController *contactsPanelViewController = [[JYXContactsPanelViewController alloc] init];
        [self.navigationController pushViewController:contactsPanelViewController animated:YES];
    }
}

#pragma mark - Getters & Setters

- (NSArray *)items
{
    if (!_items) {
        _items = @[@"contacts", @"contacts panel"];
    }
    return _items;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
