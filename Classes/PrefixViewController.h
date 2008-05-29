//
//  PrefixViewController.h
//  Area Codes
//
//  Created by August Joki on 4/29/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView;

@interface PrefixViewController : UITableViewController <UIPickerViewDelegate, UISearchBarDelegate> {
  NSIndexPath *selectedIndexPath;
  NSArray *prefixes;
  UIBarButtonItem *searchButton;
  SearchView *searchView;
  NSArray *indexes;
}

@property(nonatomic, retain) NSArray *prefixes;

@end
