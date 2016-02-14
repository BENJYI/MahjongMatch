//
//  BoardView.m
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/30/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import "BoardView.h"
#import "TileGroupScrollView.h"

@interface BoardView()

@property (nonatomic, strong) TileGroupScrollView *scrollView;
@property (nonatomic, strong) TileSet *tileSet;
@property (nonatomic, assign) CGFloat minPanLimit;
@property (nonatomic, assign) CGFloat maxPanLimit;

@end

@implementation BoardView
{
    int selectedTileTag;
    int currentPanTag;
    
    UIPanGestureRecognizer *selectionPanGesture;
    UIPanGestureRecognizer *shiftPanGesture;

    BOOL gestureCancelled;
    
    int clearedTiles;
    
    CGPoint tileDimensions;
}  

- (void)awakeFromNib {
    [super awakeFromNib];
    clearedTiles = 0;
    self.tileSet = [[TileSet alloc] init];
    self.tileSet.delegate = self;
    self.didBeginShifting = NO;
    // Swipe gesture recognizer
    
    selectedTileTag = 1001;
}

- (void)panTileSelection:(UIPanGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentPanTag = selectedTileTag;
        gestureCancelled = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateCancelled) {
        gestureCancelled = YES;
    }
    
    CGPoint translation = [recognizer translationInView:self];
    
    TileView *panTile = (TileView *)[self viewWithTag:currentPanTag];
    int newPanTag = [self getTileWithTranslation:translation];
    if (newPanTag < 1001) newPanTag += 16;
    if (newPanTag > 1144) newPanTag -= 16;
    TileView *newPanTile = (TileView *)[self viewWithTag:newPanTag];
    
    if (newPanTile && newPanTag != currentPanTag) {
        currentPanTag = newPanTag;
        [panTile enableHighlightedState:NO];
        [newPanTile enableHighlightedState:YES];
    }
     
    if (recognizer.state == UIGestureRecognizerStateEnded && !gestureCancelled) {
//        TileView *previousTile = (TileView *)[self viewWithTag:selectedTileTag];
        selectedTileTag = currentPanTag;
//        TileView *nextTile = (TileView *)[self viewWithTag:selectedTileTag];
//        
//        [previousTile enableHighlightedState:NO];
//        [nextTile enableHighlightedState:YES];
    }
}

- (int)getTileWithTranslation:(CGPoint)translation {
    int horizontalShift = (translation.x * 1.5) / tileDimensions.x;
    int verticalShift = (translation.y * 1.5) / tileDimensions.y;
    
    if (!horizontalShift && !verticalShift) {
        return selectedTileTag;
    }
    int movementThreshold;
    
    if (fabs(translation.x) > fabs(translation.y)) {
        if (translation.x < 0) {
            movementThreshold = -1 * ((selectedTileTag - 1001) % 16);
        } else {
            movementThreshold = 15 - ((selectedTileTag - 1001) % 16);
            
        }
        if (abs(horizontalShift) >= abs(movementThreshold)) {
            horizontalShift = movementThreshold;
        }
    } else {
        if (translation.y < 0) {
            movementThreshold = -1 * ((int)(selectedTileTag - 1001) / 16);
        } else {
            movementThreshold = 8 - ((int)(selectedTileTag - 1001) / 16);
        }
        
        if (abs(verticalShift) >= abs(movementThreshold)) {
            verticalShift = movementThreshold;
        }
    }
    
    int returnTileTag = selectedTileTag + (horizontalShift * 1) + (verticalShift * 16);

    if (returnTileTag < 1001) {
        returnTileTag += 16;
    }
    if (returnTileTag > 1144) {
        returnTileTag -= 16;
    }
    
    return returnTileTag;
}

- (void)swipeMatch:(UISwipeGestureRecognizer *)recognizer {
    int toMatchTileTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp:   toMatchTileTag = selectedTileTag - 16; break;
        case UISwipeGestureRecognizerDirectionDown: toMatchTileTag = selectedTileTag + 16; break;
        case UISwipeGestureRecognizerDirectionLeft: toMatchTileTag = selectedTileTag -  1; break;
        case UISwipeGestureRecognizerDirectionRight:toMatchTileTag = selectedTileTag +  1; break;
        default: return; break;
    }
    
    if (toMatchTileTag < 1001 || toMatchTileTag > 1144)
        return;
    
    TileView *toMatchTile = (TileView *)[self viewWithTag:toMatchTileTag];
    if (!toMatchTile)
        return;
    
    TileView *currentTile = (TileView *)[self viewWithTag:selectedTileTag];
    
    if ([toMatchTile.tileType isEqualToString:currentTile.tileType]) {
        [currentTile removeFromSuperview];
        [toMatchTile removeFromSuperview];
        clearedTiles += 2;
    }
    
    if (clearedTiles == 144) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yaaaaaaay" message:@"You win!" delegate:self cancelButtonTitle:@"Sure thing" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self resetTiles];
}

