//
//  ScrollableImageViewController.m
//  agora
//
//  Created by Kalvin Loc on 4/27/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ScrollableImageViewController.h"

@interface ScrollableImageViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ScrollableImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.image = _imageToScroll;

	[_scrollView setZoomScale:1.0f];
}

- (void)viewDidAppear:(BOOL)animated{
	//_scrollView.contentSize = [[UIScreen mainScreen] bounds].size;
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

#pragma mark UIScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if([_scrollView zoomScale] <= [_scrollView minimumZoomScale])
	   [self dismissViewControllerAnimated:YES completion:nil];
}

@end
