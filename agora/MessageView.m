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
#import "UIColor+AGColors.h"
#import "UILabel+dynamicHeight.h"



#define WIDTH_PERCENT 75
#define PROFILE_SIZE 50
#define PROFILE_PADDING 5
#define MESSAGE_PADDING 7
#define TRIANGLE_W 18
#define TRIANGLE_H 12


@interface MessageView()

@property FBSDKProfilePictureView * profPic;
@property (getter=isLeftSide)BOOL leftSide;

// measurements
@property CGFloat picOffset;
@property CGFloat picDim;
@property CGFloat picDiff;

@property CGFloat minViewHeight;

@property CGFloat messageBubbleWidth;   // message bubble + space for profile pic including padding

@property CGFloat textPad;
@property CGFloat oneLineHeight;
@property CGPoint labelOrigin;


@end


@implementation MessageView



- (instancetype)initWithMsg:(Message*) msg {
        self = [super init];
        if (self) {
                
                // set measurements
                self.picOffset = PROFILE_SIZE + PROFILE_PADDING + PROFILE_PADDING;
                self.picDiff = PROFILE_PADDING;
                self.picDim = PROFILE_SIZE;
                self.textPad = MESSAGE_PADDING;
                self.minViewHeight = self.picOffset;
                self.messageBubbleWidth = [UIScreen mainScreen].bounds.size.width * WIDTH_PERCENT/100.0;
                
                
                
                // figure out left or right
                NSString * msgUserID = msg.sender;
                NSString * appUserID = [[PFUser currentUser] objectForKey:@"facebookId"];
                if ([msgUserID isEqualToString:appUserID])  {
                        //message is right side (me)
                        self.leftSide = NO;
                } else {
                        self.leftSide = YES;
                }
                
                // create origins for label
                
                if ([self isLeftSide]) {
                        self.labelOrigin = CGPointMake(self.picOffset+self.textPad, self.textPad);
                } else {
                        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
                        self.labelOrigin = CGPointMake(screenW-self.messageBubbleWidth+self.textPad, self.textPad);
                }
                
                // nao to setup the label
                
                CGFloat labelWidth = self.messageBubbleWidth - self.textPad*2 - self.picOffset;
                
                UILabel * message = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrigin.x, self.labelOrigin.y, labelWidth, self.minViewHeight-self.textPad*2)];
                
                [message setTextColor:self.isLeftSide?[UIColor blackColor]:[UIColor whiteColor]];
                
                [message setText:msg.chatMessage];
                [message setNumberOfLines:0];
                [message setFont:[UIFont systemFontOfSize:12]];
                if (msg.height == 0) {
                        [message resizeLabel];
                        msg.height = message.frame.size.height;
                } else {
                        CGRect old = message.frame;
                        message.frame = CGRectMake(old.origin.x, old.origin.y, old.size.width, msg.height);
                }
                
                [self addSubview:message];
                
                
                
                // profile picture setup things
                
                self.profPic = [[FBSDKProfilePictureView alloc]init];
                [self.profPic.layer setCornerRadius:self.picDim/2.0];
                [self.profPic.layer setMasksToBounds:YES];
                [self addSubview:self.profPic];
                
                if (self.leftSide) {
                        //set sellers profile pic to left bottom
                        [self.profPic setProfileID:@"956635704369806"];
                        self.profPic.frame = CGRectMake(self.picDiff, self.frame.size.height-self.picDim - self.picDiff, self.picDim, self.picDim);
                        
                } else {
                        // set users profile pic to right top
                        [self.profPic setProfileID:[[PFUser currentUser] objectForKey:@"facebookId"]];
                        self.profPic.frame = CGRectMake(self.frame.size.width-self.picOffset + self.picDiff, self.picDiff, self.picDim, self.picDim);
                        
                }

                
                
                // final things
                
              
                
                self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, message.frame.size.height+self.textPad+self.textPad);
                
                

                self.backgroundColor = [UIColor whiteColor];
                
                
                
                
        }
        return self;
}

+ (instancetype)viewForMessage:(Message *)msg {
        MessageView * viewWithMessage = [[MessageView alloc] initWithMsg:msg];
        [viewWithMessage reloadProfilePic];
        viewWithMessage.msg = msg;
        return viewWithMessage;
}


-(void)reloadProfilePic {
        if ([self isLeftSide]) {
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
        if (self.isLeftSide) {
                [self drawLeftBubble];
        } else {
                [self drawRightBubble];
        }
}





-(void) drawLeftBubble {
        
        
        CGSize s = self.frame.size;
        CGFloat totalW = [UIScreen mainScreen].bounds.size.width;
        CGFloat offset = totalW * 0.25;
        
        // creates cgpoints that outline clockwise the points of the background color for the chat bubble
        CGPoint rightTop = CGPointMake(s.width-offset, 0);
        CGPoint rightBot = CGPointMake(s.width-offset, s.height);
        CGPoint leftBot = CGPointMake(self.picOffset - TRIANGLE_W, s.height);
        CGPoint triangleTop = CGPointMake(self.picOffset, s.height-TRIANGLE_H);
        CGPoint leftTop = CGPointMake(self.picOffset, 0);
        
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //Set the stroke (pen) color
        CGContextSetFillColorWithColor(ctx, [UIColor msgGrey].CGColor);
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
        
        CGFloat totalW = [UIScreen mainScreen].bounds.size.width;
        CGFloat offset = totalW * 0.25;
        
        // creates cgpoints that outline clockwise the points of the background color for the chat bubble
        CGPoint rightTop = CGPointMake(s.width-self.picOffset+TRIANGLE_W, 0);
        CGPoint triangleBot = CGPointMake(s.width-self.picOffset, TRIANGLE_H);
        CGPoint rightBot = CGPointMake(s.width-self.picOffset, s.height);
        CGPoint leftBot = CGPointMake(offset, s.height);
        CGPoint leftTop = CGPointMake(offset, 0);
        
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //Set the stroke (pen) color
        CGContextSetFillColorWithColor(ctx, [UIColor msgBlue].CGColor);
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



















