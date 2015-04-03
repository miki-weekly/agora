//
//  PostCollectionViewCell.h
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *gradient;

@end
