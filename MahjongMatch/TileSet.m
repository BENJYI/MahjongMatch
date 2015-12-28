//
//  TileSet.m
//  MahjongMatch
//
//  Created by Benjamin Yi on 6/5/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import "TileSet.h"

@implementation TileSet
{
    NSMutableArray *allTiles;
}

- (instancetype)init {
    if (self = [super init]) {
        allTiles = [NSMutableArray array];
        NSArray *suitedTiles = @[
                                 @"pin1", @"pin2", @"pin3", @"pin4", @"pin5", @"pin6", @"pin7", @"pin8", @"pin9", // Circle
                                 @"bamboo1", @"bamboo2", @"bamboo3", @"bamboo4", @"bamboo5", @"bamboo6", @"bamboo7", @"bamboo8", @"bamboo9",          // Bamboo
                                 @"man1", @"man2", @"man3", @"man4", @"man5", @"man6", @"man7", @"man8", @"man9",          // Character
                                 ];
        
        NSArray *windTiles =   @[
                                 @"wind-east", // East
                                 @"wind-south",  // South
                                 @"wind-west",   // West
                                 @"wind-north"   // North
                                 ];
        
        NSArray *dragonTiles = @[
                                 @"dragon-chun", // Red
                                 @"dragon-green",    // Green
                                 @"dragon-haku"     // White
                                 ];
        
//        NSArray *flowerTiles = @[
//                                 @"flower-1",
//                                 @"flower-2",
//                                 @"flower-3",
//                                 @"flower-4"
//                                 ];
        
        // Load four sets of suited tiles, wind tiles, and dragon tiles
        for (int i = 0; i < 4; i++) {
            for (NSString *tileString in suitedTiles) {
                [allTiles addObject:tileString];
            }
            for (NSString *tileString in windTiles) {
                [allTiles addObject:tileString];
            }
            for (NSString *tileString in dragonTiles) {
                [allTiles addObject:tileString];
            }
        }
        
        // Load eight flower tiles
        for (int i = 0; i < 8; i++) {
            [allTiles addObject:@"flower"];
        }

    }
    return self;
}

- (void)randomizeTiles {
    NSUInteger count = [allTiles count];
    for (NSInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [allTiles exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    [self createTileTable];
}

- (void)createTileTable {
    NSMutableArray *mutedTileTable = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        NSMutableArray *tileRow = [NSMutableArray array];
        for (int j = 1; j <= 16; j++) {
            NSInteger tileSetIndex = 16 * i + j;
            NSString *tileString = allTiles[tileSetIndex - 1];
            [tileRow addObject:tileString];
        }
        [mutedTileTable addObject:tileRow];
    }
    self.tiles = [mutedTileTable copy];
    [self.delegate placeTiles];
}


@end
