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
@property (nonatomic, strong) IBOutlet UILabel *photoTitleLabel;
@property (nonatomic, strong) IBOutlet UITextView *photoDescriptionText; 
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *metaIndicator;

@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;

@end

@implementation FSPhotoDetailsViewController

- (void)viewDidLoad {
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapGesture:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    
    [self.photoTitleLabel setText:[self.photo objectForKey:@"title"]];
    
    FlickrKit* fk = [FlickrKit sharedFlickrKit];
    NSURL* url = [fk photoURLForSize:FKPhotoSizeMedium640 fromPhotoDictionary:self.photo];
    
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
    
    [fk call:@"flickr.photos.getInfo" args:@{@"photo_id" : self.photo[@"id"]} completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.metaIndicator stopAnimating];
            if (response) {
                NSString* description = response[@"photo"][@"description"][@"_content"];
                description = [description isEqualToString:@""] ? @"No description available" : description;
                self.photoDescriptionText.text = description;
            } else {
                NSLog(@"No response");
            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)respondToTapGesture:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
@end
