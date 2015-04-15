//
//  Post.m
//  agora
//
//  Created by Tony Chen on 3/22/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "Post.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation Post : NSObject

- (NSString*)postToFacebook{
	if([self fbPostID])
		return nil;
	NSString* message = [NSString stringWithFormat:@"%@ - $%@\n\n%@", [self title], [self price], [self itemDescription]];
	NSDictionary *params = @{@"message": message,
							 @"source": [UIImage imageNamed:@"Test"],};
	
	FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/1571489843128589/feed" parameters:params HTTPMethod:@"POST"];
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
		[self setFbPostID:[result objectForKey:@"id"]];
		
	}];
	
	return  @"";
}

@end

