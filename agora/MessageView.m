//
//  ConversationView.m
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "MessageView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>

@interface MessageView()

@property FBSDKProfilePictureView * profPic;
@property CGFloat picOffset;
@property CGFloat picDim;
@property CGFloat picDiff;

@end


@implementation MessageView



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.picOffset = 50;
        self.picDim = self.picOffset - 6;
        self.picDiff = (self.picOffset - self.picDim)/2.0;
        
        self.profPic = [[FBSDKProfilePictureView alloc] init];
        
        
        [self.profPic.layer setCornerRadius:self.picDim/2];
        [self.profPic.layer setMasksToBounds:YES];
        
        [self addSubview:self.profPic];
        
        
        
        
    }
    
    return self;
}

+ (UIView *)leftViewWithText:(NSString*) msg {
    UILabel * text = [[UILabel alloc]init];
    [text setPreferredMaxLayoutWidth:8];
    MessageView * left = [[MessageView alloc] init];
    left.leftSide = YES;
    [left reloadProfilePic];
    return left;
}




+ (UIView *)rightViewWithText:(NSString*) msg {
    MessageView * right = [[MessageView alloc] init];
    right.leftSide = NO;
    [right reloadProfilePic];
    return right;
}


-(void)reloadProfilePic {
    if (self.leftSide) {
        //set sellers profile pic to left bottom
        [self.profPic setProfileID:@"956635704369806"];
        self.profPic.frame = CGRectMake(self.picDiff, self.frame.size.height-self.picDim - self.picDiff, self.picDim, self.picDim);
        
    } else {
        // set users profile pic to right top
        [self.profPic setProfileID:[[PFUser currentUser] objectForKey:@"facebookId"]];
        self.profPic.frame = CGRectMake(self.frame.size.width-self.picOffset + self.picDiff, self.picDiff, self.picDim, self.picDim);
        
    }
}

#pragma mark - Drawing things for background

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.leftSide) {
        [self drawLeftBubble];
    } else {
        [self drawRightBubble];
    }
}

-(void) drawLeftBubble {
    
    
    CGSize s = self.frame.size;
    
    // creates cgpoints that outline clockwise the points of the background color for the chat bubble
    CGPoint rightTop = CGPointMake(s.width, 0);
    CGPoint rightBot = CGPointMake(s.width, s.height);
    CGPoint leftBot = CGPointMake(self.picOffset - 18, s.height);
    CGPoint triangleTop = CGPointMake(self.picOffset, s.height-12);
    CGPoint leftTop = CGPointMake(self.picOffset, 0);
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Set the stroke (pen) color
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:(235.0/256.0) green:(235.0/256.0) blue:(235.0/256.0) alpha:1.0].CGColor);
    //Set the width of the pen mark
    CGContextSetLineWidth(ctx, 2.0);
    
    // Draw a line
    //Start at this point
    CGContextMoveToPoint(ctx, rightTop.x, rightTop.y);
    
    //Give instructions to the CGContext
    //(move "pen" around the screen)
    CGContextAddLineToPoint(ctx, rightBot.x, rightBot.y);
    CGContextAddLineToPoint(ctx, leftBot.x, leftBot.y);
    CGContextAddLineToPoint(ctx, triangleTop.x, triangleTop.y);
    CGContextAddLineToPoint(ctx, leftTop.x, leftTop.y);
    CGContextAddLineToPoint(ctx, rightTop.x, rightTop.y);
    
    //Draw it
    CGContextFillPath(ctx);
}

-(void) drawRightBubble {
    
    CGSize s = self.frame.size;
    
    // creates cgpoints that outline clockwise the points of the background color for the chat bubble
    CGPoint rightTop = CGPointMake(s.width-self.picOffset+18, 0);
    CGPoint triangleBot = CGPointMake(s.width-self.picOffset, 12);
    CGPoint rightBot = CGPointMake(s.width-self.picOffset, s.height);
    CGPoint leftBot = CGPointMake(0, s.height);
    CGPoint leftTop = CGPointMake(0, 0);
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Set the stroke (pen) color
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:(0.0/256.0) green:(127.0/256.0) blue:1.0 alpha:1.0].CGColor);
    //Set the width of the pen mark
    CGContextSetLineWidth(ctx, 2.0);
    
    // Draw a line
    //Start at this point
    CGContextMoveToPoint(ctx, rightTop.x, rightTop.y);
    //Give instructions to the CGContext
    //(move "pen" around the screen)
    CGContextAddLineToPoint(ctx, triangleBot.x, triangleBot.y);
    CGContextAddLineToPoint(ctx, rightBot.x, rightBot.y);
    CGContextAddLineToPoint(ctx, leftBot.x, leftBot.y);
    CGContextAddLineToPoint(ctx, leftTop.x, leftTop.y);
    CGContextAddLineToPoint(ctx, rightTop.x, rightTop.y);
    
    //Draw it
    //CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
}




@end



















