//
//  NSObject+Syntax.m
//  FalcorObjC
//
//  Created by Raymond Kim on 1/3/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import "NSObject+Syntax.h"


NSString * const syntaxType = @"$type";
NSString * const syntaxValue = @"value";
NSString * const syntaxRef = @"ref";
NSString * const syntaxError = @"error";
NSString * const syntaxAtom = @"atom";


@implementation NSObject (Syntax)

-(JSONGraphType) jsonGraphType {
    
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonGraph = (NSDictionary *) self;
        if (jsonGraph[syntaxType] != nil) {
            return JSONGraphSentinal;
        }
        
        return JSONGraphObject;
    }
    
    return JSONGraphSentinal;
}

-(JSONGraphSentinalType) jsonGraphSentinalType {
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonGraph = (NSDictionary *) self;
        if (jsonGraph[syntaxType] != nil) {
            
            if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxRef] == NSOrderedSame)
                return JSONGraphSentinalRef;
            else if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxError] == NSOrderedSame)
                return JSONGraphSentinalError;
            else if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxAtom] == NSOrderedSame)
                return JSONGraphSentinalAtom;

        }
    }
    
    return JSONGraphSentinalPrimitive;
}

-(NSArray *)jsonGraphSentinalRefValue {
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonGraph = (NSDictionary *) self;
        if (jsonGraph[syntaxType] != nil) {
            
            if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxRef] == NSOrderedSame) {
                NSArray *refPath = jsonGraph[syntaxValue];
                NSMutableArray *boxedRefPath = [NSMutableArray array];
                for (NSString *key in refPath) {
                    [boxedRefPath addObject:@[key]];
                }
                return boxedRefPath;
            }
            
        }
    }
    
    return @[];
}

- (NSDictionary *)jsonGraphSentinalAtomValue {
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonGraph = (NSDictionary *) self;
        if (jsonGraph[syntaxType] != nil) {
            
            if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxAtom] == NSOrderedSame) {
                return  jsonGraph[syntaxValue];
            }
            
        }
    }
    
    return @{};
}

- (NSString *)jsonGraphSentinalErrorValue {
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonGraph = (NSDictionary *) self;
        if (jsonGraph[syntaxType] != nil) {
            
            if ([jsonGraph[syntaxType] caseInsensitiveCompare:syntaxError] == NSOrderedSame) {
                return  jsonGraph[syntaxValue];
            }
            
        }
    }
    
    return nil;
}

@end

