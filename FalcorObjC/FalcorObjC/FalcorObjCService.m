//
//  FalcorObjCService.m
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import "FalcorObjCService.h"
#import "NSMutableDictionary+jsonGraphMerge.h"

@implementation FalcorObjCService

- (nullable NSDictionary *)getJSONGraph:(nonnull NSDictionary *)jsonGraph path:(nonnull JSONPathSet)jsonPath; {
    
    NSMutableArray *optimizedPaths = [NSMutableArray array];
    NSMutableDictionary *resultJsonGraph = [NSMutableDictionary dictionary];
    
    [optimizedPaths addObject:jsonPath];
    
    while (optimizedPaths.count > 0) {
        
        NSArray *pathSet = [optimizedPaths firstObject];
        [optimizedPaths removeObjectAtIndex:0];
        
        [self getJSONGraph:jsonGraph pathSet:pathSet buildJsonGraph:&resultJsonGraph optimizedPaths:&optimizedPaths];
    }
    
    return resultJsonGraph;
}


//TODO: - Pass a dictionary by reference and build
- (void)getJSONGraph:(nullable NSDictionary*)jsonGraph pathSet:(JSONPathKeySet)pathSet buildJsonGraph:(NSMutableDictionary **)buildJsonGraph optimizedPaths:(NSMutableArray **)optimizedPaths {
    
    switch (jsonGraph.jsonGraphType) {
        case JSONGraphObject: {
            
            if (pathSet.count == 0)  { @throw([NSException exceptionWithName:@"invalid attempt" reason:@"Invalid attempt to retrieve non-primitive value" userInfo:nil]); }
            
            NSMutableArray *pathSubSlice = [pathSet mutableCopy];
            NSArray *pathKeySet = pathSubSlice.firstObject;
            
            if (pathSubSlice.count > 0)
                [pathSubSlice removeObjectAtIndex:0];
            
            for (NSString *pathKey in pathKeySet) {
                
                NSDictionary *subGraph = jsonGraph[pathKey];
                if (subGraph == nil) {
                    [*buildJsonGraph addEntriesFromDictionary:@{}];
                } else {
                    
                    if (subGraph.jsonGraphType == JSONGraphSentinal
                        && subGraph.jsonGraphSentinalType == JSONGraphSentinalPrimitive) {
                        
                        [*buildJsonGraph addEntriesFromDictionary: @{ pathKey : subGraph } ];
                    } else {
                    
                        // This replaces the deep merging call
                        NSMutableDictionary *anotherDictionary = ((*buildJsonGraph)[pathKey]);
                        if (anotherDictionary == nil) {
                            anotherDictionary = [NSMutableDictionary dictionary];
                            (*buildJsonGraph)[pathKey] = anotherDictionary;
                        }
                        
                        [self getJSONGraph:subGraph pathSet:pathSubSlice buildJsonGraph:&anotherDictionary optimizedPaths:optimizedPaths];
                    }
                }
            }
        }
            break;
            
        case JSONGraphSentinal: {
            switch (jsonGraph.jsonGraphSentinalType) {
                case JSONGraphSentinalPrimitive:
                case JSONGraphSentinalAtom:
                case JSONGraphSentinalError: {
                    [*buildJsonGraph addEntriesFromDictionary:jsonGraph];
                }
                    break;

                case JSONGraphSentinalRef: {
                    [*buildJsonGraph addEntriesFromDictionary:jsonGraph];
                    if (pathSet.count > 0) {
                        [*optimizedPaths addObject: [jsonGraph.jsonGraphSentinalRefValue arrayByAddingObjectsFromArray:pathSet] ];
                    }
                }
                    break;
            }
        }
            break;
    }
}

@end
