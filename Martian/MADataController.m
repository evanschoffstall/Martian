//
//  MADataController.m
//  Martian
//
//  Created by Evan Schoffstall on 9/12/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MADataController.h"

#import "SBJason/SBJson.h"
#import "NSString+Additions.h"

@implementation MADataController
@synthesize delegate;

- (id)init
{
    if (self == [super self])
    {
        
    }
    
    return self;
}

- (NSDictionary*)fetchSynchronousDatawithProperties:(NSDictionary*)properties
{
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[properties[@"requestURL"] URLValue]];
    NSData * requestBody = [properties[@"requestBody"] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:properties[@"requestMethod"]];
    [request setValue:@"Objective-C Reddit Client using JSON" forHTTPHeaderField:@"User-Agent"];
    if (requestBody) [request setHTTPBody:requestBody];
    
    NSData * requestedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary * requestedDictionary = [[SBJsonParser new] objectWithData:requestedData];
    
    NSArray * errors = requestedDictionary[@"json"][@"errors"];
    
    if ([errors count] != 0)
    {
        [NSException raise:@"There was an error fetching data" format:@"%@", errors];
        return nil;
    }
    
    return requestedDictionary;
}

- (void)fetchASynchronousDatawithProperties:(NSDictionary*)properties
{
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
         
         if ([delegate respondsToSelector:@selector(dataControllerHasNewData:)])
         {
             NSDictionary * requestedDictionary = [self fetchSynchronousDatawithProperties:properties];
             [delegate dataControllerHasNewData:requestedDictionary];
         }
     });
}

@end
