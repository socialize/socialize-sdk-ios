//
//  CommentDetailsViewController.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CommentDetailsView;
@protocol SocializeComment;

@interface CommentDetailsViewController : UIViewController<MKReverseGeocoderDelegate> 
{
    @private
        MKReverseGeocoder*      geoCoder;
        CommentDetailsView*     commentDetailsView;
        id<SocializeComment>    comment;
}

@property (nonatomic, retain) IBOutlet CommentDetailsView*     commentDetailsView;
@property (nonatomic, retain) IBOutlet id<SocializeComment>    comment;

@end
