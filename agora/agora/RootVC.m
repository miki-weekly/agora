//
//  RootVC.m
//  agora
//
//  Created by Ethan Gates on 3/30/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "RootVC.h"
#import "SlideItemVC.h"
#import "BrowseCollectionViewController.h"


#import "UIImage+ImageEffects.h"
#import "UIColor+AGColors.h"
#import "UIButton+FormatText.h"


#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>




#define MENU_BUTTON_X_OFFSET 20
#define BLUR_RATE 10


@interface RootVC () <UIGestureRecognizerDelegate>

// View Controllers
@property (nonatomic)  NSArray * buttonNames;
@property NSMutableArray * viewControllers;
@property UIViewController * currentVC;

//overlay properties
@property UIView * menu;
@property CAGradientLayer * gradient;
@property UIImage * screenshot;
@property BOOL needsNewScreenshot;
@property UIImageView * blurView;

//button view
@property UIView * buttonView;
@property NSMutableArray * buttons;
@property UILabel * titleLabel;

@property UIView * logoutView;

//@property UIButton * logout;
@property FBSDKProfilePictureView * profPic;
@property UILabel * name;


//device specific defines
@property CGFloat xThresh;
@property CGFloat velocityThresh;

@end

@implementation RootVC

#pragma mark - children VC Rotation Methods


@synthesize buttonNames = _buttonNames;
-(NSArray*) buttonNames {
    // must return dictionary with strings in order to appear on overlay menu
    
    if (!_buttonNames) {
        _buttonNames =@[@"Browse",@"Education",@"Fashion",@"Home",@"Tech",@"Misc",@"Chat",@"My Posts",@"Settings"];
    }
    
    return _buttonNames;
}

-(UIScreenEdgePanGestureRecognizer *)getEdgePanGesture {
    UIScreenEdgePanGestureRecognizer * edgeSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRightFromLeftEdge:)];
    edgeSwipe.edges = UIRectEdgeLeft;
    edgeSwipe.delegate = self;
    return edgeSwipe;
}

-(void) setupChildrenVCs {
    // must add VC's as children in order of menu item
    //ie call addchildviewcontroller in same order as buttonNames
    
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    
    UIViewController * browse = [story instantiateViewControllerWithIdentifier:@"Browse Nav"];
    [self addChildViewController:browse];
    [self.view addSubview:browse.view];
    self.currentVC = browse;
    
    
    //make other vcs but don't add them
    
    UIViewController * chat = [story instantiateViewControllerWithIdentifier:@"chat nav"];
    [self addChildViewController:chat];
    
    UIViewController * manage = [story instantiateViewControllerWithIdentifier:@"manage nav"];
    [self addChildViewController:manage];
    
    UIViewController * settings = [story instantiateViewControllerWithIdentifier:@"settings"];
    [self addChildViewController:settings];
    
}


-(void) switchToViewController:(NSInteger) index {
    SlideItemVC * newVC = self.childViewControllers[index];
    if (self.currentVC == newVC) {
        // newVC is same as current one
    } else {
        [self transitionFromViewController:self.currentVC toViewController:newVC duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        } completion:^(BOOL finished) {
            
        }];
        self.currentVC = newVC;
    }
}




#pragma mark - VC lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpOverlay];
    [self setupButtonView];
    
    
    // setup view controller rotation scheme
    
    //children setup
    [self setupChildrenVCs];
    self.needsNewScreenshot = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - IB connection action stuff

-(IBAction)clickLogOut:(id)sender {
    
    [PFUser logOut];
	[FBSDKAccessToken setCurrentAccessToken:nil];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbTokenString"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbPermissions"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbDeclinedPermissions"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbAppID"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbUserID"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbExpirationDate"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbRefreshDate"];
	
    
    for (UIViewController * vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    };
    
    [self setupChildrenVCs];
    
    
    
    
    [self fadeToRatio:0.0];
}

