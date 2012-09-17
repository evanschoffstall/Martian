//
//  MASaveController.m
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MASaveController.h"
#import "AppDelegate.h"

@implementation MASaveController

- (id)init
{
    if (self == [super self])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:[self databasePath]])
        {
            [fileManager createFileAtPath:[self databasePath] contents:nil attributes:nil];
            [NSKeyedArchiver archiveRootObject:[NSMutableDictionary new] toFile:[self databasePath]];
        }
        else
        {
            [NSKeyedUnarchiver unarchiveObjectWithFile:[self databasePath]];
        }
    }
    
    return self;
}

- (NSString*)databasePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.database"];
}

- (NSMutableDictionary*)database
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self databasePath]];
}

- (void)setObject:(id)object forKey:(id)key
{
    NSMutableDictionary * database = [self database];
    database[key] = object;
    [NSKeyedArchiver archiveRootObject:database toFile:[self databasePath]];
}

+ (id)sharedInstance
{
    static id sharedInstance = NULL;
    if(!sharedInstance) sharedInstance = [[self alloc] init];
        return sharedInstance;
}

@end
