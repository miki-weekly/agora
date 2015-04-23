//
//  AGActivityOverlay.m
//  agora
//
//  Created by Kalvin Loc on 4/22/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AGActivityOverlay.h"

@interface AGActivityOverlay ()

@property UIActivityIndicatorView* indicator;
@property UILabel* titleLabel;

@end

@implementation AGActivityOverlay

@synthesize title = _title;
- (void)setTitle:(NSString *)title{
	_titleLabel.text = title;
}

- (instancetype)initWithString:(NSString *)string{
	if((self = [super init])){
		CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
		self.frame = CGRectMake(0, 0, screenWidth/4.0f, screenWidth/4.0f);
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
		self.layer.cornerRadius = 7.0f;
		self.alpha = 0.0f;		// alpha set to 0 to require fade in animation
		
		_indicator = [[UIActivityIndicatorView alloc] init];
		_indicator.transform = CGAffineTransformMakeScale(1.50, 1.50);
		_indicator.center = self.center;
		[_indicator startAnimating];
		[self addSubview:_indicator];
		
		CGPoint center = self.center;
		center.y += _titleLabel.frame.size.height + 20.0f;
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, center.y, self.frame.size.width, 15.0f)];
		_titleLabel.text = string;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.font = [UIFont systemFontOfSize:14.0f];
		_titleLabel.textColor = [UIColor whiteColor];
		
		[self addSubview:_titleLabel];
	}
	
	return self;
}

@end
