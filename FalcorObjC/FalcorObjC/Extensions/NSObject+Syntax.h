//
//  NSObject+Syntax.h
//  FalcorObjC
//
//  Created by Raymond Kim on 1/3/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JSONGraphSentinalAtom,
    JSONGraphSentinalError,
    JSONGraphSentinalRef,
    JSONGraphSentinalPrimitive
} JSONGraphSentinalType;

typedef enum : NSUInteger {
    JSONObjectType,
    JSONArrayType,
    JSONValueType
} JSONType;

typedef enum : NSUInteger {
    JSONGraphObject,
    JSONGraphSentinal,
} JSONGraphType;

typedef NSArray<NSString *> *JSONPathKeySet;
typedef NSArray<JSONPathKeySet> *JSONPathSet;

@interface NSObject (Syntax)

@property (readonly, nonatomic, assign) JSONGraphType jsonGraphType;

@property (readonly, nonatomic, assign) JSONGraphSentinalType jsonGraphSentinalType;

@property (readonly, nonatomic, assign) JSONType jsonType;

@property (readonly, nonatomic, nonnull) NSArray *jsonGraphSentinalRefValue;
@property (readonly, nonatomic, nonnull) NSDictionary *jsonGraphSentinalAtomValue;
@property (readonly, nonatomic, nonnull) NSString *jsonGraphSentinalErrorValue;

@end

