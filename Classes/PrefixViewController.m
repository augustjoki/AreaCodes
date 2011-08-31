//
//  PrefixViewController.m
//  Area Codes
//
//  Created by August Joki on 4/29/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import "PrefixViewController.h"
#import "AreaCodeViewController.h"
#import "SearchView.h"

@interface PrefixViewController ()

@property(nonatomic, retain, readwrite) NSIndexPath *selectedIndexPath;

- (void)deselectRow;

@end

@implementation PrefixViewController

@synthesize prefixes, parent, selectedIndexPath;

- (id)init {
  if (self = [super init]) {
    self.title = @"Prefixes";
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  }
  return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [prefixes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *MyIdentifier = @"MyIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
  }
  NSString *prefix = [prefixes objectAtIndex:indexPath.row];
  cell.textLabel.text = prefix;
  //cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedIndexPath == nil) {
    return UITableViewCellAccessoryNone;
  }
  if (indexPath.section == selectedIndexPath.section &&
      indexPath.row == selectedIndexPath.row) {
    return UITableViewCellAccessoryCheckmark;
  }
  else {
    return UITableViewCellAccessoryNone;
  }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
  UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
  
  //[UIView beginAnimations:nil context:nil];
  oldCell.accessoryType = UITableViewCellAccessoryNone;
  newCell.accessoryType = UITableViewCellAccessoryCheckmark;
  //[UIView commitAnimations];
  
  self.selectedIndexPath = indexPath;
  [self performSelector:@selector(deselectRow) withObject:nil afterDelay:0.0];
  return indexPath;
}


- (void)deselectRow {
  [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}


- (void)dealloc {
  [selectedIndexPath release];
  [parent release];
  [prefixes release];
  [indexes release];
  [searchButton release];
  [doneButton release];
  [searchView release];
  [super dealloc];
}


- (void)loadView {
  searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showPicker:)];
  self.navigationItem.rightBarButtonItem = searchButton;
  doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePicker:)];
  
  searchView = [[SearchView alloc] init];
  searchView.pickerDelegate = self;
  searchView.searchBarDelegate = self;
  
  [super loadView];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  [self performSelector:@selector(deselectRow) withObject:nil afterDelay:0.0];
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  NSString *prefix = [prefixes objectAtIndex:selectedIndexPath.row];
  [parent setPrefix:prefix];
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)showPicker:(id)sender {
  //[searchButton removeTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
  //[searchButton addTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventTouchUpInside];
  //searchButton.action = @selector(hidePicker:);
  [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
  [searchView showInView:self.view];
  CGRect bounds = self.tableView.bounds;
  CGPoint point = bounds.origin;
  point.y += self.tableView.sectionHeaderHeight + 2.0;
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
  NSString *prefix = [prefixes objectAtIndex:indexPath.row];
  NSRange second = NSMakeRange(1,1);
  NSRange third = NSMakeRange(2,1);
  int one = [indexes indexOfObject:[prefix substringToIndex:1]];
  int two = [[prefix substringWithRange:second] intValue];
  int three = [[prefix substringWithRange:third] intValue];
  [searchView.pickerView selectRow:one inComponent:0 animated:YES];
  [searchView.pickerView selectRow:two inComponent:1 animated:YES];
  [searchView.pickerView selectRow:three inComponent:2 animated:YES];
}


- (void)hidePicker:(id)sender {
  //[searchButton removeTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventTouchUpInside];
  //[searchButton addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
  //searchButton.action = @selector(showPicker:);
  [self.navigationItem setRightBarButtonItem:searchButton animated:YES];
  [searchView hide];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  if (component == 0) {
    return [indexes count];
  }
  else {
    return 10;
  }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  int rowValue;
  if (component == 0) {
    rowValue = [[indexes objectAtIndex:row] intValue];
  }
  else {
    rowValue = row;
  }
  NSString *formated = [NSString stringWithFormat:@"%2d", rowValue];
  return formated;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  NSInteger one = [pickerView selectedRowInComponent:0];
  NSInteger two = [pickerView selectedRowInComponent:1];
  NSInteger three = [pickerView selectedRowInComponent:2];
  NSString *first = [indexes objectAtIndex:one];
  NSString *prefix = [NSString stringWithFormat:@"%@%d%d", first, two, three];
  
  NSUInteger index = [prefixes indexOfObject:prefix];
  if (index == NSNotFound) {
    index = [prefixes count] - 1;
    for (NSString *pfx in prefixes) {
      NSComparisonResult result = [pfx localizedCompare:prefix];
      if (result == NSOrderedSame || result == NSOrderedDescending) {
        index = [prefixes indexOfObject:pfx];
        break;
      }
    }
  }
  
  NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
  [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (searchText == nil || [searchText length] == 0) {
    return;
  }
  NSString *prefix = [NSMutableString stringWithString:searchText];
  NSUInteger length = [prefix length];
  if (length == 1) {
    prefix = [prefix stringByAppendingString:@"00"];
  }
  else if (length == 2) {
    prefix = [prefix stringByAppendingString:@"0"];
  }
  else if (length > 3) {
    prefix = [prefix substringToIndex:3];
  }
  
  NSUInteger index = [prefixes indexOfObject:prefix];
  if (index == NSNotFound) {
    index = [prefixes count] - 1;
    for (NSString *pfx in prefixes) {
      NSComparisonResult result = [pfx localizedCompare:prefix];
      if (result == NSOrderedSame || result == NSOrderedDescending) {
        index = [prefixes indexOfObject:pfx];
        break;
      }
    }
  }
  
  NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
  [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
  NSRange second = NSMakeRange(1,1);
  NSRange third = NSMakeRange(2,1);
  int one = [indexes indexOfObject:[prefix substringToIndex:1]];
  int two = [[prefix substringWithRange:second] intValue];
  int three = [[prefix substringWithRange:third] intValue];
  [searchView.pickerView selectRow:one inComponent:0 animated:NO];
  [searchView.pickerView selectRow:two inComponent:1 animated:NO];
  [searchView.pickerView selectRow:three inComponent:2 animated:NO];
}


- (void)setPrefixes:(NSArray *)pfxs {
  if (pfxs != prefixes) {
    [prefixes release];
    prefixes = [pfxs retain];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *prefix in prefixes) {
      NSString *first = [prefix substringToIndex:1];
      NSUInteger index = [array indexOfObject:first];
      if (index == NSNotFound) {
        [array addObject:first];
      }
    }
    [indexes release];
    indexes = array;
  }
}


@end

