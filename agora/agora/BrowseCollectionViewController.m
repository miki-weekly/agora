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
#import "AGActivityOverlay.h"
#import "DetailedPostViewController.h"
#import "LoginViewController.h"
#import "ParseInterface.h"
#import "PostCollectionViewCell.h"
#import "RootVC.h"
#import "UIColor+AGColors.h"

@interface BrowseCollectionViewController () <UICollectionViewDelegateFlowLayout, LoginViewControllerDelegate, AddPostViewControllerDelegate>

@property CGSize cellSize;
@property NSString* catagory;
@property NSMutableArray* postsArray;

@property AddPostButton* addButton;

@property BOOL loadingMorePosts;

@end

@implementation BrowseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAddButton:[[AddPostButton alloc] init]];
    
    [_addButton addTarget:self action:@selector(pressedAddButton) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_addButton];
    
    [self setPostsArray:[[NSMutableArray alloc] init]];
	
	// Calculate Cell rects
	CGSize screen = [[UIScreen mainScreen] bounds].size;
	CGFloat leftInset = [(UICollectionViewFlowLayout *)self.collectionViewLayout sectionInset].left;
	CGFloat cellWidth = (screen.width - leftInset*3)/2;
	[self setCellSize:CGSizeMake(cellWidth, cellWidth)];

	// TEST Code to prime currentCommunity register
	[[NSUserDefaults standardUserDefaults] setObject:@"199221610195298" forKey:@"currentCommunity"];
	
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

- (void)didReceiveMemoryWarning{
	[super didReceiveMemoryWarning];
	NSLog(@"Memory Warning: dropping images");
	for(Post* post in self.postsArray)
		[post dropImages];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString: @"viewPostSegue"]){
        DetailedPostViewController* destination = [segue destinationViewController];
        NSIndexPath* path = [[self collectionView] indexPathForCell:sender];
        Post* selectedPost = [[self postsArray] objectAtIndex:path.row];
        destination.post = selectedPost;
    }
}

- (void)reloadData{
    [self reloadDataWithCategory:[self catagory]];
}

- (void)reloadDataWithCategory:(NSString*) cat {
	[self setCatagory:cat];

	UIColor* buttonColor = nil;
	if([[self catagory] isEqualToString:@"RECENTS"])
		buttonColor = [UIColor indigoColor];
	else
		buttonColor = [UIColor catColor:[self catagory]];
	[UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
		[_addButton setBackgroundColor:buttonColor];
	} completion:^(BOOL finished) {}];

    // populate array
	[[self collectionView] setUserInteractionEnabled:NO];
	AGActivityOverlay* overlay = [[AGActivityOverlay alloc] initWithString:@"Loading"];
	overlay.center = self.view.center;
	[self.view addSubview:overlay];
	[UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		overlay.alpha = 1.0f;
	} completion:^(BOOL finished) {
	}];

    [ParseInterface getFromParse:cat withSkip:0 completion:^(NSArray * result) {
		[[self postsArray] removeAllObjects];
        [[self postsArray] addObjectsFromArray:result];
        [[self collectionView] reloadData];
		[[self collectionView] setUserInteractionEnabled:YES];
		[UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			overlay.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[overlay removeFromSuperview];
		}];
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
    
    if(addedPost){	// Only refresh if post catagory is same as viewing catagory
		if([self.catagory isEqualToString:addedPost.category])
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	CGFloat actualPosition = scrollView.contentOffset.y;
	
	CGFloat threshold = 80.0f;
	if(actualPosition < -64.0f - threshold){
		[self reloadData];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat actualPosition = scrollView.contentOffset.y;
	CGFloat contentHeight = scrollView.contentSize.height - self.collectionView.frame.size.height;
	
	CGFloat loadAheadOfScrollDist = 0.8f;	// Load more post once %80 scrolled
	if(actualPosition >= (contentHeight*loadAheadOfScrollDist) && contentHeight > 0 && ![self loadingMorePosts]){
		[self setLoadingMorePosts:YES];
		[ParseInterface getFromParse:@"RECENTS" withSkip:[[self postsArray] count] completion:^(NSArray * result) {
			[self.collectionView performBatchUpdates:^{
				NSUInteger resultsSize = [self.postsArray count];
				[[self postsArray] addObjectsFromArray:result];
				NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
							
				for (NSUInteger i=resultsSize; i < resultsSize + result.count; i++)
					[arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
							
				[self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
				
			} completion:nil];
			
			[self setLoadingMorePosts:NO];
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
	
    if(![postForCell thumbnail]){
		[[postCell imageView] setImage:nil];
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
	// final size of cell is not calculated until after gradient is drawn
	CGRect frame = view.bounds;
	frame.size.height = 35.0f;
	frame.size.width = _cellSize.width;
	gradient.frame = frame;
	
	//NSLog(@"%f, %f", gradient.frame.size.height, frame.size.height);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor, [[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor, nil];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    [view.layer addSublayer:gradient];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	return _cellSize;
}

@end