-(IBAction)clickMenuItem:(id)sender {
    UIButton * b = (UIButton*)sender;
    NSString * item = [[b.titleLabel.text substringWithRange:NSMakeRange(1, 1)] isEqualToString:@" "]?[b.titleLabel.text substringFromIndex:2]:b.titleLabel.text; //change category string to not include the color dot
    
    NSInteger buttonIndex = 0;
    for (int i = 0; i < [self.buttonNames count]; i++) {
        if ([item isEqualToString:self.buttonNames[i]]) {
            buttonIndex = i;
        }
    }
    
    
    
    if (buttonIndex == 0) {
        [self switchToViewController:buttonIndex];
        [((BrowseCollectionViewController*)self.currentVC.childViewControllers[0]) reloadData];
        
    } else if (buttonIndex == 6) {
        // chat
        [self switchToViewController:1];
        
        
    } else if (buttonIndex == 7) {
        //my posts
        [self switchToViewController:2];
        
    } else if (buttonIndex == 9) {
        //settings
        [self switchToViewController:3];
        
    } else {
        //clicked a category
        [self switchToViewController:0];
        [((BrowseCollectionViewController*)self.currentVC.childViewControllers[0]) reloadDataWithCategory:item];
    }
    
    
    
    
    [self snapClosed];
}

int count;

-(IBAction)swipeRightFromLeftEdge:(UIGestureRecognizer*) sender {
    
    [self.view bringSubviewToFront:self.menu];
    [self.view bringSubviewToFront:self.buttonView];
    
    
    UIPanGestureRecognizer * gesture = (UIPanGestureRecognizer*)sender;
    CGPoint translation = [gesture translationInView:gesture.view];
    CGPoint velocity = [gesture velocityInView:gesture.view];
    if(UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //NSLog(@"began Gesture");
        }
        
        //NSLog(@"translation x %f translation y %f",translation.x,translation.y);
        //NSLog(@"velocity x %f velocity y %f",velocity.x,velocity.y);
        // Move the view's center using the gesture
        CGFloat max = [UIScreen mainScreen].bounds.size.width/2;
        [self fadeToRatio:translation.x > max?1.0:translation.x/max];
        
        
        
        count++;
    } else {
        // cancel, fail, or ended
        //NSLog(@"gesture cancel, fail, or ended with call count %i",count);
        
        // check whether we snap to active or snap to inactive
        if (translation.x > self.xThresh || velocity.x > self.velocityThresh) {
            [self snapOpen];
        } else {
            [self snapClosed];
        }
        count = 0;
        
    }
}

-(IBAction) swipeLeft:(id)sender {
    UIPanGestureRecognizer * gesture = (UIPanGestureRecognizer*)sender;
    CGPoint translation = [gesture translationInView:gesture.view];
    CGPoint velocity = [gesture velocityInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        //        if (gesture.state == UIGestureRecognizerStateBegan) {
        //            NSLog(@"began Gesture");
        //        }
        
        //NSLog(@"translation x %f translation y %f",translation.x,translation.y);
        //NSLog(@"                    velocity x %f velocity y %f",velocity.x,velocity.y);
        
        CGFloat fadeTo = (translation.x+100.0)/100.0;
        if (fadeTo < 0) {
            
        } else {
            fadeTo = fadeTo>1.0?1.0:fadeTo;
            [self fadeToRatio:fadeTo];
        }
        count++;
    } else {
        //NSLog(@"gesture cancel, fail, or ended with call count %i",count);
        if (translation.x*-1 > [UIScreen mainScreen].bounds.size.width/3 || velocity.x < -1000) {
            [self snapClosed];
        } else {
            [self snapOpen];
        }
        count = 0;
    }
    
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"Touches ended in root");
    [self snapClosed];
}


#pragma mark - overlay UI helpers

-(void) snapOpen {
    [self.view bringSubviewToFront:self.menu];
    [UIView animateWithDuration:0.3 animations:^{
        [self fadeToRatio:1.0];
        //[self animateBlur:YES];
    } completion:^(BOOL finished) {
        
    }];
    self.buttonView.userInteractionEnabled = YES;
    
    [self.view bringSubviewToFront:self.logoutView];
    
}

-(void) snapClosed {
    [UIView animateWithDuration:0.3 animations:^{
        [self fadeToRatio:0.0];
    }];
    self.buttonView.userInteractionEnabled = NO;
    self.needsNewScreenshot = YES;
}


