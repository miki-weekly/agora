//
//  ParseInterface.m
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseInterface.h"

@implementation ParseInterface

+ (NSArray*) browseKeyArray {
    return @[@"objectId", @"title", @"category", @"price", @"thumbnail", @"createdBy"];
}

+ (void) saveNewPostToParse: (Post*) post {
    //Saving an image to Parse
    
    PFObject *parsePost = [PFObject objectWithClassName:@"Posts"];
    
    //Changing header image to PFFile for storage in Parse
    NSData *imageData = UIImageJPEGRepresentation(post.headerPhoto, 1.0);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    //Converting secondary photos to PFFile
    NSMutableArray *PFFileArray = [NSMutableArray array];
    for (UIImage *image in post.photosArray) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
        [PFFileArray addObject:[PFFile fileWithData: imageData]];
    }
    
    parsePost[@"picture"] = imageFile;
    parsePost[@"pictures"] = PFFileArray;
    parsePost[@"createdBy"] = [PFUser currentUser];
    parsePost[@"title"] = post.title;
    parsePost[@"description"] = post.itemDescription;
    parsePost[@"category"] = post.category;
    if (post.stringTags != nil) {
        parsePost[@"tags"] = post.stringTags;
    }
    if (post.price != nil) {
        parsePost[@"price"] = post.price;
    }
    
    [parsePost saveInBackground];
}

+ (void) updateParsePost: (Post*) post {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    
    [query whereKey:@"objectId" equalTo: post.objectId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            NSLog(@"OBJECT FOUND");
            NSData *image = UIImageJPEGRepresentation(post.headerPhoto, 1.0);
            PFFile *imageFile = [PFFile fileWithData:image];
            
            [object setObject: post.title forKey:@"title"];
            [object setObject: post.title forKey:@"description"];
            [object setObject: post.title forKey:@"category"];
            [object setObject: imageFile forKey:@"photo"];
            [object setObject: post.stringTags forKey:@"tags"];
            [object setObject: post.price forKey:@"price"];
            [object setObject: [PFUser currentUser] forKey:@"createdBy"];
            
            [object saveInBackground];
            NSLog(@"OBJECT UPDATED!");
        } else {
            NSLog(@"UPDATE: NO OBJECT FOUND");
        }
    }];
}

+ (Post*) getFromParseIndividual: (NSString*) object_id {
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    Post *post = [[Post alloc]init];
    
    [query includeKey:@"createdBy"];
    
    PFObject *object = [query getObjectWithId:object_id];
    
    NSLog(@"Retrieved Data");
    
    PFUser *user = [object objectForKey:@"createdBy"];

    PFFile *file = [object objectForKey:@"picture"];
    post.headerPhoto = [UIImage imageWithData:[file getData]];
    
    NSArray* picturesPFFileArray = [object objectForKey:@"pictures"];
    NSMutableArray *picturesUIImageArray = [NSMutableArray array];
    
    for (PFFile *picture in picturesPFFileArray) {
        [picturesUIImageArray addObject: [UIImage imageWithData: [picture getData]]];
    }
    
    post.title = [object objectForKey:@"title"];
    post.itemDescription = [object objectForKey:@"description"];
    post.category = [object objectForKey:@"category"];
    post.price = [object objectForKey:@"price"];
    post.objectId = [object objectForKey:@"objectId"];
    post.creatorFacebookId = [user objectForKey:@"facebookId"];
    post.photosArray = picturesUIImageArray;
    
    return post;
}

+ (void) getFromParse: (NSString*) parameter withSkip: (NSInteger) skip completion:(void (^)(NSArray* result))block;{
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
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject* object in objects) {
            Post *post = [[Post alloc] init];
            PFUser *user = [object objectForKey:@"createdBy"];

            PFFile *file = [object objectForKey:@"thumbnail"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                post.thumbnail = [UIImage imageWithData:data];
            }];
            
            post.title = [object objectForKey:@"title"];
            post.price = [object objectForKey:@"price"];
            post.category = [object objectForKey:@"category"];
            post.objectId = object.objectId;
            post.creatorFacebookId = [user objectForKey:@"facebookId"];
            
            [postArray addObject:post];
        }
        // Finally, pass array to block
        block(postArray);
    }];
}

@end
