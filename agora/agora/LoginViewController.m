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
	FBSDKAccessToken* cAccessToken = [self getFBUserTokenFromDefaults];
	
	if(cAccessToken != nil)
		[FBSDKAccessToken setCurrentAccessToken:cAccessToken];
	
    NSLog(@"\nParse:\n%@\nFacebook:\n%@", cUser, cAccessToken);
    if(cUser && cAccessToken){                                       // Already logged in
        return YES;
    }else{
        return NO;
    }
}

- (void)checkUserPermissions{
	// check permissions
	
	NSArray* appRequestedPermissions = @[@"public_profile", @"user_education_history", @"user_friends", @"user_groups"];
	NSArray* appRequestedWritePermissions = @[@"publish_actions"];
	
	FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/permissions" parameters:nil];
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary* result, NSError *error) {
		NSArray* userPermissions = [result objectForKey:@"data"];
		NSMutableArray* grantedPermissions = [[NSMutableArray alloc] init];
		
		BOOL publishPermission = NO;												// Check for what permissions are given
		for(NSDictionary* permission in userPermissions){
			NSString* info = [permission objectForKey:@"permission"];
			NSString* status = [permission objectForKey:@"status"];

			if([status isEqualToString:@"granted"]){
				if([info isEqualToString:@"publish_actions"]){
					publishPermission = YES;
				}else{
					[grantedPermissions addObject:info];
				}
			}
		}
		
		for(NSInteger i=[grantedPermissions count]-1; i>=0; i--){					// Check for what permissions are missing
			for(NSString* requiredPermission in grantedPermissions){
				if([requiredPermission isEqualToString:grantedPermissions[i]]){
					[grantedPermissions removeObjectAtIndex:i];
					break;
				}
			}
		}
		
		// TODO: Error message to re auth
		if([grantedPermissions count] != 0){			// if any permissions are not given, request
			// Log In with Read Permissions
			[PFFacebookUtils logInInBackgroundWithReadPermissions:appRequestedPermissions block:^(PFUser *user, NSError *error) {
				if(!user){
					NSLog(@"Uh oh. The user cancelled the Facebook login.");
				}else if([user isNew]){
					NSLog(@"User signed up and logged in through Facebook!");
				}else{
					NSLog(@"User logged in through Facebook!");
				}
			}];
		}
		if(!publishPermission){
			// Request new Publish Permissions
			[PFFacebookUtils linkUserInBackground:[PFUser currentUser] withPublishPermissions:appRequestedWritePermissions];
		}
	}];
}

- (void)saveFBUserToken{
	FBSDKAccessToken* fbAccessToken = [FBSDKAccessToken currentAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:[fbAccessToken tokenString] forKey:@"fbTokenString"];
	[[NSUserDefaults standardUserDefaults] setObject:[[fbAccessToken permissions] allObjects] forKey:@"fbPermissions"];
	[[NSUserDefaults standardUserDefaults] setObject:[[fbAccessToken declinedPermissions] allObjects] forKey:@"fbDeclinedPermissions"];
	[[NSUserDefaults standardUserDefaults] setObject:[fbAccessToken appID] forKey:@"fbAppID"];
	[[NSUserDefaults standardUserDefaults] setObject:[fbAccessToken userID] forKey:@"fbUserID"];
	[[NSUserDefaults standardUserDefaults] setObject:[fbAccessToken expirationDate] forKey:@"fbExpirationDate"];
	[[NSUserDefaults standardUserDefaults] setObject:[fbAccessToken refreshDate] forKey:@"fbRefreshDate"];
}

- (FBSDKAccessToken*)getFBUserTokenFromDefaults{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	FBSDKAccessToken* token = [[FBSDKAccessToken alloc] initWithTokenString:[defaults objectForKey:@"fbTokenString"]
																permissions:[defaults objectForKey:@"fbPermissions"]
														declinedPermissions:[defaults objectForKey:@"fbDeclinedPermissions"]
																	  appID:[defaults objectForKey:@"fbAppID"]
																	 userID:[defaults objectForKey:@"fbAppID"]
															 expirationDate:[defaults objectForKey:@"fbExpirationDate"]
																refreshDate:[defaults objectForKey:@"fbRefreshDate"]];
	
	if(![defaults objectForKey:@"fbTokenString"] || [[defaults objectForKey:@"fbExpirationDate"] timeIntervalSinceNow] < 0.0)
		return nil;
	return token;
}

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
	
	NSLog(@"Logged in\n%@\n%@", [PFUser currentUser], [FBSDKAccessToken currentAccessToken]);
	[self saveFBUserToken];
	[self checkUserPermissions];
	[[self loginDelegate] loginViewController:self didLogin:YES];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Logout procedure
    [[self loginDelegate] loginViewController:self didLogin:NO];
}

@end
