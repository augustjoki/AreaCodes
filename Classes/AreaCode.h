//
//  AreaCode.h
//  Area Codes
//
//  Created by August Joki on 4/21/08.
//  Copyright 2008 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "/usr/include/sqlite3.h"

@interface AreaCode : NSObject {
  sqlite3_stmt *state_statement; // npa
  sqlite3_stmt *area_statement; // npalocation
  sqlite3_stmt *prefix_statement; // npanxx
  sqlite3_stmt *city_statement; // citycode
  
  sqlite3 *database;
  
  NSString *code;
  NSString *area;
  NSString *state;
  NSString *country;
  
  BOOL hydrated;
}

@property (copy, nonatomic, readonly) NSString *code;
@property (copy, nonatomic, readonly) NSString *area;
@property (copy, nonatomic, readonly) NSString *state;
@property (copy, nonatomic, readonly) NSString *country;


- (id)initWithCode:(NSString *)code database:(sqlite3 *)db;
- (id)initProxyWithCode:(NSString *)code;

- (NSArray *)prefixes;
- (NSString *)cityWithPrefix:(NSString *)prefix;

- (NSComparisonResult)localizedCompare:(AreaCode *)areaCode;

- (void)hydrate;
- (void)dehydrate;

@end
