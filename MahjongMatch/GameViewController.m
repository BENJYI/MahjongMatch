//
//  ViewController.m
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/29/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *selectPan;
@property (nonatomic, strong) UIPanGestureRecognizer *shiftPan;
@property (nonatomic, strong) UISwipeGestureRecognizer *matchSwipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *matchSwipeDown;
@property (nonatomic, strong) UISwipeGestureRecognizer *matchSwipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *matchSwipeRight;
@property (nonatomic, strong) UIView *leftPanView;
@property (nonatomic, strong) UIView *rightPanView;

@end

@implementation GameViewController
{
    BOOL isShifting;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.boardView layoutIfNeeded];
    isShifting = NO;
    [self.boardView resetTiles];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // TO DO
    // Reduce this code by adding conditional statement to shift or select new tile
    // Condition: Location of user's touch
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    self.leftPanView = [[UIView alloc] initWithFrame:
                           CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height)];
    self.rightPanView = [[UIView alloc] initWithFrame:
                            CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)];
    
    self.selectPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPan:)];
    self.shiftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPan:)];
    [self.leftPanView addGestureRecognizer:self.selectPan];
    // [self.rightPanView addGestureRecognizer:shiftPan];
    
    [self.view addSubview:self.leftPanView];
    [self.view addSubview:self.rightPanView];
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    self.matchSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightTileSwipe:)];
    self.matchSwipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    self.matchSwipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightTileSwipe:)];
    self.matchSwipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    self.matchSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightTileSwipe:)];
    self.matchSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    self.matchSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightTileSwipe:)];
    self.matchSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.rightPanView addGestureRecognizer:self.matchSwipeLeft];
    [self.rightPanView addGestureRecognizer:self.matchSwipeRight];
    [self.rightPanView addGestureRecognizer:self.matchSwipeUp];
    [self.rightPanView addGestureRecognizer:self.matchSwipeDown];
    
    UITapGestureRecognizer *resetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTiles:)];
    resetTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:resetTap];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRightAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.rightPanView addGestureRecognizer:tapGesture];
    
//    
//    UIButton *rightViewToggleButton = [[UIButton alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(self.view.frame) - 42, 40, 40)];
//    [rightViewToggleButton addTarget:self action:@selector(toggleRightAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightViewToggleButton setBackgroundColor:[UIColor orangeColor]];
//    [self.leftPanView addSubview:rightViewToggleButton];
}

- (void)toggleRightAction:(id)sender {
    if (isShifting) {
        isShifting = NO;
        [self beginMatching];
        self.view.backgroundColor = [UIColor whiteColor];
    } else {
        isShifting = YES;
        [self beginShifting];
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)beginShifting {
    [self.rightPanView addGestureRecognizer:self.matchSwipeLeft];
    [self.rightPanView addGestureRecognizer:self.matchSwipeRight];
    [self.rightPanView addGestureRecognizer:self.matchSwipeUp];
    [self.rightPanView addGestureRecognizer:self.matchSwipeDown];
    [self.rightPanView removeGestureRecognizer:self.shiftPan];
}

- (void)beginMatching {
    [self.rightPanView removeGestureRecognizer:self.matchSwipeLeft];
    [self.rightPanView removeGestureRecognizer:self.matchSwipeRight];
    [self.rightPanView removeGestureRecognizer:self.matchSwipeUp];
    [self.rightPanView removeGestureRecognizer:self.matchSwipeDown];
    [self.rightPanView addGestureRecognizer:self.shiftPan];
}

- (void)leftPan:(UIPanGestureRecognizer *)recognizer {
    [self.boardView panTileSelection:recognizer];
}

- (void)rightPan:(UIPanGestureRecognizer *)recognizer {
    [self.boardView panTileShift:recognizer];
}

- (void)rightTileSwipe:(UISwipeGestureRecognizer *)recognizer {
    [self.boardView swipeMatch:recognizer];
}

- (void)resetTiles:(UITapGestureRecognizer *)recognizer {
    [self.boardView resetTiles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
