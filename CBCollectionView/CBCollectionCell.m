//
//  CBCollectionCell.m
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import "CBCollectionCell.h"

@interface CBCollectionCell() {
    
    UIImageView *_backgroundImage;
    UILabel *_titleLabel;
    
    NSString *_backgroundImageURL;
    NSString *_title;
}
@end

@implementation CBCollectionCell

//@synthesize backgroundImageURL = _backgroundImageURL;
//@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//
//        _backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
//        _backgroundImage.backgroundColor = [UIColor blueColor];
//        [self addSubview:_backgroundImage];
//        
//        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
    }
    return self;
}

@end
