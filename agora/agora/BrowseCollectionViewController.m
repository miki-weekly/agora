//
//  BrowseCollectionViewController.m
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "BrowseCollectionViewController.h"
#import "LoginViewController.h"
#import "PostCollectionViewCell.h"

@interface BrowseCollectionViewController ()

@end

@implementation BrowseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![PFUser currentUser]){                                                          // Not Logged in
        LoginViewController *logInController = [[LoginViewController alloc] init];
        [logInController setDelegate:self];
        [logInController setFields:PFLogInFieldsFacebook];
        [logInController setFacebookPermissions:@[@"user_education_history", @"public_profile"]];
        
        [self presentViewController:logInController animated:YES completion:nil];
    }else{
        // continue with load
    }
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    // Login procedure
    [controller dismissViewControllerAnimated:YES completion:nil];
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
            [[PFUser currentUser] setObject:[result objectForKey:@"name"] forKey:@"name"];
            
            [[PFUser currentUser] saveEventually];
        }
    }];
    
    [self viewDidLoad];     // Call viewDidLoad again to load browseCollectionView
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Logout procedure
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionViewCell* postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    
    // Cell config
    [[postCell titleLabel] setText:@""];
    [[postCell priceLabel] setText:@"$$$"];
    //[[postCell imageView] setImage:<#(UIImage *)#>];
    
    return postCell;
}

@end
