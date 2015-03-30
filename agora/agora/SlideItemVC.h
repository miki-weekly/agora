//
//  SlideItemVC.h
//  agora
//
//  Created by Ethan Gates on 3/30/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootVCNavProtocol

-(UIScreenEdgePanGestureRecognizer*) getEdgePanGesture;

@end


@interface SlideItemVC : UIViewController
@property UIViewController <RootVCNavProtocol> * root;

@end