-(void) setUpOverlay {
    self.menu = [[UIView alloc] initWithFrame:self.view.frame];
    self.buttons = [[NSMutableArray alloc] init];
    self.blurView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.blurView];
    //for position in addition to alpha
    
    //set Thresholds
    self.xThresh = [UIScreen mainScreen].bounds.size.width/4;
    self.velocityThresh = 1000.0;
    
    
    [self.view addSubview:self.menu];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.menu.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] colorWithAlphaComponent:0.9].CGColor, [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor, nil];
    self.gradient.startPoint = CGPointMake(0.0, 0.5);
    self.gradient.endPoint = CGPointMake(1.0, 0.5);
    
    [self.menu.layer addSublayer:self.gradient];
    
    self.menu.alpha = 0.0;
}

-(void) setupButtonView {
    self.buttonView = [[UIView alloc]initWithFrame:self.view.frame];
    
    // TITLE yaaayyy
    
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 300, 90)];
    title.text = @"Agora";
    [title setFont:[UIFont systemFontOfSize:60.0]];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,50);
    title.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    self.titleLabel = title;
    [self.buttonView addSubview:title];
    
    // Logout view
    
    CGRect r = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 40);
    self.logoutView = [[UIView alloc]initWithFrame:r];
    [self addLogoutItemsToView:self.logoutView];
    
    
    
    CGFloat y = 90;
    
    for (NSString * name in self.buttonNames) {
        if ([name isEqualToString:@""]) {
            y += 20;
            continue;
        }
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(-80, y, 160, 50)];
        y += 40;
        
        UIColor * catColor = [UIColor catColor:name];
        if (catColor) {
            NSAttributedString * buttonTitle = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",@"⦁",name]];
            [button setAttributedTitle:buttonTitle forState:UIControlStateNormal];
            [button setTextColor:[UIColor catColor:name] range:NSMakeRange(0, 1)];
            [button setTextColor:[UIColor whiteColor] range:NSMakeRange(2, [name length])];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        } else {
            [button setTitle:name forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:22]];
        }
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0]forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickMenuItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:button];
        [self.buttons addObject:button];
    }
    [self.view addSubview:self.buttonView];
    [self.view bringSubviewToFront:self.buttonView];
    
    
    //add gesture recognizer for swipe left
    UIPanGestureRecognizer * swipeClosed = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    [self.buttonView addGestureRecognizer:swipeClosed];
    self.buttonView.userInteractionEnabled = NO;
    
}

- (void) reloadUserProfpicAndName {
    
    [self.profPic setProfileID:[[PFUser currentUser] objectForKey:@"facebookId"]];
    
    
    FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc]initWithGraphPath:[[PFUser currentUser] objectForKey:@"facebookId"] parameters:NULL];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            self.name.text = result[@"name"];
        }
    }];
    
}

