//
//  BoardView.h
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/30/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileView.h"
#import "TileSet.h"

@interface BoardView : UIView <TileSetDelegate, TileViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

//@property (nonatomic, assign) int currentPanTag;
//@property (nonatomic, assign) int selectedTileTag;
@property (nonatomic, assign) BOOL didBeginShifting;

- (void)resetTiles;
- (void)setBoardForMoveType:(BOOL)moveTypeIsShifting;
- (void)panTileSelection:(UIPanGestureRecognizer *)recognizer;
- (void)panTileShift:(UIPanGestureRecognizer *)recognizer;
- (void)swipeMatch:(UISwipeGestureRecognizer *)recognizer;
@end
