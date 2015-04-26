//
//  UIColor+AGColors.m
//  agora
//
//  Created by Ethan Gates on 4/3/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "UIColor+AGColors.h"

@implementation UIColor (AGColors)

+ (instancetype)indigoColor {
    return [UIColor colorWithRed:(63.0/255.0) green:(81.0/255.0) blue:(181.0/255.0) alpha:1.0];
}


+(instancetype)techColor {
    return [UIColor blueColor];
}

+(instancetype)homeColor {
    return [UIColor colorWithRed:(56.0/255.0) green:(142.0/255.0) blue:(60.0/255.0) alpha:1.0];
}

+(instancetype)eduColor {
    return [UIColor colorWithRed:(253.0/255.0) green:(208.0/255.0) blue:(23.0/255.0) alpha:1.0];
}

+(instancetype)miscColor {
    return [UIColor colorWithRed:(143.0/255.0) green:0 blue:1.0 alpha:1.0];
}

+(instancetype)fashColor {
    return [UIColor colorWithRed:1.0 green:(102.0/255.0) blue:(204.0/255.0) alpha:1.0];
}

+ (instancetype) catColor:(NSString*) cat {
    cat  = [cat lowercaseString];
    if ([cat isEqualToString:@"edu"] || [cat isEqualToString:@"education"]) {
        return [self eduColor];
    } else if ([cat isEqualToString:@"fashion"] || [cat isEqualToString:@"fash"]) {
        return [self fashColor];
    } else if ([cat isEqualToString:@"home"]) {
        return [self homeColor];
    } else if ([cat isEqualToString:@"tech"] || [cat isEqualToString:@"technology"]) {
        return [self techColor];
    } else if ([cat isEqualToString:@"misc"] || [cat isEqualToString:@"miscellaneous"]) {
        return [self miscColor];
    }
    
    return NULL;
}



+(instancetype)msgBlue {
    return [UIColor colorWithRed:(0.0/256.0) green:(127.0/256.0) blue:1.0 alpha:1.0];
}

+(instancetype)msgGrey {
    return [UIColor colorWithRed:(235.0/256.0) green:(235.0/256.0) blue:(235.0/256.0) alpha:1.0];
}



@end
