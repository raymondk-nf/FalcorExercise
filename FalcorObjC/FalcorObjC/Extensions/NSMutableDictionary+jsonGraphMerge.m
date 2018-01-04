//
//  NSMutableDictionary+jsonGraphMerge.m
//  FalcorObjC
//
//  Created by Raymond Kim on 1/3/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import "NSMutableDictionary+jsonGraphMerge.h"

@implementation NSMutableDictionary (jsonGraphMerge)

- (NSMutableDictionary *)deepMergeJSONGraph:(NSDictionary *)otherJsonGraph {
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [otherJsonGraph enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]
            && [resultDictionary[key] isKindOfClass:[NSDictionary class]]) {

            NSDictionary *valueDictionary = obj;
            NSMutableDictionary *existingDictionary = [NSMutableDictionary dictionaryWithDictionary: resultDictionary[key]];
            NSMutableDictionary *merged = [existingDictionary deepMergeJSONGraph:valueDictionary];
            resultDictionary[key] = merged;
        } else {
            resultDictionary[key] = obj;
        }
    }];

    return resultDictionary;
    
}


@end
