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

#define kCellsPerRow 4
#define kCellPadding 2.f

@interface FSPhotosViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property (nonatomic, weak) FSPhotoDetailsViewController* detailsController;

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;



- (IBAction)respondToTapGesture:(id)sender;

@end

@implementation FSPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"2076e48d7d3e951cf8e6b3685c8dd44d" sharedSecret:@"6138b35cb585e73d"];
    
    [self startWithInterestingImages];
    
    self.containerView.hidden = NO;
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
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoURLS = photoURLs;
                [self.collectionView reloadData];
                [self.indicator stopAnimating];
            });
        }
    }];
}


#pragma mark - UICollection View Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize;
    CGFloat width = ((self.collectionView.frame.size.width - kCellPadding) / kCellsPerRow) - kCellPadding;

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
    return [self.photoURLS count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.photoURL = [self.photoURLS objectAtIndex:indexPath.row];
    return cell;
}

- (void)respondToTapGesture:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.detailsController removeFromParentViewController];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //FSPhotoCell* cell = (FSPhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
    self.detailsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoDetailsViewController"];
    [self.detailsController.view setBounds:self.containerView.frame];
    [self addChildViewController:self.detailsController];
    [self.containerView addSubview:self.detailsController.view];
    [UIView animateWithDuration:0.3f animations:^{
        self.containerView.alpha = 1.f;
    }];
}


     
@end
