//
//  FalcorObjCModel.m
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import "FalcorObjCModel.h"

@implementation FalcorObjCModel

- (NSDictionary *)jsonGraph {
    
    return @{ @"list" : @{
                        @0: @{ @"$type": @"ref", @"value": @[@"videosById", @22 ] },
                        @1: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] },
                        @2: @{
                                @0: @{ @"$type": @"ref", @"value": @[@"videosById", @44 ] }
                                },
                        @3: @{ @"$type": @"ref", @"value": @[@"videosById", @66 ] },
                        @4: @{ @"$type": @"ref", @"value": @[@"videosById", @88 ] },
                        @5: @{ @"$type": @"ref", @"value": @[@"episodesById", @23 ] },
                        @-1: @{ @"$type": @"ref", @"value": @[@"list", @1 ] },
                        @"length": @6
                        },
              @"videosById": @{
                      @22: @{
                              @"name": @"Die Hard",
                              @"rating": @5,
                              @"bookmark": @{ @"$type": @"atom", @"value": @73973 }
                              },
                      @44: @{
                              @"name": @"Get Out",
                              @"rating": @5,
                              @"bookmark": @{ @"$type": @"error", @"value": @"Couldn’t retrieve bookmark" }
                              },
                      @66: @{
                              @"name": @"Stranger Things",
                              @"rating": @1,
                              @"bookmark": @{ @"$type": @"atom", @"value": @123 }
                              },
                      @88: @{
                              @"name": @"The Crown",
                              @"rating": @3,
                              @"bookmark": @{ @"$type": @"error", @"value": @"Couldn’t retrieve bookmark" }
                              }
                      },
              @"episodesById": @{ @"$type": @"atom", @"value": @73973 },
              @"supportedLanguages": @{ @"$type": @"atom", @"value": @[@"fr",@"en"] }
              };
}

@end
