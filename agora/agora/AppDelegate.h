//
//  AppDelegate.h
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

/* TODO:
 - Share and Contact button functionality
    -> implement native chat

 - Search functionality
 - settings page?
 
 
 - likeing/commenting posts?
 - Placement Tweaks (DetailedPostView/AddPostView)
 - Required Field check/interface
 
 - Proper layout for browseCollectionView (on iPhone 6 constraints are off)
 - Category badge for postcells
 
 - Clicking any imageView Leads to a new fullScreen image
 
 - ***Manage view*****
 - User View <Merge User and Mange view?>
 - Settings/User Profile View
 
 -******Facebook/Groups*****
 - Posting to groups possible and getting group feeds are possible (graph gives global IDs for posters?) <Kalvin
 - Can retrieve comments on given posts
 
 - Post statuses (still on sale/ sold/ canceled)
    - sold and canceled would not be shown
 
 - Color schemeing the entire app
 - Logo placements (App Icon/Login screen/Launch Screen)
 
 
 *BUGS:
 - Addview's NSNotification notifier is slow when initially clicking a textfield
 - FBSDKAccessToken is not retained
 */
