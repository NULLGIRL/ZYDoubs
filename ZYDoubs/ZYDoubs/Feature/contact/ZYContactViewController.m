//
//  ZYContactViewController.m
//  ZYDoubs
//
//  Created by Momo on 17/1/11.
//  Copyright © 2017年 Momo. All rights reserved.
//

#import "ZYContactViewController.h"
#import "ContactViewCell.h"

@interface ZYContactViewController ()
{
    NSArray* orderedSections;
    NSMutableDictionary* contacts;
    
}
@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation ZYContactViewController

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!contacts){
        contacts = [[NSMutableDictionary alloc] init];
    }
    
    // load data and register for notifications
    [self refreshData];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(onContactEvent:) name:kNgnContactEventArgs_Name object:nil];
    
    self.tableView.tableHeaderView = self.searchBar;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBlackTitle:@"联系人" smallTitle:@"Contact" withVC:self.tabBarController];
    [self createRightBarButtonItemWithImage:@"Plus" WithTitle:@"" withMethod:@selector(PlusBtnClick) withVC:self.tabBarController];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self.navigationController setNavigationBarHidden: YES];
    }

- (void)viewWillDisappear:(BOOL)animate{
    [super viewWillDisappear: animate];
    [self.navigationController setNavigationBarHidden: NO];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)dealloc {
    [self.tableView release];
  
    [_searchBar release];
   
    [contacts release];
    
    
    [super dealloc];
}




-(void)PlusBtnClick{
    NSLog(@"添加联系人");
}


- (void) onButtonToolBarItemClick: (id)_sender{
    UIBarButtonItem* sender = ((UIBarButtonItem*)_sender);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    [contacts removeAllObjects];
    [self reloadData];
}

//
//	Searching
//

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    self.searchBar.showsCancelButton = YES;
    
    // disable indexes
    [self reloadData];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    self.tableView.scrollEnabled = YES;
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    [self refreshDataAndReload];
}

//
//	UITableView
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [orderedSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @synchronized(contacts){
        if([orderedSections count] > section){
            NSMutableArray* values = [contacts objectForKey: [orderedSections objectAtIndex: section]];
            return [values count];
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    @synchronized(contacts){
        return [orderedSections objectAtIndex: section];
    }
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return [ContactViewCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactViewCell *cell = (ContactViewCell*)[_tableView dequeueReusableCellWithIdentifier: kContactViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactViewCell" owner:self options:nil] lastObject];
    }
    
    @synchronized(contacts){
        if([orderedSections count] > indexPath.section){
            NSMutableArray* values = [contacts objectForKey: [orderedSections objectAtIndex: indexPath.section]];
            NgnContact* contact = [values objectAtIndex: indexPath.row];
            if(contact && contact.displayName){
                [cell setDisplayName: contact.displayName];
            }
        }
    }
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
   
    return orderedSections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger i = 0;
    @synchronized(contacts){
        for(NSString *title_ in orderedSections){
            if([title_ isEqualToString: title]){
                return i;
            }
            ++i;
        }
        return i;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @synchronized(contacts){
        if([orderedSections count] > indexPath.section){
            NSMutableArray* values = [contacts objectForKey: [orderedSections objectAtIndex: indexPath.section]];
            NgnContact* contact = [values objectAtIndex: indexPath.row];
            if(contact && contact.displayName){
//                if(!contactDetailsController){
//                    contactDetailsController = [[ContactDetailsController alloc] initWithNibName: @"ContactDetails" bundle:nil];
//                }
//                contactDetailsController.contact = contact;
//                [self.navigationController pushViewController: contactDetailsController  animated: TRUE];
            }
        }
    }
}


#pragma mark - 懒加载
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    }
    return _searchBar;
}


-(void) refreshData{
    @synchronized(contacts){
        [contacts removeAllObjects];
        NgnContactMutableArray* contacts_ = [[[NgnEngine sharedInstance].contactService contacts] retain];
        NSString *lastGroup = @"$", *group;
        NSMutableArray* lastArray = nil;
        for (NgnContact* contact in contacts_) {
            if(!contact || [NgnStringUtils isNullOrEmpty: contact.displayName] || (![NgnStringUtils isNullOrEmpty: _searchBar.text] && [contact.displayName rangeOfString:_searchBar.text  options:NSCaseInsensitiveSearch].location == NSNotFound)){
                continue;
            }
            
            group = [contact.displayName substringToIndex: 1];
            if([group caseInsensitiveCompare: lastGroup] != NSOrderedSame){
                lastGroup = group;
                // NSLog(@"group=%@", group);
                [lastArray release];
                lastArray = [[NSMutableArray alloc] init];
                [contacts setObject: lastArray forKey: lastGroup];
            }
            [lastArray addObject: contact];
        }
        
        [lastArray release];
        [contacts_ release];
        
        [orderedSections release];
        orderedSections = [[[contacts allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] retain];
    }
}

-(void) reloadData{
    [self.tableView reloadData];
}

-(void) refreshDataAndReload{
    [self refreshData];
    [self reloadData];
}

-(void) onContactEvent:(NSNotification*)notification{
    NgnContactEventArgs* eargs = [notification object];
    
    switch (eargs.eventType) {
        case CONTACT_RESET_ALL:
        {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 40000
            switch ([UIApplication sharedApplication].applicationState) {
                case UIApplicationStateActive:
                    [self refreshDataAndReload];
                    break;
                case UIApplicationStateInactive:
                case UIApplicationStateBackground:
//                    self->nativeContactsChangedWhileInactive = YES;
                    break;
            }
#else
            [self refreshDataAndReload];
#endif
            break;
        }
        default:
            break;
    }
}


@end
