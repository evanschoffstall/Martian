//
//  AppDelegate.h
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MAOutlineController.h"
#import "MASaveController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet MAOutlineController * outlineController;

@end
