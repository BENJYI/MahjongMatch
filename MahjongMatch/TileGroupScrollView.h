//
//  TileGroupScrollView.h
//  MahjongMatch
//
//  Created by Benjamin Yi on 6/3/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileGroupScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat minPanLimit;
@property (nonatomic, assign) CGFloat maxPanLimit;
@property (nonatomic, strong) NSString *direction;
@property (nonatomic, assign) int vectorDirection;
@property (nonatomic, strong) NSArray *movingTiles;

- (BOOL)isHorizontal;
- (BOOL)isVertical;
- (void)setPanLimitsWithEmptyTiles:(int)emptyTiles withDimensions:(CGPoint)tileDimensions;

@end
