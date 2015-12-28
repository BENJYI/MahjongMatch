//
//  TileView.h
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/30/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TileViewDelegate <NSObject>

- (void)didSelectTileWithTag:(NSInteger)tag;

@end

@interface TileView : UIView

@property (nonatomic, assign) BOOL isCleared;
@property (nonatomic, assign) id<TileViewDelegate> delegate;
@property (nonatomic, strong) NSString *tileType;

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;
@property (nonatomic, assign) int tileTag;
@property (nonatomic, assign) int leadingTileTag;
@property (nonatomic, assign) int trailingTileTag;
@property (nonatomic, assign) int topTileTag;
@property (nonatomic, assign) int bottomTileTag;


+ (TileView *)emptyTileWithTag:(NSInteger)tag;
- (instancetype)initWithFrame:(CGRect)frame tile:(NSString *)tile tag:(NSInteger)tag withDelegate:(id)delegate;
- (void)enableHighlightedState:(BOOL)highlightEnabled;
- (void)clearTile;

@end