- (void)panTileShift:(UIPanGestureRecognizer *)recognizer {
    if (!(TileView *)[self viewWithTag:selectedTileTag]) {
        return;
    }
    
    NSArray *rowTiles = [NSArray array];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [recognizer velocityInView:self];
        int vectorDirection;
        
        if (fabs(velocity.x) > fabs(velocity.y)) {
            self.scrollView.direction = (velocity.x > 0) ? @"left" : @"right";
            vectorDirection = velocity.x / fabs(velocity.x);
        } else {
            self.scrollView.direction = (velocity.y > 0) ? @"up" : @"down";
            vectorDirection = velocity.y / fabs(velocity.y);
        }
        self.scrollView.vectorDirection = vectorDirection;
        rowTiles = [self getScrollableTiles];
        [self sendTiles:rowTiles];
    }
    
    CGPoint translation = [recognizer translationInView:self];
    CGPoint offset;
    
    if (self.scrollView.isHorizontal) {
        offset = CGPointMake(-translation.x, 0);
    } else {
        offset = CGPointMake(0, -translation.y);
    }
    
    self.scrollView.contentOffset = offset;
    
    NSLog(@"%@", self.scrollView.direction);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self updateTiles:rowTiles];
    }
}

- (NSArray *)getScrollableTiles {
    NSMutableArray *tiles = [NSMutableArray array];
    
    TileView *selectedTile = (TileView *)[self viewWithTag:selectedTileTag];
    [tiles addObject:selectedTile];

    int tileCount, increment, minTag, maxTag;
    if (self.scrollView.isHorizontal) {
        tileCount = 16;
        increment = 1,
        minTag = selectedTile.leadingTileTag;
        maxTag = selectedTile.trailingTileTag;
    } else {
        tileCount = 9;
        increment = 16;
        minTag = selectedTile.topTileTag;
        maxTag = selectedTile.bottomTileTag;
    }
    
    increment = self.scrollView.vectorDirection < 0 ? -increment : increment;
    
    int emptyTiles = 0;
    
    for (int tag = selectedTileTag + increment; tag >= minTag && tag <= maxTag; tag += increment) {
        TileView *tile = (TileView *)[self viewWithTag:tag];
        if (tile) {
            [tiles addObject:tile];
        } else {
            while (!tile && (tag >= minTag && tag <= maxTag)) {
                emptyTiles++;
                tag += increment;
                tile = (TileView *)[self viewWithTag:tag];
            }
            break;
        }
    }
    
    [self.scrollView setPanLimitsWithEmptyTiles:emptyTiles withDimensions:tileDimensions];
    
    NSArray *returnTiles = [NSArray arrayWithArray:tiles];
    return returnTiles;
}

- (void)sendTiles:(NSArray *)tiles {
    NSMutableArray *tilesArray = [NSMutableArray array];
    for (TileView *tile in tiles) {
        [tile removeFromSuperview];
        [self.scrollView addSubview:tile];
        [tilesArray addObject:tile];
    }
    self.scrollView.movingTiles = tilesArray;
}

- (void)updateTiles:(NSArray *)tiles {
    float panDistance;
    float length;
    int tagIncrement;
    
    if (self.scrollView.isHorizontal) {
        panDistance = -self.scrollView.contentOffset.x;
        length = tileDimensions.x;
        tagIncrement = 1;
    } else {
        panDistance = -self.scrollView.contentOffset.y;
        length = tileDimensions.y;
        tagIncrement = 16;
    }
    
    int tileOffset = round(panDistance / length);
    
    self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
    
    for (TileView *tile in self.scrollView.movingTiles ) {
        
        CGPoint newCenter = self.scrollView.isHorizontal
            ? CGPointMake(tile.center.x + (tileOffset * length), tile.center.y)
            : CGPointMake(tile.center.x, tile.center.y + (tileOffset * length));
        
        tile.tag += tileOffset * tagIncrement;
        tile.center = newCenter;
        
        [tile removeFromSuperview];
        [self addSubview:tile];
    }
    
    selectedTileTag += tileOffset * tagIncrement;
}

