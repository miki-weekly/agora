//
//  Post.h
//  agora
//
//  Created by Cang Truong on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Post : NSObject

@property NSString *title;
@property NSString *itemDescription;
@property NSString *category;
@property NSString *objectId;
@property NSArray *stringTags; //Array of strings
@property NSNumber *price;
@property UIImage *headerPhoto;
@property UIImage *thumbnail;
@property NSString *creatorFacebookId;
@property NSArray *photosArray; //Array of UIImages

@end
