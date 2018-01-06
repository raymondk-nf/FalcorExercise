//
//  NSDictionary+jsonGraphMerge.h
//  FalcorObjC
//
//  Created by Raymond Kim on 1/3/18.
//  Copyright © 2018 Netflix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (jsonGraphMerge)
- (NSDictionary *)deepMergeJSONGraph:(NSDictionary *)otherJsonGraph;
@end
