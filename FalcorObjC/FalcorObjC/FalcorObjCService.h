//
//  FalcorObjCService.h
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FalcorObjCService : NSObject

- (nullable NSDictionary *)getJSONGraph:(nonnull NSDictionary *)jsonGraph path:(nonnull NSArray<NSArray<NSString *> *>*)jsonPath;

@end
