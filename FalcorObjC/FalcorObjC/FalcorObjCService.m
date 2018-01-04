//
//  FalcorObjCService.m
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import "FalcorObjCService.h"
#import "NSMutableDictionary+jsonGraphMerge.h"
#import "NSObject+Syntax.h"


typedef void (^GetJsonGraphCompletionBlock)(NSDictionary *jsonGraph, NSArray *optimizedPaths);


@interface JsonGraphOptimizedPathsTuple :NSObject
@property (nonatomic, nullable) NSDictionary *jsonGraph;
@property (nonatomic, nullable) NSArray *optimizedPaths;
@end
@implementation JsonGraphOptimizedPathsTuple

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@, jsonGraph: %@, optimizedPaths: %@", self, self.jsonGraph, self.optimizedPaths];
}
@end

@interface FalcorObjCService ()

@end


@implementation FalcorObjCService

- (nullable NSDictionary *)getJSONGraph:(nonnull NSDictionary *)jsonGraph path:(nonnull NSArray<NSArray<NSString *> *>*)jsonPath {
    
    NSMutableArray *optimizedPaths = [NSMutableArray array];
    NSMutableDictionary *buildJsonGraph = [NSMutableDictionary dictionary];
    
    [optimizedPaths addObject:jsonPath];
    
    while (optimizedPaths.count > 0) {
        
        // Grab first pathSet
        NSMutableArray *pathSet = [optimizedPaths firstObject];
        [optimizedPaths removeObjectAtIndex:0];
        
        JsonGraphOptimizedPathsTuple *tupleResult = [self getJSONGraph:jsonGraph pathSet:pathSet];
        if (tupleResult.optimizedPaths != nil) {
            [optimizedPaths addObjectsFromArray:tupleResult.optimizedPaths];
        }
        
        if (tupleResult.jsonGraph) {
            buildJsonGraph = [buildJsonGraph deepMergeJSONGraph:tupleResult.jsonGraph];
        }
        
    }
    
    return buildJsonGraph;
}

- (JsonGraphOptimizedPathsTuple *)getJSONGraph:(nullable NSDictionary*)jsonGraph pathSet:(NSArray*)pathSet {
    
    switch (jsonGraph.jsonGraphType) {
        case JSONGraphObject: {
            
            if (pathSet.count == 0)  { @throw([NSException exceptionWithName:@"invalid attempt" reason:@"Invalid attempt to retrieve non-primitive value" userInfo:nil]); }
            
            NSMutableArray *pathSubSlice = [pathSet mutableCopy];
            NSArray *pathKeySet = pathSubSlice.firstObject;
            
            if (pathSubSlice.count > 0)
                [pathSubSlice removeObjectAtIndex:0];
            
            NSMutableArray<JsonGraphOptimizedPathsTuple *> *tupleArray = [NSMutableArray array];
            for (NSString *pathKey in pathKeySet) {
                
                NSDictionary *subGraph = jsonGraph[pathKey];
                if (subGraph == nil) {
                    JsonGraphOptimizedPathsTuple *tuple = [JsonGraphOptimizedPathsTuple new];
                    tuple.jsonGraph = @{};
                    [tupleArray addObject:tuple];
                } else {
                    
                    JsonGraphOptimizedPathsTuple *tuple;
                    if (subGraph.jsonGraphType == JSONGraphSentinal && subGraph.jsonGraphSentinalType == JSONGraphSentinalPrimitive) {
                        tuple = [JsonGraphOptimizedPathsTuple new];
                        tuple.jsonGraph = @{ pathKey : subGraph };
                    } else {
                    
                        tuple = [self getJSONGraph:subGraph pathSet:pathSubSlice];
                        tuple.jsonGraph = @{pathKey : tuple.jsonGraph };
                    }
                    [tupleArray addObject:tuple];
                }
            }
            
            NSMutableDictionary *buildJsonGraph = [NSMutableDictionary dictionary];
            NSMutableArray *buildOptimizedPaths = [NSMutableArray array];
            
            for (JsonGraphOptimizedPathsTuple *tuple in tupleArray) {
                [buildJsonGraph addEntriesFromDictionary:tuple.jsonGraph];
                
                for (NSArray *optPath in tuple.optimizedPaths) {
                    [buildOptimizedPaths addObject:optPath];
                }
                
            }
            
            JsonGraphOptimizedPathsTuple *returnTuple = [JsonGraphOptimizedPathsTuple new];
            returnTuple.jsonGraph = buildJsonGraph;
            returnTuple.optimizedPaths = buildOptimizedPaths;
            return returnTuple;
            
        }
            break;
            
        case JSONGraphSentinal: {
            switch (jsonGraph.jsonGraphSentinalType) {
                case JSONGraphSentinalPrimitive:
                case JSONGraphSentinalAtom:
                case JSONGraphSentinalError: {
                    JsonGraphOptimizedPathsTuple *tuple = [JsonGraphOptimizedPathsTuple new];
                    tuple.jsonGraph = jsonGraph;
                    return tuple;
                }
                    break;

                case JSONGraphSentinalRef: {
                    JsonGraphOptimizedPathsTuple *tuple = [JsonGraphOptimizedPathsTuple new];
                    tuple.jsonGraph = jsonGraph;
                    tuple.optimizedPaths = (pathSet.count > 0) ? @[ [jsonGraph.jsonGraphSentinalRefValue arrayByAddingObjectsFromArray:pathSet] ] : nil;
                    return tuple;
                }
                    break;
            }
        }
            break;
    }
    
    return nil;
}

@end
