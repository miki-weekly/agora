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

#import "BrowseCollectionViewController.h"

#import "AddPostButton.h"
#import "AddPostViewController.h"
#import "DetailedPostViewController.h"
#import "LoginViewController.h"
#import "ParseInterface.h"
#import "PostCollectionViewCell.h"
#import "RootVC.h"

@interface BrowseCollectionViewController () <LoginViewControllerDelegate, AddPostViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@property NSString* catagory;
@property NSMutableArray* postsArray;

@property BOOL loadingMorePosts;

@end

@implementation BrowseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AddPostButton* addButton = [[AddPostButton alloc] init];
    
    [addButton addTarget:self action:@selector(pressedAddButton) forControlEvents:UIControlEventTouchDown];
    [[self view] addSubview:addButton];
    
    [self setPostsArray:[[NSMutableArray alloc] init]];
	
	[self setCatagory:@"RECENTS"];
	[self reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    RootVC * r = (RootVC*)self.parentViewController.parentViewController;
	[r reloadUserProfpicAndName];
}

- (void)viewDidAppear:(BOOL)animated{
	if(!animated){
		// Let LoginViewController controll login
		LoginViewController *logInController = [[LoginViewController alloc] init];
		[logInController setLoginDelegate:self];
		if(![logInController userLoggedIn]){
			[self presentViewController:logInController animated:YES completion:nil];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: @"viewPostSegue"]){
        DetailedPostViewController* destination = [segue destinationViewController];
        NSIndexPath* path = [[self collectionView] indexPathForCell:sender];
        Post* selectedPost = [[self postsArray] objectAtIndex:path.row];
        destination.post = selectedPost;
    }
}

-(void) reloadData {
    [self reloadDataWithCategory:[self catagory]];
}

- (void) reloadDataWithCategory:(NSString*) cat {
    // populate array
	[self setCatagory:cat];
    [[self activitySpinner] startAnimating];
    [ParseInterface getFromParse:cat withSkip:0 completion:^(NSArray * result) {
        [[self activitySpinner] stopAnimating];
        [[self postsArray] removeAllObjects];
        [[self postsArray] addObjectsFromArray:result];
        [[self collectionView] reloadData];
    }];
    
    if ([cat isEqualToString:@"RECENTS"]) {
        self.title = @"All";
    } else {
        self.title = cat;
    }
}

- (IBAction)clickMenu:(id)sender {
    RootVC * root = (RootVC*)self.parentViewController.parentViewController;
    [root snapOpen];
}

- (void)pressedAddButton{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    AddPostViewController* addView = [story instantiateViewControllerWithIdentifier:@"Add Post"];
    [addView setDelgate:self];
	
    [self presentViewController:addView animated:YES completion:nil];
}

#pragma mark - AddPostDelegate

- (void)addPostController:(AddPostViewController *)addPostController didFinishWithPost:(Post *)addedPost{
    [addPostController dismissViewControllerAnimated:YES completion:nil];
    
    if(addedPost){
        [self reloadData];
    }else{
        // No post was made
    }
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController didLogin:(BOOL)login{
    if(login){
        [loginViewController dismissViewControllerAnimated:YES completion:nil];
        [self reloadData];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"agora"
    message:@"Login Error" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat loadAheadOfScrollDist = 200.0f;
	
	CGFloat actualPosition = scrollView.contentOffset.y;
	CGFloat contentHeight = scrollView.contentSize.height - self.collectionView.frame.size.height - loadAheadOfScrollDist;
	NSLog(@"Actual:%f content:%f", actualPosition, contentHeight);
	if(actualPosition >= contentHeight && contentHeight > 0 && ![self loadingMorePosts]){
		[self setLoadingMorePosts:YES];
		[ParseInterface getFromParse:@"RECENTS" withSkip:[[self postsArray] count] completion:^(NSArray * result) {
			[[self postsArray] addObjectsFromArray:result];
			[self setLoadingMorePosts:NO];
			[self.collectionView reloadData];
		}];
	}
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
    [[postCell titleLabel] setTextColor:[UIColor whiteColor]];
    [[postCell priceLabel] setText:[@"$" stringByAppendingString:[[postForCell price] stringValue]]];
    [[postCell priceLabel] setTextColor:[UIColor whiteColor]];
    [[postCell imageView] setContentMode:UIViewContentModeScaleAspectFill];
	[[postCell imageView] setImage:nil];
	
    if(![postForCell thumbnail]){
        [ParseInterface getThumbnail:[postForCell objectId] completion:^(UIImage *result){
            [postForCell setThumbnail:result];
            [[postCell imageView] setImage:[postForCell thumbnail]];
        }];
    }else{
        [[postCell imageView] setImage:[postForCell thumbnail]];
    }

    [postCell.gradient setBackgroundColor:[UIColor clearColor]];
    if ([postCell.gradient.layer.sublayers count] == 0) {
        [self addGradientBGForView:postCell.gradient];
    }
    
    return postCell;
}

- (void) addGradientBGForView:(UIView*) view {
    CAGradientLayer * gradient = [CAGradientLayer layer];
	
	// TODO: Bug were gradientFrame does not match Story board
	CGRect frame = view.bounds;
	frame.size.height = 35.0f;
	gradient.frame = frame;
	
	//NSLog(@"%f, %f", gradient.frame.size.height, frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor, [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor, nil];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    [view.layer addSublayer:gradient];
    
}

@end
