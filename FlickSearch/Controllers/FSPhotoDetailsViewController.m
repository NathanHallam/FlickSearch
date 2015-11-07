//
//  FSPhotoDetailsViewController.m
//  FlickSearch
//
//  Created by Nathan Hallam on 7/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import "FSPhotoDetailsViewController.h"

@interface FSPhotoDetailsViewController ()

@property (nonatomic, strong) IBOutlet UIImageView* photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *photoNameLabel;

@end

@implementation FSPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.photoNameLabel setText:@"Photo Test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
