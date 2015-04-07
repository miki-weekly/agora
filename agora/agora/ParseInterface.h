//
//  ParseInterface.h
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface ParseInterface : NSObject
    + (NSArray*) browseKeyArray;
    + (void) saveNewPostToParse: (Post*) post completion:(void (^)(BOOL succeeded))block;
    + (void) updateParsePost: (Post*) post;
    + (Post*) getFromParseIndividual: (NSString*) object_id;
    + (void) getFromParse: (NSString*) parameter withSkip: (NSInteger) skip completion:(void (^)(NSArray* result))block;
    + (void) deleteFromParse: (NSString*) object_id;
    + (void) getHeaderPhoto: (NSString*) object_id completion: (void(^)(UIImage* result))block;
    + (void) getThumbnail: (NSString*) object_id completion: (void (^)(UIImage* result))block;
@end