//
//  ParseInterface.m
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>
#import "Post.h"
#import "ParseInterface.h"

@implementation ParseInterface

+ (NSArray*) browseKeyArray {
    return @[@"objectId", @"title", @"price", @"thumbnail", @"createdBy"];
}

- (void) saveNewPostToParse: (Post*) post {
    //Saving an image to Parse
    
    PFObject *parsePost = [PFObject objectWithClassName:@"Posts"];
    
    //Changing UIImage to PFFile for storage in Parse
    NSData *image = UIImageJPEGRepresentation(post.photo, 1.0);
    PFFile *imageFile = [PFFile fileWithData:image];
    
    //Getting current user for for createdBy relation
    PFUser *user = [PFUser currentUser];
    
    parsePost[@"picture"] = imageFile;
    parsePost[@"createdBy"] = user;
    parsePost[@"title"] = post.title;
    parsePost[@"description"] = post.description;
    parsePost[@"category"] = post.category;
    parsePost[@"tags"] = post.stringTags;
    parsePost[@"price"] = post.price;
    
    [parsePost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"File Uploaded");
        } else {
            NSLog(@"File NOT Uploaded");
        }
    }];
}

- (Post*) getFromParseIndividual: (NSString*) object_id {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    Post *post;
    
    [query includeKey:@"createdBy"];
    [query whereKey:@"objectId" equalTo: object_id];
    
    PFObject *object = [query getFirstObject];
    NSLog(@"Retrieved Data");
    
    post.title = [object objectForKey:@"title"];
    post.description = [object objectForKey:@"description"];
    post.category = [object objectForKey:@"category"];
    post.price = [object objectForKey:@"price"];
    post.objectId = [object objectForKey:@"objectId"];
    post.creator = [object objectForKey:@"createdBy"];
    
    return post;
}

- (NSArray*) getFromParseListByCategory: (NSString*) category AndSkipBy: (NSInteger) skip {
    
    return [self getFromParse:category List:skip];
}

- (NSArray*) getFromParseListRecents: (NSInteger) skip {
    
    return [self getFromParse: @"RECENTS" List:skip];
}

- (NSArray*) getFromParseListUserPosts {
    
    return [self getFromParse: @"USER" List: 0];
}

-(NSArray*) getFromParse: (NSString*) parameter List: (NSInteger) skip{
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    NSMutableArray *postArray = [NSMutableArray array];

    if ([parameter isEqual: @"RECENTS"]) { //Getting most recent posts
        [query setSkip:skip];
        [query setLimit:20];
        [query includeKey:@"createdBy"];
        [query selectKeys: [ParseInterface browseKeyArray]];
        [query orderByAscending:@"createdAt"];
        
    } else if ([parameter isEqual:@"USER"]) { //Getting the user's posts
        [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
        [query selectKeys: [ParseInterface browseKeyArray]];
        [query includeKey:@"createdBy"];
        
    } else { //Getting the post by category
        [query setSkip:skip];
        [query setLimit:20];
        [query includeKey:@"createdBy"];
        [query selectKeys: [ParseInterface browseKeyArray]];
        [query whereKey:@"category" equalTo:parameter];
        
    }
    NSArray *objectsArray = [query findObjects];

    for(PFObject* object in objectsArray) {
        Post *post = [[Post alloc] init];
        
        PFFile *file = [object objectForKey:@"thumbnail"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            post.thumbnail = [UIImage imageWithData:data];
        }];
        
        post.title = [object objectForKey:@"title"];
        post.price = [object objectForKey:@"price"];
        post.category = [object objectForKey:@"category"];
        post.objectId = [object objectForKey:@"objectId"];
        post.creator = [object objectForKey:@"createdBy"];
        
        [postArray addObject:post];
    }
    
    return postArray;
}

@end
