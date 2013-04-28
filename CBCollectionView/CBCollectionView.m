//
//  CBCollectionView.m
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import "CBCollectionView.h"

#import "CBCollectionCell.h"

#define PADDING     6

@interface CBCollectionView() {
    NSArray *_dataSource;
    CBCellCreationBlock _cellCreator;
}
@end

@implementation CBCollectionView

@synthesize cellCreator = _cellCreator;
@synthesize dataSource = _dataSource;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        _dataSource = [[NSArray alloc] init];
        _cellCreator = nil;
        
        self.backgroundColor = [UIColor brownColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) updateLayout
{
    int ndx = 0;
    CGFloat maxContentY = 0.0f;
    
    NSLog(@"Setting datasource: %@", _dataSource);
    
    // use this point to update the view
    for(id obj in _dataSource) {
        
        if(_cellCreator == nil) continue;
        
        CGFloat height = 120.0f;
        
        // create a container
        CGRect frame = CGRectMake(PADDING, PADDING+(height+PADDING)*ndx, self.bounds.size.width - PADDING*2, height);
        CBCollectionCell *cell = [[CBCollectionCell alloc] initWithFrame:frame];
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell = _cellCreator(cell, obj);
        [self addSubview:cell];
        
        CGFloat thisMax = cell.frame.origin.y + cell.frame.size.height;
        if(thisMax > maxContentY) {
            maxContentY = thisMax;
        }
        
        ++ndx;
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, maxContentY + PADDING)];

}

- (void) setDataSource:(NSArray*)dataSource {

    _dataSource = dataSource;

    // make sure this is run on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{

        [self updateLayout];
    
    });

}

@end
