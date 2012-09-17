//
//  MAOutlineController.h
//  Martian
//
//  Created by Evan Schoffstall on 9/10/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSOutlineView+Additions.h"
#import "MAPostController.h"

@interface MAOutlineController : NSObject <NSOutlineViewDataSource, NSOutlineViewDelegate, NSTextFieldDelegate, NSCoding>

#pragma mark -
#pragma mark NSOutlineViewDataSource

@property (strong) NSMutableArray * data;                            // Contains MAItemNode objects
@property (strong) MAItemNode     * lastSelectedItem;                // The last selected item

@property (assign) IBOutlet NSOutlineView * _outlineView;

#pragma mark -
#pragma mark Sub Controls

@property (assign) IBOutlet MAPostController * postController;

#pragma mark -
#pragma mark NSMenu

@property (assign) IBOutlet NSMenu * itemMenu;
@property (assign) IBOutlet NSMenu * headerMenu;

- (NSMenu*)menuForEvent:(NSEvent*)event;
- (IBAction)addSubscripton:(id)sender;
- (IBAction)removeSubscripton:(id)sender;

#pragma mark -



@end
