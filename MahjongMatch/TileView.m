//
//  TileView.m
//  MahjongMatch
//
//  Created by Benjamin Yi on 5/30/15.
//  Copyright (c) 2015 Thoom. All rights reserved.
//

#import "TileView.h"

@interface TileView()

@property (nonatomic, strong) UILabel *tileLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TileView
{
    CGPoint frameInset;
    CGPoint tileDimensions;
}

+ (TileView *)emptyTileWithTag:(NSInteger)tag {
    TileView *tile = [[TileView alloc] init];
    tile.tag = tag;
    return tile;
}

- (instancetype)initWithFrame:(CGRect)frame tile:(NSString *)tile tag:(NSInteger)tag withDelegate:(id)delegate {
    if (self = [super initWithFrame:frame]) {
        frameInset = CGPointMake(frame.size.width * 0.1, frame.size.height * 0.1);
        tileDimensions = CGPointMake(frame.size.width, frame.size.height);
        self.layer.borderWidth = 0.3f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.tag = tag;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.clipsToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.0;
        self.delegate = delegate;
        self.tileType = tile;
        [self setupTileDecorWithTile:tile];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectNewTile)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)selectNewTile {
    [self.delegate didSelectTileWithTag:self.tag];
}

- (void)setupTileDecorWithTile:(NSString *)tile {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:self.tileType];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:kNilOptions metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:nil views:views]];
}

- (void)enableHighlightedState:(BOOL)highlightEnabled {
    self.frame = highlightEnabled ? CGRectInset(self.frame, -frameInset.x, -frameInset.y)
                                  : CGRectInset(self.frame,  frameInset.x,  frameInset.y);
    self.layer.borderWidth   = highlightEnabled ? 0.9 : 0.3;
    self.layer.shadowOpacity = highlightEnabled ? 0.8 : 0.0;
    if (highlightEnabled) {
        self.frame = CGRectInset(self.frame, -frameInset.x, -frameInset.y);
        self.layer.borderWidth = 0.9;
        self.layer.shadowOpacity = 0.8;
        [self.superview bringSubviewToFront:self];
    } else {
        self.frame = CGRectInset(self.frame,  frameInset.x,  frameInset.y);
        self.layer.borderWidth = 0.3;
        self.layer.shadowOpacity = 0.0;
    }
}

- (void)clearTile {
    self.isCleared = YES;
    [self.tileLabel removeFromSuperview];
}

- (int)column {
    return ((self.tag - 1001) % 16) + 1;
}

- (int)row {
    return ((int)(self.tag - 1001) / 16) + 1;
}

- (int)tileTag {
    return (int)self.tag;
}

- (int)leadingTileTag {
    return ((int)((self.tag - 1001) / 16) * 16) + 1001;
}

- (int)trailingTileTag {
    return ((int)((self.tag - 1001) / 16) * 16) + 1016;
}

- (int)topTileTag {
    return ((self.tag - 1001) % 16) + 1001;
}

- (int)bottomTileTag {
    return ((self.tag - 1001) % 16) + 1129;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
