//
//  CBCollectionView.h
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "CBCollectionCell.h"

@class CBCollectionView, CBCollectionCell;

@protocol CBCollectionViewDelegate <NSObject>

@required

- (CBCollectionCell*) cellForIndex:(int)index
                      inCollection:(CBCollectionView*)collection
                    usingContainer:(CBCollectionCell*)container;

- (int) itemsInCollection:(CBCollectionView*)collection;

- (void) selectedCellAtIndex:(int)ndx
                inCollection:(CBCollectionView*)collection;

@end

@interface CBCollectionView : UIScrollView

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) id<CBCollectionViewDelegate> collectionDelegate;

- (void) updateLayout;

@end
