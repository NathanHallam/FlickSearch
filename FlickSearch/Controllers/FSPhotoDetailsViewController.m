//
//  FSPhotoDetailsViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 7/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSPhotoDetailsViewController.h"
#import "Haneke.h"
#import "FlickrKit.h"

@interface FSPhotoDetailsViewController ()

@property (nonatomic, strong) IBOutlet UIImageView* photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

@end

@implementation FSPhotoDetailsViewController

- (void)viewDidLoad {
    NSLog(@"%@",self.photo);
    [self.photoNameLabel setText:[self.photo objectForKey:@"title"]];
    NSURL* url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall320 fromPhotoDictionary:_photo];
    [self.photoImageView hnk_setImageFromURL:url placeholder:nil success:^(UIImage *image) {
        [self.photoImageView setImage:image];
        [UIView animateWithDuration:.7f animations:^{
            self.photoImageView.alpha = 1.f;
        }];
        [self.indicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@",error);
        [self.indicator stopAnimating];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
