//
//  FalcorObjCService.m
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import "FalcorObjCService.h"
#import "NSMutableDictionary+jsonGraphMerge.h"


typedef void (^GetJsonGraphCompletionBlock)(NSDictionary *jsonGraph, NSArray *optimizedPaths);


@interface JsonGraphOptimizedPathsTuple :NSObject
@property (nonatomic, nullable) NSDictionary *jsonGraph;
@end
@implementation JsonGraphOptimizedPathsTuple

- (instancetype)initWithJsonGraph:(NSDictionary *)jsonGraph
{
    self = [super init];
    if (self) {
        self.jsonGraph = jsonGraph;
    }
    return self;
}

-(NSString *)debugDescription {
    return [NSString stringWithFormat:@"%@, jsonGraph: %@", self, self.jsonGraph];
}
@end

@interface FalcorObjCService ()

@end


@implementation FalcorObjCService

- (nullable NSDictionary *)getJSONGraph:(nonnull NSDictionary *)jsonGraph path:(nonnull JSONPathSet)jsonPath; {
    
    NSMutableArray *optimizedPaths = [NSMutableArray array];
    NSMutableDictionary *buildJsonGraph = [NSMutableDictionary dictionary];
    
    [optimizedPaths addObject:jsonPath];
    
    while (optimizedPaths.count > 0) {
        
        // Grab first pathSet
        NSArray *pathSet = [optimizedPaths firstObject];
        [optimizedPaths removeObjectAtIndex:0];
        
        JsonGraphOptimizedPathsTuple *tupleResult = [self getJSONGraph:jsonGraph pathSet:pathSet optimizedPaths:&optimizedPaths];
        [buildJsonGraph deepMergeJSONGraph:tupleResult.jsonGraph];
        
    }
    
    return buildJsonGraph;
}


//TODO: - Pass a dictionary by reference and build
- (JsonGraphOptimizedPathsTuple *)getJSONGraph:(nullable NSDictionary*)jsonGraph pathSet:(JSONPathKeySet)pathSet optimizedPaths:(NSMutableArray **)optimizedPaths {
    
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
                    JsonGraphOptimizedPathsTuple *tuple = [[JsonGraphOptimizedPathsTuple alloc] initWithJsonGraph:@{}];
                    [tupleArray addObject:tuple];
                } else {
                    
                    JsonGraphOptimizedPathsTuple *tuple;
                    if (subGraph.jsonGraphType == JSONGraphSentinal
                        && subGraph.jsonGraphSentinalType == JSONGraphSentinalPrimitive) {
                        
                        tuple = [[JsonGraphOptimizedPathsTuple alloc] initWithJsonGraph:@{ pathKey : subGraph }];
                    } else {
                    
                        tuple = [self getJSONGraph:subGraph pathSet:pathSubSlice optimizedPaths:optimizedPaths];
                        tuple.jsonGraph = @{pathKey : tuple.jsonGraph };
                    }
                    [tupleArray addObject:tuple];
                }
            }
            
            NSMutableDictionary *buildJsonGraph = [NSMutableDictionary dictionary];
            
            for (JsonGraphOptimizedPathsTuple *tuple in tupleArray) {
                [buildJsonGraph addEntriesFromDictionary:tuple.jsonGraph];
                
            }
            
            JsonGraphOptimizedPathsTuple *returnTuple = [[JsonGraphOptimizedPathsTuple alloc] initWithJsonGraph:buildJsonGraph];
            return returnTuple;
            
        }
            break;
            
        case JSONGraphSentinal: {
            switch (jsonGraph.jsonGraphSentinalType) {
                case JSONGraphSentinalPrimitive:
                case JSONGraphSentinalAtom:
                case JSONGraphSentinalError: {
                    JsonGraphOptimizedPathsTuple *tuple = [[JsonGraphOptimizedPathsTuple alloc] initWithJsonGraph:jsonGraph];
                    return tuple;
                }
                    break;

                case JSONGraphSentinalRef: {
                    JsonGraphOptimizedPathsTuple *tuple = [JsonGraphOptimizedPathsTuple new];
                    tuple.jsonGraph = jsonGraph;
                    if (pathSet.count > 0) {
                        [*optimizedPaths addObject: [jsonGraph.jsonGraphSentinalRefValue arrayByAddingObjectsFromArray:pathSet] ];
                    }
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
