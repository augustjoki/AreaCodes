//
//  Area_CodesAppDelegate.h
//  Area Codes
//
//  Created by August Joki on 4/20/08.
//  Copyright Concinnous Software 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

@interface Area_CodesAppDelegate : NSObject <UIApplicationDelegate> {

	IBOutlet UIWindow *window;
	UINavigationController *navigationController;

  sqlite3 *database;
  
	NSArray *displayList;
  NSArray *indexList;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

- (NSString *)dataFilePath;
//- (void)saveData;

@property (nonatomic, copy, readonly) NSArray *displayList;
@property (nonatomic, copy, readonly) NSArray *indexList;

- (NSUInteger)countOfDisplayList;
- (id)objectInDisplayListAtIndex:(NSUInteger)theIndex;
- (void)getDisplayList:(id *)objsPtr range:(NSRange)range;
- (NSUInteger)indexInDisplayListAtIndex:(NSUInteger)theIndex nearCode:(NSString *)code;
- (NSUInteger)countOfIndexList;
- (id)objectInIndexListAtIndex:(NSUInteger)theIndex;
- (void)getIndexList:(id *)objsPtr range:(NSRange)range;

@end

