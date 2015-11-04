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


@interface FSPhotoCell ()

@property (nonatomic, strong) IBOutlet UIImageView* photoImageView;

@end

@implementation FSPhotoCell

- (void)setPhotoURL:(NSURL *)photoURL
{
    if(_photoURL != photoURL) {
        _photoURL = photoURL;
        
        [self.photoImageView hnk_setImageFromURL:photoURL];
        
        [UIView animateWithDuration:3.f animations:^{
            self.photoImageView.alpha = 1.f;
        }];
    }
}


@end
