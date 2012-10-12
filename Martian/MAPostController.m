//
//  MAPostController.m
//  Martian
//
//  Created by Evan Schoffstall on 9/14/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MAPostController.h"

@implementation MAPostController

@synthesize lastProperties, nextPageIdentifier;
@synthesize dataController, wantsToDestoryOldData;
@synthesize data, _tableView;

#pragma mark -
#pragma mark Intialization

- (id)init
{
    if (self == [super self])
    {
        [self setData:[NSMutableArray new]];
        [self allowBoundsNotification:YES];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSDictionary * postData = data[row][@"data"];
    
    NSString * title = postData[@"title"];
    NSString * author = postData[@"author"];
    NSString * unixtime = postData[@"created"];
    
    NSDate * unformattedDate = [NSDate dateWithTimeIntervalSince1970:[unixtime integerValue]];
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"MM/dd/YY"];
    
    NSString * date = [dateFormatter stringFromDate:unformattedDate];
    
    MAPostCellView * cell = [_tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];

    NSTextField * titleField = [cell viewWithTag:0];
    NSTextField * detailField = [cell viewWithTag:1];
    
    if (author && date && title)
    {
        [titleField setStringValue:title];
        [detailField setStringValue:[author stringByAppendingFormat:@" | %@",date]];
    }
    
    return cell;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [data count];
}

- (void)boundsDidChange:(NSNotification*)notification
{
    if ([[notification object] isEqualTo:[[_tableView enclosingScrollView] contentView]])
    {
        float scrollValue = [[[_tableView enclosingScrollView] contentView] bounds].origin.y;
        float threshholdPoint = ([_tableView frame].size.height-[[[_tableView enclosingScrollView] contentView] bounds].size.height)*0.90;
        
        if (scrollValue >= threshholdPoint)
        {
            [self allowBoundsNotification:NO];
            [self setWantsToDestoryOldData:NO];
            [dataController setWantsData:YES];
            [lastProperties setValue:@"requestURL" forKey:[lastProperties[@"requestURL"] stringByAppendingFormat:@"%@",nextPageIdentifier]];
            [dataController fetchASynchronousDatawithProperties:lastProperties];
        }
    }
}

- (void)allowBoundsNotification:(BOOL)flag
{
    if (flag)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(boundsDidChange:)
                                                     name:NSViewBoundsDidChangeNotification
                                                   object:[[_tableView enclosingScrollView] contentView]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewBoundsDidChangeNotification
                                                      object:[[_tableView enclosingScrollView] contentView]];
    }
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
    
    [self setNextPageIdentifier:dictionary[@"data"][@"after"]];
    [_tableView reloadData];
    [self allowBoundsNotification:YES];
    [dataController setWantsData:NO];
}

#pragma mark -
#pragma mark Super Controller Accessors

// MAItemNode should eventually have a requestURL build in so I can call it, verses static setting
- (void)outlineViewSelectionDidChange:(MAItemNode*)item
{
    [self setWantsToDestoryOldData:YES];
    [dataController setWantsData:YES];
    
    NSString * title = [item title];
    NSDictionary * properties = [NSDictionary new];
    
    NSString * basicRequestURL = [NSString stringWithFormat:@"http://www.reddit.com/r/%@/new.json?sort=new",title];
    
    if (title == @"Frontpage")  properties = @{@"requestURL" : @"http://www.reddit.com/hot/.json", @"requestMethod": @"GET"};
    else if (title == @"Inbox") properties = @{@"requestURL" : @"http://www.reddit.com/message/inbox.json", @"requestMethod": @"GET"};
    else                        properties = @{@"requestURL" : basicRequestURL, @"requestMethod": @"GET"};
    
    lastProperties = [NSMutableDictionary dictionaryWithDictionary:properties];

    [dataController fetchASynchronousDatawithProperties:properties];
}

#pragma mark -

@end
