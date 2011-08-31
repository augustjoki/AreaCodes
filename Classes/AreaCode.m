//
//  AreaCode.m
//  Area Codes
//
//  Created by August Joki on 4/21/08.
//  Copyright 2008 Concinnous Software. All rights reserved.
//

#import "AreaCode.h"


@interface AreaCode ()

@property (copy, nonatomic, readwrite) NSString *code;
@property (copy, nonatomic, readwrite) NSString *area;
@property (copy, nonatomic, readwrite) NSString *state;
@property (copy, nonatomic, readwrite) NSString *country;

@end

@implementation AreaCode

@synthesize code, area, state, country;

- (id)initWithCode:(NSString *)cd database:(sqlite3 *) db {
  if (self = [super init]) {
    self.code = cd;
    database = db;
    
    //[self hydrate];
  }
  return self;
}

- (id)initProxyWithCode:(NSString *)cd {
  if (self = [super init]) {
    self.code = code;
  }
  return self;
}


- (void)hydrate {
  if (hydrated) {
    return;
  }
  
  if (state_statement == nil) {
    const char *sql = "SELECT location, country FROM npa WHERE npa=?";
    if (sqlite3_prepare_v2(database, sql, -1, &state_statement, NULL) != SQLITE_OK) {
      NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
  }
  sqlite3_bind_text(state_statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
  if (sqlite3_step(state_statement) == SQLITE_ROW) {
    char *cn = (char *)sqlite3_column_text(state_statement, 1);
    if (cn) {
      self.country = [NSString stringWithUTF8String:cn];
    }
    else {
      self.country = nil;
    }
    char *st = (char *)sqlite3_column_text(state_statement, 0);
    if (st) {
      if (cn == nil) { // state is country if country is empty
        self.country = [NSString stringWithUTF8String:st];
        self.state = nil;
      }
      else {
        self.state = [NSString stringWithUTF8String:st];
      }
    }
    else {
      self.state = nil;
    }
  } else {
    self.state = nil;
    self.country = nil;
  }
  sqlite3_reset(state_statement);
  
  if (area_statement == nil) {
    const char *sql = "SELECT location FROM npalocation WHERE npa=?";
    if (sqlite3_prepare_v2(database, sql, -1, &area_statement, NULL) != SQLITE_OK) {
      NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
  }
  sqlite3_bind_text(area_statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
  if (sqlite3_step(area_statement) == SQLITE_ROW) {
    char *ar = (char *)sqlite3_column_text(area_statement, 0);
    if (ar) {
      self.area = [NSString stringWithUTF8String:ar];
    }
    else {
      self.area = nil;
    }
  } else {
    self.area = nil;
  }
  sqlite3_reset(area_statement);
  
  hydrated = YES;
  
}


- (void)dehydrate {
  [area release];
  area = nil;
  [state release];
  state = nil;
  [country release];
  country = nil;
  
  hydrated = NO;
}


- (NSArray *)prefixes {
  if (prefix_statement == nil) {
    const char *sql = "SELECT nxx FROM npanxx WHERE npa=?";
    if (sqlite3_prepare_v2(database, sql, -1, &prefix_statement, NULL) != SQLITE_OK) {
      NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
  }
  sqlite3_bind_text(prefix_statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  while (sqlite3_step(prefix_statement) == SQLITE_ROW) {
    char *pfx = (char *)sqlite3_column_text(prefix_statement, 0);
    [array addObject:[NSString stringWithUTF8String:pfx]];
  }
  sqlite3_reset(prefix_statement);
  return [array autorelease];
}

- (NSString *)cityWithPrefix:(NSString *)prefix {
  if (city_statement == nil) {
    const char *sql = "SELECT city FROM citycode, npanxx WHERE npa=? AND nxx=? AND rate_center=code";
    if (sqlite3_prepare_v2(database, sql, -1, &city_statement, NULL) != SQLITE_OK) {
      NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
  }
  sqlite3_bind_text(city_statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_text(city_statement, 2, [prefix UTF8String], -1, SQLITE_TRANSIENT);
  
  NSString *city;
  if (sqlite3_step(city_statement) == SQLITE_ROW) {
    char *cy = (char *)sqlite3_column_text(city_statement, 0);
    city = [NSString stringWithUTF8String:cy];
  }
  else {
    city = nil;
  }
  sqlite3_reset(city_statement);
  return city;
}


- (void)dealloc {
  if (state_statement) {
    sqlite3_finalize(state_statement);
  }
  if (area_statement) {
    sqlite3_finalize(area_statement);
  }
  if (prefix_statement) {
    sqlite3_finalize(prefix_statement);
  }
  if (city_statement) {
    sqlite3_finalize(city_statement);
  }
  [code release];
  [area release];
  [state release];
  [country release];
  [super dealloc];
}


- (NSComparisonResult)localizedCompare:(AreaCode *)areaCode {
  return [code localizedCompare:areaCode.code];
}


- (BOOL)isEqual:(AreaCode *)ac {
  return self.code == ac.code;
}


@end
