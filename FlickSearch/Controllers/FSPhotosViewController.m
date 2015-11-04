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
@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;

@end

@implementation FSPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    
    fk uploadImage:<#(DUImage *)#> args:<#(NSDictionary *)#> completion:<#^(NSString *imageID, NSError *error)completion#>
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UICollection View Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoURLS count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.photoURL = [self.photoURLS objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
