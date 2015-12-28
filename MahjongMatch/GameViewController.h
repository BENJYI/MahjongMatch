//
//  ViewController.h
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/29/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"

@interface  GameViewController : UIViewController

@property (nonatomic, weak) IBOutlet BoardView *boardView;

@end

