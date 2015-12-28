//
//  TileSet.h
//  MahjongMatch
//
//  Created by Benjamin Yi on 6/5/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TileSetDelegate <NSObject>

- (void)placeTiles;

@end

@interface TileSet : NSObject

- (void)randomizeTiles;
@property (nonatomic, assign) id<TileSetDelegate> delegate;
@property (nonatomic, strong) NSArray *tiles;

@end
