//
//  AddPostButton.m
//  agora
//
//  Created by Kalvin Loc on 4/3/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddPostButton

- (instancetype)init{
    if((self = [super init])){
        CGSize screen = [[UIScreen mainScreen] bounds].size;
        CGSize button = CGSizeMake(50, 50);
        CGRect frame = CGRectMake(screen.width - button.width - 10, screen.height - button.height - 10, button.width, button.height);
        [self setFrame:frame];
        UILabel* plus = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height/2 - 15, frame.size.height/2 - 25, 40, 40)];
        [plus setText:@"+"];
        [plus setFont:[UIFont systemFontOfSize:48]];
        [plus setTextColor:[UIColor whiteColor]];
        
        // config button shadow
        [[self layer] setCornerRadius:frame.size.height/2];
        [[self layer] setMasksToBounds:NO];
        [[self layer] setBorderWidth:0];
        
        [[self layer] setShadowOffset:CGSizeMake(0, 0)];
        [[self layer] setShadowRadius:4.0f];
        [[self layer] setShadowOpacity:0.4f];
        [[self layer] setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:[[self layer] cornerRadius]] CGPath]];
        
        [self addSubview:plus];
        [self setBackgroundColor:[UIColor colorWithRed:0.247f green:0.318f blue:0.71f alpha:1.0f]];
    }
    
    return self;
}
@end
