//
//  AreaCodeViewController.m
//  Area Codes
//
//  Created by August Joki on 4/22/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import "AreaCodeViewController.h"
#import "AreaCode.h"
#import "PrefixViewController.h"


@implementation AreaCodeViewController

@synthesize areaCode;

- (id)init {
  if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    // Initialize your view controller.
    self.title = @"Area Code Info";
  }
  return self;
}


- (void)loadView {
  [super loadView];
}

- (void)dealloc {
  [prefixViewController release];
  [prefixes release];
  [headers release];
  [values release];
  [areaCode release];
  [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Only one row for each section
  return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
  if (cell == nil) {
    // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
    cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MyIdentifier"] autorelease];
  }
  cell.text = [values objectAtIndex:indexPath.section];
  return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [headers objectAtIndex:section];
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if ([prefixes count]) {
      return UITableViewCellAccessoryDetailDisclosureButton;
    }
  }
  return UITableViewCellAccessoryNone;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  if (prefixViewController == nil) {
    prefixViewController = [[PrefixViewController alloc] init];
  }
  prefixViewController.prefixes = prefixes;
  prefixViewController.parent = self;
  [self.navigationController pushViewController:prefixViewController animated:YES];
}


- (void)setAreaCode:(AreaCode *)ac {
  if (ac != areaCode) {
    [areaCode release];
    areaCode = [ac retain];
    self.title = areaCode.code;
    [prefixViewController release];
    prefixViewController = nil;
    [prefixes release];
    prefixes = [[self.areaCode prefixes] retain];
    [values release];
    [headers release];
    NSMutableArray *vals = [[NSMutableArray alloc] init];
    NSMutableArray *hdrs = [[NSMutableArray alloc] init];
    if ([prefixes count]) {
      NSString *pfx = [prefixes objectAtIndex:0];
      
      [hdrs addObject:@"Prefix"];
      [vals addObject:pfx];
      
      [hdrs addObject:@"City"];
      [vals addObject:[[areaCode cityWithPrefix:pfx] capitalizedString]];
    }
    if (areaCode.area) {
      [hdrs addObject:@"Area"];
      [vals addObject:areaCode.area];
    }
    if (areaCode.state) {
      [hdrs addObject:@"State / Providence"];
      [vals addObject:areaCode.state];
    }
    if (areaCode.country) {
      [hdrs addObject:@"Country"];
      [vals addObject:areaCode.country];
    }
    headers = hdrs;
    values = vals;
    [self.tableView reloadData];
  }
}

- (void)setPrefix:(NSString *)pfx {
  if ([prefixes count] == 0) {
    return;
  }
  NSString *prefix = [values objectAtIndex:0];
  if (prefix == nil || [prefix compare:pfx] != NSOrderedSame) {
    [values replaceObjectAtIndex:0 withObject:pfx];
    NSString *newCity = [areaCode cityWithPrefix:pfx];
    [values replaceObjectAtIndex:1 withObject:[newCity capitalizedString]];
    [self.tableView reloadData];
  }
}

@end
