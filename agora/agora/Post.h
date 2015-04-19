//
//  Post.h
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Post : NSObject

@property NSString *title;
@property NSString *itemDescription;
@property NSString *category;
@property NSString *objectId;
@property NSArray *stringTags; //Array of strings
@property NSNumber *price;

@property PFUser *createdBy;
@property NSString *creatorFacebookId;
@property NSString* fbPostID;

@property UIImage *thumbnail;
@property UIImage *headerPhoto;
@property NSArray *photosArray; //Array of UIImages

@property NSString *headerPhotoURL;

- (void)postToFacebook;

@end
