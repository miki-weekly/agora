//
//  LoginViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init{
    if((self = [super init])){
        [self setFields:PFLogInFieldsFacebook];
		[self setFacebookPermissions:@[@"public_profile", @"user_friends", @"user_education_history", @"user_groups"]];
		[self setDelegate:self];
		/*
		//https://developers.facebook.com/docs/graph-api/reference/v2.3/group/feed
		// UC Merced Classifieds ID = 246947172002847
		FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/246947172002847/feed" parameters:nil];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
			NSLog(@"%@", result);
			
		}];
		
		NSDictionary *params = @{@"message": @"test",};
		
		request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/246947172002847/feed" parameters:params HTTPMethod:@"POST"];
		[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
			NSLog(@"%@", result);
			
		}];
		 */
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    // TODO: Configure Login here, Set logo?
    //UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    UILabel * agora = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 200.0, 300.0, 70.0)];
    agora.textAlignment = NSTextAlignmentCenter;
    [agora setFont:[UIFont systemFontOfSize:60.0]];
    [agora setText:@"Agora"];
    
    self.logInView.logo = NULL;
    [self.logInView addSubview:agora];
}

- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

//https://www.parse.com/docs/ios_guide#sessions-handleerror/iOS

- (BOOL)userLoggedIn{
    PFUser* cUser = [PFUser currentUser];
    FBSDKAccessToken* cAccessToken = [FBSDKAccessToken currentAccessToken];
    NSLog(@"Parse: %@\nFB: %@", cUser, cAccessToken);
    if(cUser && cAccessToken){                                       // Already logged in
        return YES;
    }else{
        return NO;
    }
}
/*
- (void)checkUserPermissions{
	// check permissions
	
	NSArray* permissions = @[@"public_profile", @"user_education_history", @"user_friends", @"user_groups"];
	
	FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/permissions" parameters:nil];
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
		NSLog(@"%@", result);
		NSArray* permissions = [result objectForKey:@"data"];
		
		BOOL permissionMissing = NO;
		BOOL publishPermission = YES;
		for(NSDictionary* permission in permissions){
			NSString* info = [permission objectForKey:@"permission"];
			NSString* status = [permission objectForKey:@"granted"];
			
			if([info isEqualToString:@"publish_actions"] && ![status isEqualToString:@"granted"]){
				publishPermission = NO;
			}
			if(![status isEqualToString:@"granted"]){
				permissionMissing = YES;
			}
		}
		if(permissionMissing){
			// Log In with Read Permissions
			[PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
				if (!user) {
					NSLog(@"Uh oh. The user cancelled the Facebook login.");
				} else if (user.isNew) {
					NSLog(@"User signed up and logged in through Facebook!");
				} else {
					NSLog(@"User logged in through Facebook!");
				}
			}];
		}
		if(!publishPermission){
			// Request new Publish Permissions
			[PFFacebookUtils linkUserInBackground:[PFUser currentUser] withPublishPermissions:@[@"publish_actions"]];
		}
		
	}];
}
*/
- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    if([user isNew]){
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if(!error){
                [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
                [[PFUser currentUser] save];
            }else{
                NSLog(@"%@", error);
            }
        }];
    }

	//[self checkUserPermissions];
	[[self loginDelegate] loginViewController:self didLogin:YES];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Logout procedure
    [[self loginDelegate] loginViewController:self didLogin:NO];
}

@end
