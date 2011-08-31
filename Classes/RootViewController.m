//
//  RootViewController.m
//  Area Codes
//
//  Created by August Joki on 4/20/08.
//  Copyright Nokia Research 2008. All rights reserved.
//

#import "RootViewController.h"
#import "Area_CodesAppDelegate.h"
#import "AreaCode.h"
#import "AreaCodeCell.h"
#import "AreaCodeViewController.h"
#import "SearchView.h"


@interface RootViewController (Private)
- (void)inspectAreaCode:(AreaCode *)areaCode;
@end

@implementation RootViewController


- (id)init {
  if (self = [super init]) {
    self.title = @"Area Codes";
  }
  return self;
}


- (void)dealloc {
  [searchButton release];
  [doneButton release];
  [searchView release];
  [areaCodeViewController release];
  [super dealloc];
}


- (void)loadView {
  [super loadView];
  
  searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showPicker:)];
  self.navigationItem.rightBarButtonItem = searchButton;
  doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePicker:)];
  
  searchView = [[SearchView alloc] init];
  searchView.pickerDelegate = self;
  searchView.searchBarDelegate = self;
  
  self.tableView.autoresizesSubviews = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  return [appDelegate countOfIndexList];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSDictionary *dict = [appDelegate objectInDisplayListAtIndex:section];
  NSArray *array = [dict objectForKey:@"codes"];
  return [array count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSDictionary *dict = [appDelegate objectInDisplayListAtIndex:section];
  return [dict valueForKey:@"first"];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  return [appDelegate.displayList valueForKey:@"first"];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  return [appDelegate.indexList indexOfObject:title];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AreaCodeCell *cell = (AreaCodeCell *)[tableView dequeueReusableCellWithIdentifier:@"AreaCodeCell"];
  if (cell == nil) {
	  cell = [[[AreaCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AreaCodeCell"] autorelease];
  }
  
  // Set up the cell
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSDictionary *dict = [appDelegate objectInDisplayListAtIndex:indexPath.section];
  NSArray *array = [dict objectForKey:@"codes"];
  AreaCode *areaCode = [array objectAtIndex:indexPath.row];
  [areaCode hydrate];
  
  NSString *code = areaCode.code;
  NSString *area = areaCode.area;
  NSString *state = areaCode.state;
  NSString *country = areaCode.country;
  
  NSMutableString *text = [NSMutableString stringWithString:@""];
  if (area) {
    [text appendString:area];
  }
  if (state) {
    if (area) {
      [text appendFormat:@", %@", state];
    }
    else {
      [text appendString:state];
    }
  }
  if (country) {
    if (state || area) {
      [text appendFormat:@", %@", country];
    }
    else {
      [text appendString:country];
    }
  }
  [cell setCodeText:code];
  [cell setInfoText:text];
  return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSDictionary *dict = [appDelegate objectInDisplayListAtIndex:indexPath.section];
  NSArray *array = [dict objectForKey:@"codes"];
  AreaCode *areaCode = [array objectAtIndex:indexPath.row];
  [self inspectAreaCode:areaCode];
  return indexPath;
}


- (void)inspectAreaCode:(AreaCode *)areaCode {
  if (areaCodeViewController == nil) {
    areaCodeViewController = [[AreaCodeViewController alloc] init];
  }
  [areaCode hydrate];
  areaCodeViewController.areaCode = areaCode;
  [self.navigationController pushViewController:areaCodeViewController animated:YES];
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
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSDictionary *dict = [appDelegate objectInDisplayListAtIndex:indexPath.section];
  NSArray *array = [dict objectForKey:@"codes"];
  AreaCode *areaCode = [array objectAtIndex:indexPath.row];
  NSString *code = areaCode.code;
  NSRange second = NSMakeRange(1,1);
  NSRange third = NSMakeRange(2,1);
  int two = [[code substringWithRange:second] intValue];
  int three = [[code substringWithRange:third] intValue];
  [searchView.pickerView selectRow:indexPath.section inComponent:0 animated:YES];
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
    Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate countOfIndexList];
  }
  else {
    return 10;
  }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  int rowValue;
  if (component == 0) {
    Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
    rowValue = [[appDelegate objectInIndexListAtIndex:row] intValue];
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
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSString *first = [appDelegate objectInIndexListAtIndex:one];
  NSString *code = [NSString stringWithFormat:@"%@%d%d", first, two, three];
  NSUInteger codeRow = [appDelegate indexInDisplayListAtIndex:one nearCode:code];
  NSIndexPath *path = [NSIndexPath indexPathForRow:codeRow inSection:one];
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
  NSString *code = [NSMutableString stringWithString:searchText];
  NSUInteger length = [code length];
  if (length == 1) {
    code = [code stringByAppendingString:@"00"];
  }
  else if (length == 2) {
    code = [code stringByAppendingString:@"0"];
  }
  else if (length > 3) {
    code = [code substringToIndex:3];
  }
  
  NSString *first = [code substringToIndex:1];
  Area_CodesAppDelegate *appDelegate = (Area_CodesAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSInteger one = [appDelegate.indexList indexOfObject:first];
  NSUInteger codeRow = [appDelegate indexInDisplayListAtIndex:one nearCode:code];
  NSIndexPath *path = [NSIndexPath indexPathForRow:codeRow inSection:one];
  [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
  NSRange second = NSMakeRange(1,1);
  NSRange third = NSMakeRange(2,1);
  int two = [[code substringWithRange:second] intValue];
  int three = [[code substringWithRange:third] intValue];
  [searchView.pickerView selectRow:path.section inComponent:0 animated:NO];
  [searchView.pickerView selectRow:two inComponent:1 animated:NO];
  [searchView.pickerView selectRow:three inComponent:2 animated:NO];
}


@end
