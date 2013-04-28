//
//  CBCollectionView.h
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CBCollectionCell;

typedef CBCollectionCell* (^CBCellCreationBlock)(CBCollectionCell *container, id object);

@interface CBCollectionView : UIScrollView

@property (nonatomic, strong) CBCellCreationBlock cellCreator;
@property (nonatomic, strong) NSArray *dataSource;

@end
