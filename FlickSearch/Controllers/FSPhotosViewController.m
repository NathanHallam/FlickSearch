//
//  FSPhotosViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 4/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSPhotosViewController.h"
#import "FSPhotoCell.h"
#import "FlickrKit.h"
#import "Haneke.h"


@interface FSPhotosViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;

@end

@implementation FSPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Any GUI related operations here
            });
        }   
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollection View Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
