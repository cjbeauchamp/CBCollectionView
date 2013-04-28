//
//  ViewController.m
//  CBCollectionViewSample
//
//  Created by Chris on 4/27/13.
//  Copyright (c) 2013 Chris Beauchamp. All rights reserved.
//

#import "ViewController.h"

#import "CBCollectionView.h"
#import "CBCollectionCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CBCollectionView *collectionView = [[CBCollectionView alloc] init];
    collectionView.frame = CGRectMake(0, 0, 320, 460);
    collectionView.backgroundColor = [UIColor redColor];
    
    collectionView.cellCreator = ^(CBCollectionCell *container, id object) {
                        
        UIImageView *background = [[UIImageView alloc] initWithFrame:[container bounds]];
        background.backgroundColor = [UIColor greenColor];
        [container addSubview:background];
        
//        NSDictionary *dictObj = (NSDictionary*)object;
//        
//        container.backgroundImageURL = @"http://www.archiveteam.org/images/4/40/Google_Logo.png";
//        container.title = [dictObj objectForKey:@"title"];
        return container;
    };
    
    [self.view addSubview:collectionView];
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"my title", @"title", nil];
    NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:@"my title1", @"title", nil];
    NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:@"my title2", @"title", nil];
    NSDictionary *d3 = [NSDictionary dictionaryWithObjectsAndKeys:@"my title3", @"title", nil];
    NSDictionary *d4 = [NSDictionary dictionaryWithObjectsAndKeys:@"my title4", @"title", nil];
    [collectionView setDataSource:[NSArray arrayWithObjects:d, d1, d2, d3, d4, nil]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
