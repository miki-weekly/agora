//
//  RootVC.h
//  agora
//
//  Created by Ethan Gates on 3/30/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootVC : UIViewController

-(UIScreenEdgePanGestureRecognizer*) getEdgePanGesture;
-(void) switchToViewController:(NSInteger) index;
-(void) snapOpen;

@end
