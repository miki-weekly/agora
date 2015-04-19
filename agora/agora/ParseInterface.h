//
//  ParseInterface.h
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Conversation.h"
#import "Message.h"

@interface ParseInterface : NSObject
//Post Class Parse Interface
    + (NSArray*) browseKeyArray;
    + (void) saveNewPostToParse: (Post*) post completion:(void (^)(BOOL succeeded))block;
    + (void) updateParsePost: (Post*) post completion:(void (^)(BOOL succeeded))block;
    + (Post*) getFromParseIndividual: (NSString*) object_id ;
    + (void) getFromParse: (NSString*) parameter withSkip: (NSInteger) skip completion:(void (^)(NSArray* result))block;
    + (void) deleteFromParse: (NSString*) object_id;
    + (void) getHeaderPhotoForPost: (Post*)post completion: (void(^)(UIImage* result))block;
    + (void) getThumbnail: (NSString*) object_id completion: (void (^)(UIImage* result))block;
    + (void) getPhotosArrayWithObjectID:(NSString*)objectID completion:(void (^)(NSArray* result))block;
//Conversations & Messages Parse Interface
    + (void) getConversations:(void (^)(NSArray* result))block;
    + (void) getMessagesOfConversation: (Conversation*) conversation AfterDate: (NSDate*) date completion:(void (^)(NSArray* result))block;
    + (void) saveMessage: (Message*) message InConversation: (Conversation*) conversation;
@end