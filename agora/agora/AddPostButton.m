//
//  AddPostButton.m
//  agora
//
//  Created by Kalvin Loc on 4/3/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostButton.h"
#import "UIColor+AGColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddPostButton

- (instancetype)init{
    if((self = [super init])){
        CGSize screen = [[UIScreen mainScreen] bounds].size;
        CGSize button = CGSizeMake(50, 50);
        CGRect frame = CGRectMake(screen.width - button.width - 10, screen.height - button.height - 10, button.width, button.height);
		
        [self setFrame:frame];
		[self setTitle:@"+" forState:UIControlStateNormal];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[[self titleLabel] setFont:[UIFont systemFontOfSize:36.0f]];
		[self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];

        // config button shadow
        [[self layer] setCornerRadius:frame.size.height/2];
        [[self layer] setMasksToBounds:NO];
        [[self layer] setBorderWidth:0];
        
        [[self layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self layer] setShadowRadius:4.0f];
        [[self layer] setShadowOpacity:0.5f];
        [[self layer] setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:[[self layer] cornerRadius]] CGPath]];

		[self setBackgroundColor:[UIColor indigoColor]];	// Colorized add button depending on viewed category?
    }
    
    return self;
}

@end
