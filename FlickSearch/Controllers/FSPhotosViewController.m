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


@interface FSPhotosViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;

@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

@property (nonatomic, strong) NSMutableArray* photosArray;

@property (nonatomic, weak) FSPhotoDetailsViewController* detailsController;

@end

@implementation FSPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.indicator startAnimating];
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:kFlickrAPIKey sharedSecret:kFlickrSharedSecret];
    
    [self startWithInterestingImages];
    
    //Container view hidden to make components in storyboard scene visible
    self.containerView.hidden = NO;
    
    //Add tap to close photo details
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    [self.containerView addGestureRecognizer:self.tapRecognizer];
}

- (void)didReceiveMemoryWarning {   
    [super didReceiveMemoryWarning];
}


#pragma mark - Helper Methods

- (void)startWithInterestingImages
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photos = [NSMutableArray array];
            //Get list of unique photo ids
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                [photos addObject:photoData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photosArray = photos;
                [self.collectionView reloadData];
                [self.indicator stopAnimating];
            });
        }
    }];
}

- (void)respondToTapGesture:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.detailsController removeFromParentViewController];
        for(UIView* view in self.containerView.subviews) {
            [view removeFromSuperview];
        } 
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.photosArray removeAllObjects];
    [self.collectionView reloadData];
    [self.indicator startAnimating];
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    [fk call:@"flickr.photos.search" args:@{@"text":searchBar.text} completion:^(NSDictionary *response, NSError *error) {
        if (response) {
            NSMutableArray *photos = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                [photos addObject:photoData];
            }
            NSLog(@"Found %lu photos matching %@", [photos count],searchBar.text);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photosArray = photos;
                [self.collectionView reloadData];
                [self.indicator stopAnimating];
            });
        } else {
            [self.indicator stopAnimating];
        }
    }];
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
    self.detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailsViewController"];
    self.detailsController.photo = cell.photo;
    [self.detailsController.view setBounds:self.containerView.frame];
    [self addChildViewController:self.detailsController];
    [self.containerView addSubview:self.detailsController.view];
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.alpha = 1.f;
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.collectionView reloadData];
}
     
@end
