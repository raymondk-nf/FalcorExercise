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
    JSONGraphObject,
    JSONGraphSentinal,
} JSONGraphType;


@interface NSObject (Syntax)

@property (readonly, nonatomic, assign) JSONGraphType jsonGraphType;

@property (readonly, nonatomic, assign) JSONGraphSentinalType jsonGraphSentinalType;

@property (readonly, nonatomic, nonnull) NSArray *jsonGraphSentinalRefValue;

@end

