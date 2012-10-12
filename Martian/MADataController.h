//
//  MADataController.h
//  Martian
//
//  Created by Evan Schoffstall on 9/12/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADataControllerDelegateProtocol.h"

@interface MADataController : NSObject <NSURLConnectionDataDelegate>

@property (assign) IBOutlet NSObject <MADataControllerDelegate> * delegate;
@property (assign) BOOL wantsData;

@property (strong) NSMutableData * responseData;
@property (strong) NSURLConnection * requestConnection;

- (NSMutableDictionary*)fetchSynchronousDatawithProperties:(NSDictionary*)properties;
- (void)fetchASynchronousDatawithProperties:(NSDictionary*)properties;

@end
