//
//  AGActivityOverlay.h
//  agora
//
//  Created by Kalvin Loc on 4/22/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGActivityOverlay : UIView

@property (strong,nonatomic) NSString* title;

- (instancetype)initWithString:(NSString*)string;

@end
