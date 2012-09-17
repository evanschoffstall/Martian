//
//  MADataControllerDelegate.h
//  Martian
//
//  Created by Evan Schoffstall on 9/12/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MADataControllerDelegate <NSObject>
@required
- (void)dataControllerHasNewData:(NSDictionary*)dictionary;

@end
