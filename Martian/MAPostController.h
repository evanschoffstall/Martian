//
//  MAPostController.h
//  Martian
//
//  Created by Evan Schoffstall on 9/14/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MADataController.h"
#import "NSOutlineView+Additions.h"

@interface MAPostController : NSObject <MADataControllerDelegate, NSTableViewDataSource, NSTableViewDelegate>

#pragma mark -
#pragma mark NSTableViewDataSource

@property (assign) IBOutlet NSTableView * _tableView;
@property (strong) NSMutableArray * data;

#pragma mark -
#pragma mark MADataController

@property (assign) BOOL wantsToDestoryOldData;
@property (assign) IBOutlet MADataController * dataController;

#pragma mark -
#pragma mark Super Controller Accessors

- (void)outlineViewSelectionDidChange:(MAItemNode*)item;

#pragma mark -

@end
