//
//  FalcorObjCClient.h
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Syntax.h"

@interface FalcorObjCClient : NSObject

- (id)getJSON:(nonnull NSDictionary *)jsonGraph pathSet:(nonnull JSONPathSet)pathSet;


@end
