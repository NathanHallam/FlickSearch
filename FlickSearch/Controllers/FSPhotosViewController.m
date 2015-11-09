//
//  FSPhotosViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 4/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSPhotosViewController.h"
#import "FSPhotoDetailsViewController.h"
#import "FSPhotoCell.h"
#import "FlickrKit.h"
//#import "Haneke.h"

#define kCellsPerRow 3
#define kCellPadding 2.f
#define kFlickrAPIKey @"2076e48d7d3e951cf8e6b3685c8dd44d"
#define kFlickrSharedSecret @"6138b35cb585e73d"
#define kPhotoDetailsSegue @"PhotosDetailsSegue"


@interface FSPhotosViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;

@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

@property (nonatomic, strong) NSMutableArray* photosArray;

@property (nonatomic, weak) FSPhotoDetailsViewController* detailsController;

@end

@implementation FSPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.indicator startAnimating];
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrSharedSecret];
    
    //Start with Interesting images
    [self loadPhotosFrom:@"flickr.interestingness.getList" withArgs:@{@"per_page":@"99"}];
}

- (void)didReceiveMemoryWarning {   
    [super didReceiveMemoryWarning];
}


#pragma mark - Helper Methods
- (void)loadPhotosFrom:(NSString*)photoMethod withArgs:(NSDictionary*)args
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    [fk call:photoMethod args:args completion:^(NSDictionary *response, NSError *error) {
        if (response) {
            NSMutableArray *photos = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                [photos addObject:photoData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photosArray = photos;
                [self.collectionView reloadData];
                [self.indicator stopAnimating];
            });
        } else {
            [self.indicator stopAnimating];
        }
    }];
}

#pragma mark - Search Bar Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.photosArray removeAllObjects];
    [self.collectionView reloadData];
    [self.indicator startAnimating];
    [self loadPhotosFrom:@"flickr.photos.search"  withArgs:@{@"text":searchBar.text}];
    [searchBar resignFirstResponder];
}

#pragma mark - Collection View Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize;
    NSInteger landscapeExtraCells = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ? 2 : 0;
    NSInteger ipadExtraCells = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2 : 0;
    CGFloat width = ((self.collectionView.frame.size.width - kCellPadding) / (kCellsPerRow + landscapeExtraCells + ipadExtraCells)) - kCellPadding;

    cellSize.width = width;
    cellSize.height = width;
    
    return cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCellPadding;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kCellPadding, kCellPadding, kCellPadding, kCellPadding);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.photo = self.photosArray[indexPath.row]; 
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    FSPhotoCell* cell = (FSPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:kPhotoDetailsSegue sender:cell.photo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPhotoDetailsSegue]) {
        FSPhotoDetailsViewController * destination = segue.destinationViewController;
        destination.photo = sender;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView reloadData];
}
     
@end
