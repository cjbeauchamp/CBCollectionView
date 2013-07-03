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
    __unsafe_unretained id<CBCollectionViewDelegate> _collectionDelegate;
}
@end

@implementation CBCollectionView

@synthesize collectionDelegate = _collectionDelegate;
@synthesize dataSource = _dataSource;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        _dataSource = [[NSArray alloc] init];
        
        self.backgroundColor = FEED_BACKGROUND_COLOR;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void) cellTapped:(UIGestureRecognizer*)gesture
{
    [_collectionDelegate selectedCellAtIndex:gesture.view.tag inCollection:self];
}

- (void) updateLayout
{
    NSLog(@"Updating layout");
    
    CGFloat maxContentY = 0.0f;
        
    int ct = [_collectionDelegate itemsInCollection:self];
    
    // use this point to update the view
    for(int ndx=0; ndx<ct; ndx++) {
        
        CGFloat height = 120.0f;
        
        // create a container
        CGRect frame = CGRectMake(PADDING, PADDING+(height+PADDING)*ndx, self.bounds.size.width - PADDING*2, height);
        CBCollectionCell *cell = [[CBCollectionCell alloc] initWithFrame:frame];
        cell.tag = ndx;
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cell = [_collectionDelegate cellForIndex:ndx inCollection:self usingContainer:cell];
        [self addSubview:cell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [cell addGestureRecognizer:tap];
        
        CGFloat thisMax = cell.frame.origin.y + cell.frame.size.height;
        if(thisMax > maxContentY) {
            maxContentY = thisMax;
        }
        
    }
    
    [self setContentSize:CGSizeMake(self.frame.size.width, maxContentY + PADDING)];

    NSLog(@"Done updating layout");
}

- (void) setDataSource:(NSArray*)dataSource {

    _dataSource = dataSource;

    // make sure this is run on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{

        [self updateLayout];
    
    });

}

@end