- (void)placeTiles {
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    
    CGFloat tileWidth = self.frame.size.width / 16;
    CGFloat tileHeight = self.frame.size.height / 9;
    tileDimensions = CGPointMake(tileWidth, tileHeight);
    NSInteger __tileTag = 1000;
    for (int i = 0; i < 9; i++) {
        NSArray *tileRow = (NSArray *)self.tileSet.tiles[i];
        for (int j = 0; j < 16; j++) {
            __tileTag++;
            CGPoint tileCoordinate = CGPointMake(j * tileWidth, i * tileHeight);
            CGRect tileRect = CGRectMake(tileCoordinate.x, tileCoordinate.y, tileWidth, tileHeight);
            NSString *tileString = tileRow[j];
            NSInteger tileTag = __tileTag;
            TileView *tile = [[TileView alloc] initWithFrame:tileRect
                                                        tile:tileString
                                                         tag:tileTag
                                                withDelegate:self];
            [self addSubview:tile];
            
        }
    }
    
    TileView *tile;
    
    if (selectedTileTag <= 1000) {
        tile = (TileView *)[self viewWithTag:1001];
    } else {
        tile = (TileView *)[self viewWithTag:selectedTileTag];
        [tile enableHighlightedState:YES];
    }
    [self createScrollView];
}

- (void)createScrollView {
    [self.scrollView removeFromSuperview];
    self.scrollView = [[TileGroupScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.scrollView.frame.size;
    
    [self addSubview:self.scrollView];
    [self.scrollView setUserInteractionEnabled:NO];
}

- (void)didSelectTileWithTag:(NSInteger)tag {
    if (tag == selectedTileTag) {
        return;
    }
    TileView *firstTile = (TileView *)[self viewWithTag:selectedTileTag];
    TileView *secondTile = (TileView *)[self viewWithTag:tag];
    
    // Something in this next nest is causing it to be slow..
    if (tag == selectedTileTag + 1 ||
        tag == selectedTileTag - 1 ||
        tag == selectedTileTag + 16 ||
        tag == selectedTileTag - 16 ) {
        
        if ([firstTile.tileType isEqualToString:secondTile.tileType]) {
            clearedTiles += 2;
            [UIView animateWithDuration:1.2 animations:^{
                [firstTile removeFromSuperview];
                [secondTile removeFromSuperview];
                
            }];
            
            if (clearedTiles == 144) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yaaaaaaay" message:@"You win!" delegate:nil cancelButtonTitle:@"Sure thing" otherButtonTitles:nil];
                [alert show];
                [self resetTiles];
            }
            return;
        }
    }
    [firstTile enableHighlightedState:NO];
    [secondTile enableHighlightedState:YES];
    
    selectedTileTag = (int)secondTile.tag;
}

- (BOOL)tile:(TileView *)firstTile canMatchWithTile:(TileView *)secondTile {
    if (firstTile.row != secondTile.row && firstTile.column != secondTile.column) {
        return NO;
    }
    
    if (abs((int)(firstTile.tag - secondTile.tag)) == 1 ||
        abs((int)(firstTile.tag - secondTile.tag)) == 16) {
        if (![firstTile.tileType isEqualToString:secondTile.tileType]) {
            return NO;
        }
    }
    
    int lowerTag, upperTag;
    int increment = 0;
    
    if (firstTile.row == secondTile.row) {
        lowerTag = firstTile.column < secondTile.column ? (int)firstTile.tag : (int)secondTile.tag;
        upperTag = firstTile.column < secondTile.column ? (int)secondTile.tag : (int)firstTile.tag;
        increment = 1;
    } else if (firstTile.column == secondTile.column) {
        lowerTag = firstTile.row < secondTile.row ? (int)firstTile.tag : (int)secondTile.tag;
        upperTag = firstTile.row < secondTile.row ? (int)secondTile.tag : (int)firstTile.tag;
        increment = 16;
    }
    
    for (int tag = lowerTag + increment; tag < upperTag; tag += increment) {
        TileView *tile = (TileView *)[self viewWithTag:tag];
        if (tile) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)matchingTileExistsForTile:(TileView *)selectedTile {
    int increment1, increment2, increment3;
    if ([self.scrollView.direction isEqualToString:@"left"]) {
        increment1 = 1; increment2 = 16; increment3 = -16;
    } else if ([self.scrollView.direction isEqualToString:@"right"]) {
        increment1 = -1; increment2 = 16; increment3 = -16;
    } else if ([self.scrollView.direction isEqualToString:@"up"]) {
        increment1 = 16; increment2 = 1; increment3 = -1;
    } else if ([self.scrollView.direction isEqualToString:@"down"]) {
        increment1 = -16; increment2 = 1; increment3 = -1;
    }
    
    int numberOfMatchingTiles = 0; // Can go up to 3.
    
    return YES;
}

- (void)scanForMatchingTile:(TileView *)tile {
    
}

- (void)resetTiles {
    [self.tileSet randomizeTiles];
    clearedTiles = 0;
}

- (void)setBoardForMoveType:(BOOL)moveTypeIsShifting {
    if (moveTypeIsShifting) {
        [self removeGestureRecognizer:selectionPanGesture];
        [self addGestureRecognizer:shiftPanGesture];
    } else {
        [self removeGestureRecognizer:shiftPanGesture];
        [self addGestureRecognizer:selectionPanGesture];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
