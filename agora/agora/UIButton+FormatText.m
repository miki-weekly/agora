//
//  UIButton+FormatText.m
//  agora
//
//  Created by Ethan Gates on 4/7/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "UIButton+FormatText.h"

@implementation UIButton (FormatText)


- (void)setTextColor:(UIColor *)textColor range:(NSRange)range
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedTitleForState:UIControlStateNormal]];
    [text addAttribute: NSForegroundColorAttributeName
                 value: textColor
                 range: range];
    
    [self setAttributedTitle:text forState:UIControlStateNormal];
}

@end
