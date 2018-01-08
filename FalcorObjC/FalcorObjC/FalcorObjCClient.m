//
//  FalcorObjCClient.m
//  FalcorObjC
//
//  Created by Raymond Kim on 12/21/17.
//  Copyright © 2017 Netflix. All rights reserved.
//

#import "FalcorObjCClient.h"

@implementation FalcorObjCClient


- (id)getJSON:(nonnull NSDictionary *)jsonGraph pathSet:(nonnull JSONPathSet)pathSet {
    
    return [self getJSON:jsonGraph pathSet:pathSet rootJsonGraph:jsonGraph];
}

- (id)getJSON:(NSDictionary *)jsonGraph pathSet:(JSONPathSet)pathSet rootJsonGraph:(NSDictionary *)rootJsonGraph {
    switch (jsonGraph.jsonGraphType) {
        case JSONGraphObject: {
            
            if (pathSet.count == 0)  {
                @throw([NSException exceptionWithName:@"invalid attempt" reason:@"Invalid attempt to retrieve non-primitive value" userInfo:nil]);
            }
            
            NSMutableArray *pathSubSlice = [pathSet mutableCopy];
            NSArray *pathKeySet = pathSubSlice.firstObject;
            
            if (pathSubSlice.count > 0)
                [pathSubSlice removeObjectAtIndex:0];
            
            NSMutableDictionary *buildDictionary = [NSMutableDictionary dictionary];
            for (NSString *pathKey in pathKeySet) {
                
                NSDictionary *subGraph = jsonGraph[pathKey];
                

                if (subGraph == nil) {
                    // Do nothing
                } else if (subGraph.jsonGraphType == JSONGraphSentinal
                        && subGraph.jsonGraphSentinalType == JSONGraphSentinalPrimitive) {
                        
                    buildDictionary[pathKey]  = subGraph;
                        
                }else {
                    buildDictionary[pathKey] = [self getJSON:subGraph pathSet:pathSubSlice rootJsonGraph:rootJsonGraph];
                }
            }
            
            return buildDictionary;
        }
            break;
            
        case JSONGraphSentinal: {
            
            id result = [self processSentinal:jsonGraph subPathSlice:pathSet rootJsonGraph:rootJsonGraph];
            return (result) ?: ([jsonGraph isEqual:rootJsonGraph]) ? @{} : nil;
        }
            break;
    }
}

- (id)processSentinal:(NSDictionary *)sentinalJson subPathSlice:(NSArray <JSONPathKeySet> *)subPathSlice rootJsonGraph:(NSDictionary *)rootJsonGraph {
    
    switch (sentinalJson.jsonGraphSentinalType) {
        case JSONGraphSentinalAtom:
            return sentinalJson.jsonGraphSentinalAtomValue;
            break;
        case JSONGraphSentinalError: {
            NSString *errorString = sentinalJson.jsonGraphSentinalErrorValue;
            @throw [NSException exceptionWithName:@"Falcor Error" reason:errorString userInfo:nil];
        }
            break;
        case JSONGraphSentinalRef: {
            if (subPathSlice.count == 0)
                return nil;
            
            NSArray *refPath = sentinalJson.jsonGraphSentinalRefValue;
            
            NSDictionary *resolvedJsonGraph = [self resolveJsonPathReference:rootJsonGraph refPath:refPath rootJsonGraph:rootJsonGraph];
            
            if (resolvedJsonGraph == nil) {
                return @{};
            } else {
                return [self getJSON:resolvedJsonGraph pathSet:subPathSlice rootJsonGraph:rootJsonGraph];
            }
            
        }
            break;
        case JSONGraphSentinalPrimitive:
            
            break;
    }
    
    return nil;
}

-(NSDictionary *)resolveJsonPathReference:(NSDictionary *)jsonGraph refPath:(NSArray<NSString *>*)refPath rootJsonGraph:(NSDictionary *)rootJsonGraph {

    switch (jsonGraph.jsonGraphType) {

        case JSONGraphObject: {
            
            if (refPath.count > 0) {
                NSMutableArray *mutableRefPath = [refPath mutableCopy];
                NSArray *pathKeySet = mutableRefPath.firstObject;
                NSString *pathKey = pathKeySet.firstObject;

                [mutableRefPath removeObjectAtIndex:0];

                NSDictionary *subGraph = jsonGraph[pathKey];
                
                if (subGraph == nil) {
                    return jsonGraph;
                } else {
                    return [self resolveJsonPathReference:subGraph refPath:mutableRefPath rootJsonGraph:rootJsonGraph];
                }
            
            } else {
                return jsonGraph;
            }
            
        }
            break;
        case JSONGraphSentinal:
            
            switch (jsonGraph.jsonGraphSentinalType) {
                case JSONGraphSentinalAtom:
                case JSONGraphSentinalError:
                case JSONGraphSentinalPrimitive:

                    return jsonGraph;
                    
                case JSONGraphSentinalRef: {
                    NSArray *refPath = jsonGraph.jsonGraphSentinalRefValue;
                    return [self resolveJsonPathReference:rootJsonGraph refPath:refPath rootJsonGraph:rootJsonGraph];
                }
                    break;
            }
            break;
    }
    
    return nil;
    
}

@end
