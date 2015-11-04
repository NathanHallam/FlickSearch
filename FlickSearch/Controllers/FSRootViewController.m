//
//  FSRootViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 4/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSRootViewController.h"
#import "FlickrKit.h"

@interface FSRootViewController ()

@end

@implementation FSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"2076e48d7d3e951cf8e6b3685c8dd44d" sharedSecret:@"6138b35cb585e73d"];
    
    [self performSegueWithIdentifier:@"RootPhotosSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
