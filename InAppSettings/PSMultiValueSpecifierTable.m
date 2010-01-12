//
//  PSMultiValueSpecifierTable.m
//  InAppSettings
//
//  Created by David Keegan on 11/3/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSMultiValueSpecifierTable.h"
#import "InAppSettingConstants.h"

@implementation PSMultiValueSpecifierTable

@synthesize setting;

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithSetting:(InAppSetting *)inputSetting{
    self = [super init];
    if (self != nil){
        self.setting = inputSetting;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = NSLocalizedString([self.setting valueForKey:@"Title"], nil);
}

- (void)dealloc{
    [setting release];
    [super dealloc];
}

#pragma mark Value

- (id)getValue{
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:[self.setting valueForKey:@"Key"]];
    if(value == nil){
        value = [self.setting valueForKey:@"DefaultValue"];
    }
    return value;
}

- (void)setValue:(id)newValue{
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:[self.setting valueForKey:@"Key"]];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.setting valueForKey:@"Values"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PSMultiValueSpecifierTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        #else
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        #endif
    }
	
    NSString *cellTitle = NSLocalizedString([[self.setting valueForKey:@"Titles"] objectAtIndex:indexPath.row], nil);
    id cellValue = [[self.setting valueForKey:@"Values"] objectAtIndex:indexPath.row];
    #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
    cell.textLabel.text = cellTitle;
    #else
    cell.text = cellTitle;
    #endif
	if([cellValue isEqual:[self getValue]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
        cell.textLabel.textColor = InAppSettingBlue;
        #else
        cell.textColor = InAppSettingBlue;
        #endif
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
        cell.textLabel.textColor = [UIColor blackColor];
        #else
        cell.textColor = [UIColor blackColor];
        #endif
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id cellValue = [[self.setting valueForKey:@"Values"] objectAtIndex:indexPath.row];
    [self setValue:cellValue];
    [self.tableView reloadData];
    return indexPath;
}

@end

