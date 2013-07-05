//
//  CBCollectionView.m
//  CBCollectionView
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import "CBCollectionView.h"

#import "CBCollectionCell.h"
#import "CKRefreshArrowView.h"
#import "UIView+CBExtensions.h"

#define PADDING     6

@interface CBCollectionView() {
    NSArray *_dataSource;
    __unsafe_unretained id<CBCollectionViewDelegate> _collectionDelegate;
    
    // refresh
    UIView *refreshHeader;
    BOOL isLoading;
    BOOL isDragging;
    CKRefreshArrowView *arrow;
    UIActivityIndicatorView *spinner;
}
@end

@implementation CBCollectionView

@synthesize collectionDelegate = _collectionDelegate;
@synthesize dataSource = _dataSource;

- (void) doRefresh:(id)sender
{
    NSLog(@"SHOULD REFRESH");
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        _dataSource = [[NSArray alloc] init];
        
        self.backgroundColor = FEED_BACKGROUND_COLOR;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.delegate = self;
        
        // add the refresh header
        refreshHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -1*REFRESH_HEADER_HEIGHT, frame.size.width, REFRESH_HEADER_HEIGHT)];
        refreshHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:refreshHeader];
        
        arrow = [[CKRefreshArrowView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        arrow.tintColor = ACCENT_COLOR;
        arrow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [refreshHeader addSubview:arrow];

        arrow.center = CGPointMake(refreshHeader.frame.size.width/2, refreshHeader.frame.size.height/2);
        [arrow normalizeView];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = (CGPoint){
            .x = CGRectGetMidX(refreshHeader.bounds),
            .y = CGRectGetMidY(refreshHeader.bounds)
        };
        spinner.color = ACCENT_COLOR;
        spinner.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleBottomMargin);
        [refreshHeader addSubview:spinner];

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
    
    NSLog(@"Done updating layout: %@", NSStringFromCGSize(self.contentSize));
}

- (void) setDataSource:(NSArray*)dataSource {

    _dataSource = dataSource;

    // make sure this is run on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLayout];
    });

}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        
        // Update the progress arrow
        CGFloat progress = fabs(scrollView.contentOffset.y / REFRESH_HEADER_HEIGHT);
        CGFloat deadZone = 0.3;
        if (progress > deadZone) {
            CGFloat arrowProgress = ((progress - deadZone) / (1 - deadZone));
            arrow.progress = arrowProgress;
        }
        else {
            arrow.progress = 0.0;
        }
        
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
            } else {
                // User is scrolling somewhere within the header
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
        
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    }];
    
//    [self setContentOffset:CGPointMake(0, -1*REFRESH_HEADER_HEIGHT) animated:TRUE];
    
    // hide the arrow and show the spinner
    arrow.alpha = 0.0f;
    [spinner startAnimating];

    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.contentInset = UIEdgeInsetsZero;
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    arrow.alpha = 1.0f;
    [spinner stopAnimating];
}

- (void)refresh {
    
    // tell our delegate to reload the data
    [_collectionDelegate refreshData];

}

- (void) doneLoading {
    [self stopLoading];
}


@end
