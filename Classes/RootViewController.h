//
//  RootViewController.h
//  Area Codes
//
//  Created by August Joki on 4/20/08.
//  Copyright Concinnous Software 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaCodeViewController, SearchView;

@interface RootViewController : UITableViewController <UIPickerViewDelegate, UISearchBarDelegate> {
  AreaCodeViewController *areaCodeViewController;
  UIBarButtonItem *searchButton;
  UIBarButtonItem *doneButton;
  SearchView *searchView;
}

@end
