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
@property (strong, nonatomic) IBOutlet UILabel *photoTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *photoDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoAuthorLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoLocationLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

@end

@implementation FSPhotoDetailsViewController

- (void)viewDidLoad {
    [self.photoTitleLabel setText:[self.photo objectForKey:@"title"]];
    
    FlickrKit* fk = [FlickrKit sharedFlickrKit];
    
    NSURL* url = [fk photoURLForSize:FKPhotoSizeMedium640 fromPhotoDictionary:_photo];
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
