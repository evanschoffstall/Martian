//
//  MAPostController.m
//  Martian
//
//  Created by Evan Schoffstall on 9/14/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MAPostController.h"

@implementation MAPostController

@synthesize dataController, wantsToDestoryOldData;
@synthesize data, _tableView;

#pragma mark -
#pragma mark Intialization

- (id)init
{
    if (self == [super self])
    {
        data = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary * postData = data[row][@"data"];
    
    NSString * title = postData[@"title"];
    NSString * url = postData[@"url"];
    NSString * author = postData[@"author"];
    
    NSTableCellView * cell = [_tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    
    NSTextField * titleField = [cell viewWithTag:0];
    NSTextField * URLField = [cell viewWithTag:1];
    
    if (title)  [titleField setStringValue:title];
    if (url)    [URLField setStringValue:[url stringByAppendingFormat:@"\nPosted by: %@",author]];
    
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [data count];
}

#pragma mark -
#pragma mark MADataControllerDelegate

- (void)dataControllerHasNewData:(NSDictionary *)dictionary
{
    if (!dictionary) return;
    
    if (!wantsToDestoryOldData)
    {
        [data addObjectsFromArray:dictionary[@"data"][@"children"]];
    }
    else
    {
        [self setData:dictionary[@"data"][@"children"]];
        wantsToDestoryOldData = NO;
    }
    
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Super Controller Accessors

- (void)outlineViewSelectionDidChange:(MAItemNode*)item
{
    wantsToDestoryOldData = YES;
    
    NSString * title = [item title];
    NSDictionary * properties = [NSDictionary new];
    
    NSString * basicRequestURL = [NSString stringWithFormat:@"http://www.reddit.com/r/%@/new.json?sort=new",title];
    
    if (title == @"Frontpage")  properties = @{@"requestURL" : @"http://www.reddit.com/hot/.json", @"requestMethod": @"GET"};
    else if (title == @"Inbox") properties = @{@"requestURL" : @"http://www.reddit.com/message/inbox.json", @"requestMethod": @"GET"};
    else                        properties = @{@"requestURL" : basicRequestURL, @"requestMethod": @"GET"};
    
    [dataController fetchASynchronousDatawithProperties:properties];
}

#pragma mark -

@end
