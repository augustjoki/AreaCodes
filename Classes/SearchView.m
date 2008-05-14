//
//  SearchView.m
//  Area Codes
//
//  Created by August Joki on 4/25/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import "SearchView.h"


@interface SearchView (Private)
- (void)setUpPickerView:(CGRect) frame;
- (void)setUpSearchBar:(CGRect) frame;
@end


@implementation SearchView

@synthesize pickerDelegate, pickerView, searchBarDelegate, searchBar;

- (id)init {
  if (self = [super initWithFrame:CGRectZero]) {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
  }
  return self;
}


- (void)setUpPickerView:(CGRect) frame {
  if (pickerView == nil) {
    pickerView = [[UIPickerView alloc] initWithFrame:frame];
  }
  CGSize pickerSize = [pickerView sizeThatFits:CGSizeZero];
  CGRect pickerRect = CGRectMake(frame.origin.x, frame.size.height - pickerSize.height,
                                 pickerSize.width, pickerSize.height);
  pickerView.frame = pickerRect;
  pickerView.delegate = self.pickerDelegate;
  pickerView.showsSelectionIndicator = YES;
  [self addSubview:pickerView];
}


- (void)setUpSearchBar:(CGRect) frame {
  if (searchBar == nil) {
    searchBar = [[UISearchBar alloc] initWithFrame:frame];
  }
  CGSize searchSize = [searchBar sizeThatFits:CGSizeZero];
  CGRect searchRect = CGRectMake(frame.origin.x, frame.size.height-pickerView.frame.size.height-searchSize.height,
                                 searchSize.width, searchSize.height);
  searchBar.frame = searchRect;
  searchBar.delegate = self.searchBarDelegate;
  searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  //searchBar.keyboardType = UIKeyboardTypeNumberPad;
  [self addSubview:searchBar];
}


- (void)dealloc {
  [pickerView release];
  [searchBar release];
  [super dealloc];
}


- (void)showInView:(UIView *)view {
  [self setUpPickerView:view.frame];
  [self setUpSearchBar:view.frame];
  self.frame = view.frame;
  
  CGRect origFrame = pickerView.frame;
  CGSize size = origFrame.size;
  CGRect searchFrame = searchBar.frame;
  CGSize searchSize = searchFrame.size;
  CGRect startFrame = CGRectMake(origFrame.origin.x, view.frame.size.height + searchSize.height, size.width, size.height);
  pickerView.frame = startFrame;
  
  CGRect searchStartFrame = CGRectMake(searchFrame.origin.x, view.frame.size.height, searchSize.width, searchSize.height);
  searchBar.frame = searchStartFrame;
  
  [view.superview addSubview:self];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.5];
  
  self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  pickerView.frame = origFrame;
  searchBar.frame = searchFrame;
  
  [UIView commitAnimations];
}


- (void)hide {
  if ([searchBar isFirstResponder]) {
    [searchBar resignFirstResponder];
  }
  CGRect frame = pickerView.frame;
  CGSize size = frame.size;
  CGRect searchFrame = searchBar.frame;
  CGSize searchSize = searchFrame.size;
  CGRect endFrame = CGRectMake(frame.origin.x, self.frame.size.height + searchSize.height, size.width, size.height);
  CGRect searchEndFrame = CGRectMake(searchFrame.origin.x, self.frame.size.height, searchSize.width, searchSize.height);
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.5];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

  pickerView.frame = endFrame;
  searchBar.frame = searchEndFrame;
  self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
  
  [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
  [self removeFromSuperview];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [searchBar resignFirstResponder];
}


@end
