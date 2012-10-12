//
//  AppDelegate.m
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize outlineController;
@synthesize window;

#pragma mark -
#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [[outlineController _outlineView] restoreState];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self save];
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
    [self save];
}

#pragma mark -
#pragma mark Saving

- (void)save
{
    [[MASaveController sharedInstance] setObject:outlineController forKey:@"outlineController"];
}

#pragma mark -

@end
