//
//  FSRootViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 4/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSRootViewController.h"
#import "FSPhotosViewController.h"
#import "FlickrKit.h"

@interface FSRootViewController ()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* indicator;

@end

@implementation FSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.indicator startAnimating];

    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"2076e48d7d3e951cf8e6b3685c8dd44d" sharedSecret:@"6138b35cb585e73d"];
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmallSquare75 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
            }
            NSLog(@"URLs Loaded: %lu",[photoURLs count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicator stopAnimating];
                [self performSegueWithIdentifier:@"RootPhotosSegue" sender:photoURLs];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"RootPhotosSegue"]) {
        FSPhotosViewController* destination = segue.destinationViewController;
        destination.photoURLS = sender;
    }
}


@end
