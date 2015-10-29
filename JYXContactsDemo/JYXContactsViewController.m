//
//  JYXContactsViewController.m
//  JYXContactsDemo
//
//  Created by JI Yixuan on 10/25/15.
//  Copyright © 2015 iamjiyixuan. All rights reserved.
//

#import "JYXContactsViewController.h"
#import "JYXContact.h"
#import "JYXGroup.h"
#import "JYXContactsManager.h"
#import "JYXContactTableViewCell.h"

#import <Masonry/Masonry.h>

static CGSize const kJYXContactsViewControllerFloatLabelSize = {75.0f, 75.0f};

static UIColor * JYXBlueColor(CGFloat alpha)
{
    return [UIColor colorWithRed:0.32f green:0.65f blue:0.98f alpha:alpha];
}

@interface JYXContactsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

// manager
@property (nonatomic, strong) JYXContactsManager *contactsManager;

// data
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSArray *contactGroups;
@property (nonatomic, strong) NSMutableArray *filteredContacts;

// views
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *contactCountLabel;
@property (nonatomic, strong) UILabel *floatLabel;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation JYXContactsViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add subviews
    [self.view addSubview:self.tableView];
    [self.tableView.tableFooterView addSubview:self.contactCountLabel];
    [self.view addSubview:self.floatLabel];
    
    __weak typeof(self) weakSelf = self;
    
    // load data
    [self.contactsManager loadContactsCompleted:^(NSArray *contacts, NSError *error) {
        weakSelf.contacts = contacts;
        weakSelf.contactCountLabel.text = [NSString stringWithFormat:@"%lu位联系人", contacts.count];
        [weakSelf.tableView reloadData];
    }];
    
    [self.contactsManager loadContactGroupCompleted:^(NSArray *contactGroups, NSError *error) {
        weakSelf.contactGroups = contactGroups;
        [weakSelf.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // layout subviews
    __weak typeof(self) weakSelf = self;
    [self.contactCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tableView.tableFooterView.mas_left).offset(10.0f);
        make.right.mas_equalTo(weakSelf.tableView.tableFooterView.mas_right).offset(-10.0f);
        make.centerY.mas_equalTo(weakSelf.tableView.tableFooterView.mas_centerY);
    }];
    
    [self.floatLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(kJYXContactsViewControllerFloatLabelSize);
        make.centerX.mas_equalTo(weakSelf.tableView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.tableView.mas_centerY);
    }];
    
//    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.searchController.active) {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:[self.tableView visibleCells].firstObject];
    if (indexPath.section < self.contactGroups.count) {
        
        JYXGroup *group = self.contactGroups[indexPath.section];
        self.floatLabel.alpha = 0.5f;
        self.floatLabel.text = group.groupName;
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.floatLabel.alpha = 0.0f;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [UIView animateWithDuration:1 animations:^{
        self.floatLabel.alpha = 0.0f;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:1 animations:^{
        self.floatLabel.alpha = 0.0f;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return 1;
    }
    
    return self.contactGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.filteredContacts.count;
    }
    
    JYXGroup *group = nil;
    if (section < self.contactGroups.count) {
        group = self.contactGroups[section];
    }
    
    return group.groupItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYXGroup *group = nil;
    if (indexPath.section < self.contactGroups.count) {
        group = self.contactGroups[indexPath.section];
    }
    
    JYXContact *contact = nil;
    if (indexPath.row < group.groupItems.count) {
        contact = group.groupItems[indexPath.row];
    }
    
    if (self.searchController.active && indexPath.row < self.filteredContacts.count) {
        contact = self.filteredContacts[indexPath.row];
    }
    
    JYXContactTableViewCellEntity *entity = [[JYXContactTableViewCellEntity alloc] init];
    entity.avatarImage = [UIImage imageNamed:contact.avatarImageName];
    entity.name = contact.name;
    
    NSString *identifier = NSStringFromClass([JYXContactTableViewCell class]);
    JYXContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[JYXContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.entity = entity;
    
    if (self.searchController.active) {
        
        NSRange range = [contact.name rangeOfString:self.searchController.searchBar.text];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:cell.nameLabel.text];
        
        // make red text
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:JYXBlueColor(1.0f)
                           range:range];
        
        [cell.nameLabel setAttributedText:attrString];
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    }
    
    NSMutableArray *indexTitles = @[].mutableCopy;
    for (JYXGroup *group in self.contactGroups) {
        [indexTitles addObject:group.groupName];
    }
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return nil;
    }
    
    JYXGroup *group = nil;
    if (section < self.contactGroups.count) {
        group = self.contactGroups[section];
    }
    return group.groupName;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return 0;
    }
    
    return 21.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray<NSIndexPath *> *selectedRows = [tableView indexPathsForSelectedRows];
//    
//    if (!self.tableView.editing) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return nil;
    }
    
    JYXGroup *group = nil;
    if (section < self.contactGroups.count) {
        group = self.contactGroups[section];
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = JYXBlueColor(0.7f);
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.text = group.groupName;
    label.textColor = [UIColor whiteColor];
    [headerView addSubview:label];
    
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(10);
        make.centerY.mas_equalTo(headerView.mas_centerY);
    }];
    
    return headerView;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self jyx_searchForText:searchString];
    [self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)jyx_searchForText:(NSString *)searchString
{
    self.filteredContacts = @[].mutableCopy;
    for (JYXContact *contact in self.contacts) {
        
        BOOL contain = [contact.name containsString:searchString];
        if (contain) {
            [self.filteredContacts addObject:contact];
        }
    }
}

#pragma mark - Getters & Setters

- (JYXContactsManager *)contactsManager
{
    if (!_contactsManager) {
        _contactsManager = [[JYXContactsManager alloc] init];
    }
    return _contactsManager;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.searchController.searchBar;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50.0f)];
        _tableView.rowHeight = 80.0f;
        _tableView.sectionIndexColor = JYXBlueColor(0.7f);
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UILabel *)contactCountLabel
{
    if (!_contactCountLabel) {
        _contactCountLabel = [[UILabel alloc] init];
        _contactCountLabel.textAlignment = NSTextAlignmentCenter;
        _contactCountLabel.textColor = JYXBlueColor(1.0f);
    }
    return _contactCountLabel;
}

- (UILabel *)floatLabel
{
    if (!_floatLabel) {
        _floatLabel = [[UILabel alloc] init];
        _floatLabel.backgroundColor = [UIColor blackColor];
        _floatLabel.textColor = [UIColor whiteColor];
        _floatLabel.font = [UIFont systemFontOfSize:30.0f];
        _floatLabel.layer.cornerRadius = kJYXContactsViewControllerFloatLabelSize.width / 2;
        _floatLabel.clipsToBounds = YES;
        _floatLabel.textAlignment = NSTextAlignmentCenter;
        _floatLabel.alpha = 0;
    }
    return _floatLabel;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.placeholder = @"搜索";
        
        UITextField *txfSearchField = [_searchController.searchBar valueForKey:@"_searchField"];
        txfSearchField.layer.cornerRadius = 2.5;
        txfSearchField.layer.borderWidth = 1;
        txfSearchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _searchController;
}

@end
