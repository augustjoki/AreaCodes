//
//  Area_CodesAppDelegate.m
//  Area Codes
//
//  Created by August Joki on 4/20/08.
//  Copyright Nokia Research 2008. All rights reserved.
//

#import "Area_CodesAppDelegate.h"
#import "RootViewController.h"
#import "AreaCode.h"

NSString *DATA_FILENAME = @"calldata.db";


@interface Area_CodesAppDelegate ()
@property (nonatomic, copy, readwrite) NSArray *displayList;
@property (nonatomic, copy, readwrite) NSArray *indexList;
- (void)initializeDatabase;
@end

@implementation Area_CodesAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize displayList;
@synthesize indexList;


- init {
  if (self = [super init]) {
  // Initialization code
  }
  return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
  
  [self initializeDatabase];
  
  // Create the navigation and view controllers
  RootViewController *rootViewController = [[RootViewController alloc] init];
  UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
  self.navigationController = aNavigationController;
  [aNavigationController release];
  [rootViewController release];
  
  // Configure and show the window
  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // "dehydrate" all data objects - flushes changes back to the database, removes objects from memory
    for (NSDictionary *dict in displayList) {
      [[dict objectForKey:@"codes"] makeObjectsPerformSelector:@selector(dehydrate)];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
  if (sqlite3_close(database) != SQLITE_OK) {
      NSLog(@"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
  }
}


- (void)initializeDatabase {
  NSString *dataFilePath = [self dataFilePath];
  //BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:dataFilePath];
  if (sqlite3_open([dataFilePath UTF8String], &database) == SQLITE_OK) {
    NSMutableArray *codes = [[NSMutableArray alloc] init];
    const char *sql = "SELECT npa FROM npa";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
      while (sqlite3_step(statement) == SQLITE_ROW) {
        char *code = (char *)sqlite3_column_text(statement, 0);
        [codes addObject:[NSString stringWithCString:code]];
      }
    }
    sqlite3_finalize(statement);
    
    NSMutableDictionary *sectionedCodes = [[NSMutableDictionary alloc] init];
    
    for (NSString *code in codes) {
      NSString *first = [code substringToIndex:1];
      NSMutableArray *codeArray = [sectionedCodes objectForKey:first];
      if (codeArray == nil) {
        codeArray = [[NSMutableArray alloc] init];
        [sectionedCodes setObject:codeArray forKey:first];
        [codeArray release];
      }
      AreaCode *areaCode = [[AreaCode alloc] initWithCode:code database:database];
      [codeArray addObject:areaCode];
      [areaCode release];
    }
    [codes release];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.indexList = [[sectionedCodes allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *first in indexList) {
      NSMutableArray *codeArray = [sectionedCodes objectForKey:first];
      [codeArray sortUsingSelector:@selector(localizedCompare:)];
      
      NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:first, @"first", codeArray, @"codes", nil];
      [list addObject:dict];
      [dict release];
    }
    
    self.displayList = list;
    [sectionedCodes release];
    [list release];
  }
  else {
    sqlite3_close(database);
  }
}


- (NSString *)dataFilePath {
#if !defined(TARGET_OS_IPHONE) || defined(TARGET_IPHONE_SIMULATOR)
  NSString *dataFilePath = @"/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator2.0.sdk/System/Library/PrivateFrameworks/AppSupport.framework/calldata.db";
  //NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
  //NSString *dataFilePath = [resourcePath stringByAppendingPathComponent:DATA_FILENAME];
#else
  NSString *dataFilePath = @"/System/Library/Frameworks/AppSupport.framework/calldata.db";
#endif
  /*
  static NSString *dataFilePath = nil;
  if (dataFilePath != nil) {
    return dataFilePath;
  }
  */
  //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  //NSString *documentsDirectory = [paths objectAtIndex:0];
  //dataFilePath = [[documentsDirectory stringByAppendingPathComponent:DATA_FILENAME] retain];
  //dataFilePath = [DATA_FILENAME copy];
  return dataFilePath;
}


- (void)setDisplayList:(NSArray *)newList {
  if (displayList != newList) {
    [displayList release];
    displayList = [newList mutableCopy];
  }
}

- (void)setIndexList:(NSArray *)newList {
  if (indexList != newList) {
    [indexList release];
    indexList = [newList mutableCopy];
  }
}

- (NSUInteger)countOfDisplayList {
    return [displayList count];
}

- (NSUInteger)countOfIndexList {
    return [indexList count];
}

- (id)objectInDisplayListAtIndex:(NSUInteger)theIndex {
    return [displayList objectAtIndex:theIndex];
}

- (void)getDisplayList:(id *)objsPtr range:(NSRange)range {
    [displayList getObjects:objsPtr range:range];
}

- (NSUInteger)indexInDisplayListAtIndex:(NSUInteger)theIndex nearCode:(NSString *)code {
  NSDictionary *dict = [self objectInDisplayListAtIndex:theIndex];
  AreaCode *ac = [[AreaCode alloc] initProxyWithCode:code];
  NSArray *array = [dict objectForKey:@"codes"];
  NSUInteger index = [array indexOfObject:ac];
  [ac release];
  if (index == NSNotFound) {
    index = [array count] - 1;
    for (AreaCode *areaCode in array) {
      NSComparisonResult result = [areaCode.code localizedCompare:code];
      if (result == NSOrderedSame || result == NSOrderedDescending) {
        index = [array indexOfObject:areaCode];
        break;
      }
    }
  }
  return index;
}

- (id)objectInIndexListAtIndex:(NSUInteger)theIndex {
    return [indexList objectAtIndex:theIndex];
}

- (void)getIndexList:(id *)objsPtr range:(NSRange)range {
    [indexList getObjects:objsPtr range:range];
}


- (void)dealloc {
  [navigationController release];
  [window release];
  [displayList release];
  [indexList release];
  [super dealloc];
}

@end
