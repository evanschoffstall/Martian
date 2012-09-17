//
//  MASaveController.h
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MASaveController : NSObject

- (NSString*)databasePath;
- (NSMutableDictionary*)database;
- (void)setObject:(id)object forKey:(id)key;

+ (MASaveController*)sharedInstance;
//+ (MASaveController*)sharedSaveController;

@end
