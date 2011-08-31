//
//  AreaCodeCell.m
//  Area Codes
//
//  Created by August Joki on 4/22/08.
//  Copyright 2008 Concinnous Software. All rights reserved.
//

#import "AreaCodeCell.h"


@implementation AreaCodeCell

@synthesize codeLabel, infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      codeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      codeLabel.backgroundColor = [UIColor clearColor];
      codeLabel.opaque = YES;
      codeLabel.textColor = [UIColor blackColor];
      codeLabel.highlightedTextColor = [UIColor whiteColor];
      codeLabel.font = [UIFont boldSystemFontOfSize:24];
      [self addSubview:codeLabel];
      [codeLabel release];
      
      infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      infoLabel.backgroundColor = [UIColor clearColor];
      infoLabel.opaque = YES;
      infoLabel.textColor = [UIColor darkGrayColor];
      infoLabel.highlightedTextColor = [UIColor lightGrayColor];
      infoLabel.font = [UIFont systemFontOfSize:16];
      [self addSubview:infoLabel];
      [infoLabel release];
    }
    return self;
}

- (void)dealloc {
  [codeLabel release];
  [infoLabel release];
  [super dealloc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  codeLabel.highlighted = selected;
  codeLabel.opaque = !selected;
  
  infoLabel.highlighted = selected;
  infoLabel.opaque = !selected;
  
}


- (void)layoutSubviews {
  const float LEFT_COLUMN_OFFSET = 10.0;
  const float LEFT_COLUMN_WIDTH = 50.0;
  
  const float RIGHT_COLUMN_OFFSET = LEFT_COLUMN_WIDTH + 10.0;
  //const float RIGHT_COLUMN_WIDTH = 130.0;
  
  const float UPPER_ROW_TOP = 0.0;
  //const float LOWER_ROW_TOP = 32.0;
  
  [super layoutSubviews];
  
  CGRect contentRect = self.contentView.bounds;
  CGFloat originX = contentRect.origin.x;
  CGFloat originY = contentRect.origin.y;
  CGFloat sizeW = contentRect.size.width;
  CGFloat sizeH = contentRect.size.height;
  CGRect frame;
  
  frame = CGRectMake(originX + LEFT_COLUMN_OFFSET, originY + UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, sizeH-4.0);
  codeLabel.frame = frame;
  
  frame = CGRectMake(originX + RIGHT_COLUMN_OFFSET, originY + UPPER_ROW_TOP + 2.0, sizeW - LEFT_COLUMN_WIDTH, sizeH-4.0);
  infoLabel.frame = frame;
}


/*
- (void)drawRect:(CGRect)rect {
	// insert drawing code here
	
}
*/

- (void)setCodeText:(NSString *)code {
  codeLabel.text = code;
}

- (void)setInfoText:(NSString *)info {
  infoLabel.text = info;
}

@end
