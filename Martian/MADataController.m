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
@synthesize responseData, requestConnection, wantsData;
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
    NSDictionary * requestedDictionary = [self jsonDataToDictionary:requestedData];
    
    return requestedDictionary;
}

- (void)fetchASynchronousDatawithProperties:(NSDictionary*)properties
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[properties[@"requestURL"] URLValue]];
    
    [request setValue:@"A reddit client using JSON for OS X" forHTTPHeaderField:@"User-Agent"];
    
    if (!requestConnection)
        requestConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (NSDictionary*)jsonDataToDictionary:(NSData*)data
{
    NSMutableDictionary * requestedDictionary = [[SBJsonParser new] objectWithData:data];
    
    NSArray * errors = requestedDictionary[@"json"][@"errors"];
    
    if ([errors count] != 0)
    {
        [NSException raise:@"There was an error fetching data" format:@"%@", errors];
        return nil;
    }
    
    return requestedDictionary;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [requestConnection cancel];
    requestConnection = nil;
    
    NSDictionary * requestedDictionary = [self jsonDataToDictionary:responseData];
    
    if ([delegate respondsToSelector:@selector(dataControllerHasNewData:)]) [delegate dataControllerHasNewData:requestedDictionary];
    
    responseData = nil;
    wantsData = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self setResponseData:[NSMutableData new]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (wantsData)
        [responseData appendData:data];
    else
        requestConnection = nil;
}

@end
