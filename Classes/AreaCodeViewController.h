//
//  AreaCodeViewController.h
//  Area Codes
//
//  Created by August Joki on 4/22/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaCode, PrefixViewController;

@interface AreaCodeViewController : UITableViewController {
  PrefixViewController *prefixViewController;
  AreaCode *areaCode;
  NSArray *prefixes;
  int sections;
  NSMutableArray *headers;
  NSMutableArray *values;
}

@property(nonatomic, retain) AreaCode *areaCode;

- (void)setPrefix:(NSString *)prefix;

@end
