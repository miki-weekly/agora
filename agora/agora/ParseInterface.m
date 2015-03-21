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

- (NSArray*) getFromParseListByCategory: (NSString*) category AndSkipBy: (int) skip {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    NSMutableArray *postArray = [NSMutableArray array];
    
    [query setSkip:skip];
    [query setLimit:20];
    [query includeKey:@"createdBy"];
    [query selectKeys: [ParseInterface browseKeyArray]];
    [query whereKey:@"category" equalTo:category];
    
    NSArray *objectsArray = [query findObjects];
    NSLog(@"Retrieved Data");
        
    for(int i = 0; i < objectsArray.count; i++) {
        PFObject *object = objectsArray[i];
        Post *post;
        
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

- (NSArray*) getFromParseListRecents: (int) skip {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    NSMutableArray *postArray = [NSMutableArray array];

    [query setSkip:skip];
    [query setLimit:20];
    [query includeKey:@"createdBy"];
    [query selectKeys: [ParseInterface browseKeyArray]];
    [query orderByAscending:@"createdAt"];
    
    NSArray *objectsArray = [query findObjects];
    NSLog(@"Retrieved Data");
        
    for(int i = 0; i < objectsArray.count; i++) {
        PFObject *object = objectsArray[i];
        Post *post;
        
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

- (NSArray*) getFromParseListUserPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    NSMutableArray* postsArray = [NSMutableArray array];
    
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query selectKeys: [ParseInterface browseKeyArray]];
    [query includeKey:@"createdBy"];

    NSArray *objectsArray = [query findObjects];
    
    for (int i = 0; i < objectsArray.count; i++) {
        PFObject *object = objectsArray[i];
        Post *post;
        
        PFFile *file = [object objectForKey:@"thumbnail"];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            post.thumbnail = [UIImage imageWithData:data];
        }];
        
        post.title = [object objectForKey:@"title"];
        post.price = [object objectForKey:@"price"];
        post.category = [object objectForKey:@"category"];
        post.objectId = [object objectForKey:@"objectId"];
        post.creator = [object objectForKey:@"createdBy"];
        
        [postsArray addObject:post];
    }
    
    return postsArray;
}
@end
