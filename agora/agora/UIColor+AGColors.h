//
//  UIColor+AGColors.h
//  agora
//
//  Created by Ethan Gates on 4/3/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AGColors)

+(instancetype) indigoColor;



//category color methods
+(instancetype) techColor;
+(instancetype) homeColor;
+(instancetype) eduColor;
+(instancetype) miscColor;
+(instancetype) fashColor;
+(instancetype) catColor:(NSString*) cat;

+(instancetype) msgBlue;
+(instancetype) msgGrey;
+(instancetype) sendMsgGrey;


@end
