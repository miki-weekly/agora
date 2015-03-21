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

- (void) saveToParse: (Post*) post {
    //Saving an image to Parse
    
    PFObject *parsePost = [PFObject objectWithClassName:@"Posts"];
    
    NSData *image = UIImageJPEGRepresentation(post.photo, 1.0);
    PFFile *imageFile = [PFFile fileWithData:image];

    parsePost[@"picture"] = imageFile;
    //post[@"createdBy"] = @"Bob";
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
    
    [query whereKey:@"objectId" equalTo: object_id];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSLog(@"Retrieved Data");
        
        Post *post;
        
        post.title = [object objectForKey:@"title"];
        post.description = [object objectForKey:@"description"];
        post.category = [object objectForKey:@"category"];
        post.price = [object objectForKey:@"price"];
        post.objectId = [object objectForKey:@"objectId"];
        post.creator = [object objectForKey:@"createdBy"];
    }];
    return nil;
}

- (NSArray*) getFromParseListByCategory: (NSString*) category AndSkipBy: (int) skip {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    [query setSkip:skip];
    [query setLimit:20];
    [query selectKeys: [ParseInterface browseKeyArray]];
    [query whereKey:@"category" equalTo:category];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieved Data");
        NSMutableArray *postArray = [NSMutableArray array];
        
        for(int i = 0; i < objects.count; i++) {
            PFObject *object = objects[i];
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
    }];
    
    return nil;
}

-(NSArray*) getFromParseListRecents: (int) skip {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    [query setSkip:skip];
    [query setLimit:20];
    [query selectKeys: [ParseInterface browseKeyArray]];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Retrieved Data");
        NSMutableArray *postArray = [NSMutableArray array];
        
        for(int i = 0; i < objects.count; i++) {
            PFObject *object = objects[i];
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
    }];
    return nil;
}
@end
