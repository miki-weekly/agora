//
//  UILabel+dynamicHeight.m
//  agora
//
//  Created by Ethan Gates on 4/21/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "UILabel+dynamicHeight.h"

@implementation UILabel (dynamicHeight)


-(void) resizeLabel{
        CGFloat lineHeight = [@"s" boundingRectWithSize: CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                     options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes: [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context: nil].size.height;
        
        while ([self isTruncated]) {
                CGRect old = self.frame;
                self.frame = CGRectMake(old.origin.x, old.origin.y, old.size.width, old.size.height+lineHeight);
        }
        
}


# pragma mark - stand alone helper

- (BOOL)isTruncated{
        CGSize sizeOfText = [self.text boundingRectWithSize: CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                                                     options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                  attributes: [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName] context: nil].size;
        
        if (self.frame.size.height < ceilf(sizeOfText.height)) {
                return YES;
        }
        return NO;
}


@end
