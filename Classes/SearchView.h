//
//  SearchView.h
//  Area Codes
//
//  Created by August Joki on 4/25/08.
//  Copyright 2008 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchView : UIView {
  UIPickerView *pickerView;
  id<UIPickerViewDelegate> pickerDelegate;
  UISearchBar *searchBar;
  id<UISearchBarDelegate> searchBarDelegate;
}

@property(nonatomic, assign) id<UIPickerViewDelegate> pickerDelegate;
@property(nonatomic, readonly) UIPickerView *pickerView;
@property(nonatomic, assign) id<UISearchBarDelegate> searchBarDelegate;
@property(nonatomic, readonly) UISearchBar *searchBar;

- (void)showInView:(UIView *)view;
- (void)hide;

@end
