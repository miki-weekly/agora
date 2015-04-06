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

@interface RootVC () <UIGestureRecognizerDelegate>

// View Controllers
@property (nonatomic)  NSArray * buttonNames;
@property NSMutableArray * viewControllers;
@property UIViewController * currentVC;

//overlay properties
@property UIView * menu;
@property CAGradientLayer * gradient;

//button view
@property UIView * buttonView;
@property NSMutableArray * buttons;
@property UILabel * titleLabel;


//device specific defines
@property CGFloat xThresh;
@property CGFloat velocityThresh;

@end

@implementation RootVC

#pragma mark - children VC Rotation Methods


@synthesize buttonNames = _buttonNames;
-(NSArray*) buttonNames {
    // must return dictionary with strings in order to appear on overlay menu
#warning - add proper names you want in your menu
    return @[@"Browse",@"Add",@"",@"Education",@"Fashion",@"Home",@"Tech",@"Misc",@"",@"Manage"];
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
    SlideItemVC * second = [story instantiateViewControllerWithIdentifier:@"Add Post"];
    [self addChildViewController:second];
    
    UIViewController * manage = [story instantiateViewControllerWithIdentifier:@"manage nav"];
    [self addChildViewController:manage];
    
//    SlideItemVC * third = [story instantiateViewControllerWithIdentifier:@"ADD STORYBOARD ID HERE"];
//    third.root = self;
//    [self addChildViewController:third];
    
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB connection action stuff

-(IBAction)clickMenuItem:(id)sender {
    UIButton * b = (UIButton*)sender;
    NSString * item = b.titleLabel.text;
    
    NSInteger buttonIndex = 0;
    for (int i = 0; i < [self.buttonNames count]; i++) {
        if ([item isEqualToString:self.buttonNames[i]]) {
            buttonIndex = i;
        }
    }
    
    
    
    if (buttonIndex < 2) {
        [self switchToViewController:buttonIndex];
        
    } else if (buttonIndex == 9) {
        [self switchToViewController:2];
    
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
        [self changeAlpha:translation.x > max?1.0:translation.x/max];
        
        
        
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
        
        //[self changeAlpha:translation.x > max?1.0:translation.x/max];
        
        count++;
    } else {
        //NSLog(@"gesture cancel, fail, or ended with call count %i",count);
        if (translation.x*-1 > [UIScreen mainScreen].bounds.size.width/3 || velocity.x < -1000) {
            [self snapClosed];
        }
        count = 0;
    }
    
    
}

#pragma mark - overlay UI helpers

-(void) snapOpen {
    [self.view bringSubviewToFront:self.menu];
    [UIView animateWithDuration:0.3 animations:^{
        [self changeAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
    self.buttonView.userInteractionEnabled = YES;
    
}

-(void) snapClosed {
    [UIView animateWithDuration:0.3 animations:^{
        [self changeAlpha:0.0];
    }];
    self.buttonView.userInteractionEnabled = NO;
    
}


-(void) setUpOverlay {
    self.menu = [[UIView alloc] initWithFrame:self.view.frame];
    self.buttons = [[NSMutableArray alloc] init];
    //for position in addition to alpha
    //self.menu.center = CGPointMake(self.menu.center.x-50, self.menu.center.y);
    
    //set Thresholds
    self.xThresh = [UIScreen mainScreen].bounds.size.width/4;
    self.velocityThresh = 1000.0;
    
    
    [self.view addSubview:self.menu];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.menu.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] colorWithAlphaComponent:1.0].CGColor, [[UIColor blackColor] colorWithAlphaComponent:0.65].CGColor, nil];
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
    
    
    CGFloat y = 90;
    
    for (NSString * name in self.buttonNames) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(20, y, 160, 50)];
        y += 40;
        [button setTitle:name forState:UIControlStateNormal];
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

-(void) changeAlpha:(CGFloat) ratio {
    //NSLog(@"ratio change alpha is %f",ratio);
    //ratio is 0.0 to 1.0
    CGFloat textMaxAlpha = 1.0;
    CGFloat bgMaxAlpha = 0.85;
    
    CGFloat textAlpha = textMaxAlpha*ratio;
    CGFloat bgAlpha = bgMaxAlpha*ratio;
    
    //NSLog(@"alpha is %f",alpha);
    
    [self.menu setAlpha:bgAlpha];
    
    
    self.titleLabel.textColor = [self.titleLabel.textColor colorWithAlphaComponent:textAlpha];
    
    for (UIButton* button in self.buttons) {
        [button setTitleColor:[[button titleColorForState:UIControlStateNormal] colorWithAlphaComponent:textAlpha] forState:UIControlStateNormal];
        if (ratio != 0.0) {
            [self.view bringSubviewToFront:self.buttonView];
        }
    }
}






@end
