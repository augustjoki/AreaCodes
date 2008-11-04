//
//  AreaCodeCell.h
//  Area Codes
//
//  Created by August Joki on 4/22/08.
//  Copyright 2008 Nokia Research. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AreaCodeCell : UITableViewCell {
  UILabel *codeLabel;
  UILabel *infoLabel;
}

@property (nonatomic, assign, readonly) UILabel *codeLabel, *infoLabel;

- (void)setCodeText:(NSString *)code;
- (void)setInfoText:(NSString *)info;

@end
