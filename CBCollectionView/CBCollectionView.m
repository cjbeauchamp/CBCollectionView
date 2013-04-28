//
//  CBCollectionView.m
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import "CBCollectionView.h"

#import "CBCollectionCell.h"

#define PADDING     10

@interface CBCollectionView() {
    NSArray *_dataSource;
    CBCellCreationBlock _cellCreator;
}
@end

@implementation CBCollectionView

@synthesize cellCreator = _cellCreator;
@synthesize dataSource = _dataSource;

- (void) setDataSource:(NSArray*)dataSource {
    
    _dataSource = dataSource;
    
    int ndx = 0;
    CGFloat maxContentY = 0.0f;
    
    // use this point to update the view
    for(id obj in dataSource) {
        
        // create a container
        CGRect frame = CGRectMake(10, PADDING+200*ndx, 300, 180);
        CBCollectionCell *cell = [[CBCollectionCell alloc] initWithFrame:frame];
        cell = _cellCreator(cell, obj);
        [self addSubview:cell];
        
        CGFloat thisMax = cell.frame.origin.y + cell.frame.size.height;
        if(thisMax > maxContentY) {
            maxContentY = thisMax;
        }
        
        ++ndx;
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, maxContentY + PADDING);
}

@end
