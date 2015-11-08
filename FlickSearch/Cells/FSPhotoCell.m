//
//  FSPhotoCell.m
//  FlickSearch
//
//  Created by Nathan Hallam on 4/11/2015.
//  Copyright © 2015 Nathan Hallam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPhotoCell.h"
#import "Haneke.h"
#import "FlickrKit.h"

@interface FSPhotoCell ()

@property (nonatomic, strong) IBOutlet UIImageView* photoImageView;
@property (nonatomic) BOOL blinking;

@end

@implementation FSPhotoCell

-(void)setPhoto:(NSDictionary *)photo
{
    if(_photo != photo) {
        _photo = photo;
        [self photoPlaceHolder];
        //Load photo and display
        NSURL* url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLargeSquare150 fromPhotoDictionary:_photo];
        [self.photoImageView hnk_setImageFromURL:url placeholder:nil success:^(UIImage *image) {
            [self.layer removeAllAnimations];
            [self.photoImageView setImage:image];
            [UIView animateWithDuration:.3f animations:^{
                self.photoImageView.alpha = 1.f;
            }];
        } failure:^(NSError *error) {
            NSLog(@"Error: %@",error);
        }];
        
    }
    
    
}

//Animate with a blinking placeholder
- (void)photoPlaceHolder
{
    [self.photoImageView setImage:nil];
    self.photoImageView.alpha = 0.f;
    [self.layer removeAllAnimations];
    [self setBackgroundColor:[UIColor darkGrayColor]];
    [UIView animateWithDuration:0.7f delay:0.f usingSpringWithDamping:.2f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:77.f/255.f green:133.f/255.f blue:24.f/255.f alpha:.8f]];
    } completion:nil];
}



@end
