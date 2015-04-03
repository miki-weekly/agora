//
//  BrowseCollectionViewController.m
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <QuartzCore/QuartzCore.h>

#import "BrowseCollectionViewController.h"
#import "DetailedPostViewController.h"
#import "LoginViewController.h"
#import "PostCollectionViewCell.h"

@interface BrowseCollectionViewController () 

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property NSMutableArray* postsArray;

@end

@implementation BrowseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Let LoginViewController controll login
    LoginViewController *logInController = [[LoginViewController alloc] init];
    [self presentViewController:logInController animated:YES completion:nil];
    
    CGRect addButtonRect = CGRectMake(300, 580, 75, 75);
    UILabel* plus = [[UILabel alloc] initWithFrame:CGRectMake(addButtonRect.size.height/2 - 16, addButtonRect.size.height/2 - 22, 40, 40)];
    [plus setText:@"+"];
    //[plus sizeToFit];
    [plus setFont:[UIFont systemFontOfSize:48]];
    
    UIButton* addButton = [[UIButton alloc] initWithFrame:addButtonRect];
    [[addButton layer] setCornerRadius:[addButton frame].size.height/2];
    [[addButton layer] setMasksToBounds:YES];
    [[addButton layer] setBorderWidth:0];
    [addButton addSubview:plus];
    [addButton setBackgroundColor:[UIColor colorWithRed:0.247f green:0.318f blue:0.71f alpha:1.0f]];
    [addButton bringSubviewToFront:plus];
    [[self view] addSubview:addButton];
    

    if(![PFUser currentUser]){                                                          // Not Logged in
#warning presenting VC without adding to VC stack 
        
    }else{
        // continue with load
        [self viewDidLoadAfterLogin];
    }
}

- (void)viewDidLoadAfterLogin {

    // populate array
    [ParseInterface getFromParse:@"RECENTS" withSkip:0 completion:^(NSArray * result) {
        [[self activitySpinner] stopAnimating];         // automatiicaly started via Storyboard
        [self setPostsArray:[[NSMutableArray alloc] initWithArray:result]];
        [[self collectionView] reloadData];
    }];
}
- (IBAction)pressedAddButton:(UIBarButtonItem *)sender {
}

#pragma mark - AddPostDelegate

- (void)didFinishWithPost:(Post *)addedPost{
    //xself
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self postsArray] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionViewCell* postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"postCell" forIndexPath:indexPath];
    Post* postForCell = [[self postsArray] objectAtIndex:[indexPath row]];
    
    // Cell config
    [[postCell layer] setCornerRadius:5.0f];
    
    [[postCell titleLabel] setText:[postForCell title]];
    [[postCell priceLabel] setText:[[postForCell price] stringValue]];
    [[postCell imageView] setImage:[postForCell thumbnail]];
    
    [postCell setBackgroundColor:[UIColor grayColor]];
    
    return postCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: @"viewPostSegue"]){
        DetailedPostViewController* destination = [segue destinationViewController];
        NSIndexPath* path = [[self collectionView] indexPathForCell:sender];
        Post* selectedPost = [[self postsArray] objectAtIndex:path.row];
        
        destination.post = [ParseInterface getFromParseIndividual:[selectedPost objectId]];
    }
}

@end
