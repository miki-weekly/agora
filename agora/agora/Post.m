//
//  Post.m
//  agora
//
//  Created by Tony Chen on 3/22/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "Post.h"
#import "ParseInterface.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation Post : NSObject

- (void)postToFacebook{
	if([self fbPostID])
		return;
	
	//https://developers.facebook.com/docs/graph-api/reference/v2.3/group/feed
	// UC Merced Classifieds ID = 246947172002847
	
	NSString* message = [NSString stringWithFormat:@"%@ - $%@\n\n%@", [self title], [self price], [self itemDescription]];
	// TODO: UGGLY COOOOODEEEEE
	if(![self headerPhotoURL]){
		[ParseInterface getHeaderPhotoForPost:self completion:^(UIImage *result) {
			NSDictionary *params = @{@"message": message,
									 @"url": [self headerPhotoURL],};
			
			FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/1571489843128589/photos" parameters:params HTTPMethod:@"POST"];
			[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
				if(!error){
					[self setFbPostID:[result objectForKey:@"post_id"]];
					[ParseInterface updateParsePost:self completion:^(BOOL succeeded) {
					}];
				}else
					NSLog(@"%@", error);
			}];

		}];
	}else{
		NSDictionary *params = @{@"message": message,
								 @"url": [self headerPhotoURL],};
		
		FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/1571489843128589/photos" parameters:params HTTPMethod:@"POST"];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
			if(!error)
				[self setFbPostID:[result objectForKey:@"id"]];
			else
				NSLog(@"%@", error);
		}];
	}
	
}

- (void)deletePost{
	if([self fbPostID]){
		FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@", [self fbPostID]] parameters:nil HTTPMethod:@"DELETE"];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
		}];
	}
	
	[ParseInterface deleteFromParse:[self objectId]];
}

@end
