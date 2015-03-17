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

@end
