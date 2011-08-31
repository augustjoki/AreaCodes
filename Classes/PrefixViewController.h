//
//  PrefixViewController.h
//  Area Codes
//
//  Created by August Joki on 4/29/08.
//  Copyright 2008 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView, AreaCodeViewController;

@interface PrefixViewController : UITableViewController <UIPickerViewDelegate, UISearchBarDelegate> {
  NSIndexPath *selectedIndexPath;
  NSArray *prefixes;
  UIBarButtonItem *searchButton;
  UIBarButtonItem *doneButton;
  SearchView *searchView;
  NSArray *indexes;
  AreaCodeViewController *parent;
}

@property(nonatomic, retain) NSArray *prefixes;
@property(nonatomic, retain) AreaCodeViewController *parent;
@property(nonatomic, retain, readonly) NSIndexPath *selectedIndexPath;

@end
