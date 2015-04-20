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
	
	NSMutableString* message = [NSMutableString stringWithFormat:@"%@ - $%@", [self title], [self price]];
	if([self itemDescription])
	   [message appendFormat:@"\n\n%@", [self itemDescription]];
	
	FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/1571489843128589/photos" parameters:@{} HTTPMethod:@"POST"];
	if(![self headerPhotoURL]){
		[ParseInterface getHeaderPhotoForPost:self completion:^(UIImage *result) {
			[[request parameters] addEntriesFromDictionary:@{@"message": message,
															@"url": [self headerPhotoURL],}];
			
			[self startPostToFBWithRequest:request];
		}];
	}else{
		[[request parameters] addEntriesFromDictionary:@{@"message": message,
															@"url": [self headerPhotoURL],}];
		
		[self startPostToFBWithRequest:request];
	}
	
}

- (void)startPostToFBWithRequest:(FBSDKGraphRequest*)request{
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
		if(!error){
			[self setFbPostID:[result objectForKey:@"post_id"]];
			[ParseInterface updateParsePost:self completion:^(BOOL succeeded) {
			}];
		}else
			NSLog(@"%@", error);
	}];
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
