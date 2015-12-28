//
//  TileGroupScrollView.m
//  MahjongMatch
//
//  Created by Benjamin Yi on 6/3/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import "TileGroupScrollView.h"
#import "TileView.h"
@implementation TileGroupScrollView

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    // Offset on an axis is the inverse of a pan translation
    //   - A negative offset indicates a movement down or to the right
    //   - A positive offset indicates a movement up or to the left
    
    CGFloat offset = [self.direction isEqualToString:@"horizontal"]
    ? contentOffset.x : contentOffset.y;
    
    if (offset > 0) {
        if (self.minPanLimit == 0) {
            offset = 0;
        } else if (offset > self.minPanLimit) {
            offset = self.minPanLimit;
        }
    } else {
        if (self.maxPanLimit == 0) {
            offset = 0;
        } else if (offset < -self.maxPanLimit) {
            offset = -self.maxPanLimit;
        }
    }
    
    contentOffset = [self.direction isEqualToString:@"horizontal"]
    ? CGPointMake(offset, 0)
    : CGPointMake(0, offset);
    
    [super setContentOffset:contentOffset];
}

- (void)setPanLimitsWithEmptyTiles:(int)emptyTiles withDimensions:(CGPoint)tileDimensions{
    CGFloat length = [self.direction isEqualToString:@"horizontal"] ? tileDimensions.x : tileDimensions.y;
    self.minPanLimit = self.vectorDirection < 0 ? emptyTiles * length : 0;
    self.maxPanLimit = self.vectorDirection > 0 ? emptyTiles * length : 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