-(void) addLogoutItemsToView:(UIView*) view {
    
    
    //[view setBackgroundColor:[UIColor indigoColor]];
    [self.buttonView addSubview:view];
    
    CGFloat h = view.frame.size.height;
    CGFloat w = view.frame.size.width;
    
    
    // profile picture
    self.profPic = [[FBSDKProfilePictureView alloc]initWithFrame:CGRectMake(10, 0, h, h)];
    [self.profPic setProfileID:[[PFUser currentUser] objectForKey:@"facebookId"]];
    [self.profPic.layer setBorderWidth:2.0];
    [self.profPic.layer setCornerRadius:h/2];
    [self.profPic.layer setMasksToBounds:YES];
    [view addSubview:self.profPic];
    
    
    // name label
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 100, view.frame.size.height)];
    FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc]initWithGraphPath:[[PFUser currentUser] objectForKey:@"facebookId"] parameters:NULL];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            self.name.text = result[@"name"];
            [self.name setFont:[UIFont systemFontOfSize:15.0]];
        }
    }];
    [self.name setFont:[UIFont systemFontOfSize:15.0]];
    [self.name setTextColor:[UIColor whiteColor]];
    [view addSubview:self.name];
    
    
    
    
    
    // log out button
    CGFloat logoutW = 150;
    UIButton * logMeOut = [[UIButton alloc] initWithFrame:CGRectMake(w-logoutW-10, 0, logoutW, view.frame.size.height)];
    //[logMeOut setBackgroundColor:[UIColor fashColor]];
    //[logMeOut sizeToFit];
    logMeOut.center = CGPointMake(w*(3.0/4.0), h/2.0);
    [logMeOut setTitle:@"Log Out" forState:UIControlStateNormal];
    [logMeOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logMeOut.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [logMeOut addTarget:self action:@selector(clickLogOut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logMeOut];
    
    // vertical bar dividing name and log out button
    CGFloat divWidth = 4.0;
    UILabel * divider = [[UILabel alloc] initWithFrame:CGRectMake((w/2.0)-divWidth/2, 0, divWidth, h)];
    divider.text = @"|";
    [divider setFont:[UIFont systemFontOfSize:26.0]];
    [divider setTextColor:[UIColor whiteColor]];
    [view addSubview:divider];
    
}

-(void) animateBlur:(BOOL) yes {
    
    for (double i = 0.0; i <= 1.0; i = i + 0.05) {
        NSNumber * ratio = [NSNumber numberWithDouble:i];
        [self performSelector:@selector(blurToRatio:) withObject:ratio afterDelay:i*1.0];
    }
    
}

-(void) blurToRatio:(NSNumber*) ratio {
    
    double r = [ratio doubleValue];
    UIImage* blurImg = [self.screenshot applyBlurWithRadius:r*5.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.2 maskImage:self.screenshot];
    self.blurView.image = blurImg;
    [self.view bringSubviewToFront:self.blurView];
    [self.view bringSubviewToFront:self.menu];
    [self.view bringSubviewToFront:self.buttonView];
}

int blurMod = 0;

-(void) fadeToRatio:(CGFloat) ratio {
    //NSLog(@"ratio change alpha is %f",ratio);
    //ratio is 0.0 to 1.0
    CGFloat textMaxAlpha = 1.0;
    CGFloat bgMaxAlpha = 0.85;
    
    CGFloat textAlpha = textMaxAlpha*ratio;
    CGFloat bgAlpha = bgMaxAlpha*ratio;
    
    //NSLog(@"alpha is %f",alpha);
    
    
    // BLUR THINGS
    
    if (self.needsNewScreenshot) {
        // create graphics context with screen size
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIGraphicsBeginImageContext(screenRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        // grab reference to our window
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        // transfer content into our context
        [window.layer renderInContext:ctx];
        self.screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.needsNewScreenshot = NO;
    }
    blurMod++;
    if (blurMod == BLUR_RATE) {
        UIImage* blurImg = [self.screenshot applyBlurWithRadius:ratio*4.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.2 maskImage:self.screenshot];
        blurMod = 0;
        
        if (ratio != 0.0) {
            self.blurView.image = blurImg;
        }
        
    }
    
    
    
    
    // change the alpha color stuff
    [self.menu setAlpha:bgAlpha];
    
    self.titleLabel.textColor = [self.titleLabel.textColor colorWithAlphaComponent:textAlpha];
    
    for (UIButton* button in self.buttons) {
        
        if ([UIColor catColor:[button.titleLabel.text substringFromIndex:2]]) {
            [button setAlpha:textAlpha];
        } else {
            [button setTitleColor:[[button titleColorForState:UIControlStateNormal] colorWithAlphaComponent:textAlpha] forState:UIControlStateNormal];
        }
    }
    if (ratio != 0.0) {
        [self.view bringSubviewToFront:self.blurView];
        [self.view bringSubviewToFront:self.menu];
        [self.view bringSubviewToFront:self.buttonView];
        
    } else {
        self.blurView.image = NULL;
    }
    
    [self.logoutView setAlpha:ratio];
    
    
    
    
    //change the movement stuff
    
    
    
    CGFloat maxMove = 100;
    CGFloat newX = maxMove*ratio;
    
    
    
    for (UIButton* b in self.buttons) {
        CGFloat y = b.center.y;
        b.center = CGPointMake(newX, y);
    }
    
    
    
    
}






@end










