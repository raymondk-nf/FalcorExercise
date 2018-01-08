//
//  NSMutableDictionary+jsonGraphMerge.m
//  FalcorObjC
//
//  Created by Raymond Kim on 1/3/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import "NSMutableDictionary+jsonGraphMerge.h"

@implementation NSMutableDictionary (jsonGraphMerge)

- (void)deepMergeJSONGraph:(NSDictionary *)otherJsonGraph {
    
    [otherJsonGraph enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]
            && [self[key] isKindOfClass:[NSDictionary class]]) {

            NSDictionary *valueDictionary = obj;
            NSMutableDictionary *existingDictionary = [NSMutableDictionary dictionaryWithDictionary: self[key]];
            [existingDictionary deepMergeJSONGraph:valueDictionary];
            self[key] = existingDictionary;
        } else {
            self[key] = obj;
        }
    }];
    
}


@end
