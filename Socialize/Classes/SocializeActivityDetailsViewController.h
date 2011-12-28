//
//  CommentDetailsViewController.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/6/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SocializeBaseViewController.h"
#import "SocializeActivityDetailsView.h"
#import "SocializeActivityViewController.h"

@class CommentDetailsView;
@class URLDownload;
@protocol SocializeActivity;
@class ImagesCache;

@interface SocializeActivityDetailsViewController : SocializeBaseViewController 
{
    @private
        SocializeActivityDetailsView*     activityDetailsView;
        ImagesCache*            cache;
}
-(IBAction)profileButtonTapped:(id)sender;
-(id)initWithActivity:(id<SocializeActivity>)socializeActivity;
-(void)addActivityControllerToView;
    
@property (nonatomic, retain) IBOutlet SocializeActivityDetailsView*     activityDetailsView;
@property (nonatomic, retain) id<SocializeActivity> socializeActivity;
@property (nonatomic, retain) NSString *activityDisplayText;
@property (nonatomic, retain) URLDownload* profileImageDownloader;
@property (nonatomic, retain) ImagesCache*  cache;
@property (nonatomic, retain) SocializeActivityViewController*  activityViewController;


@end
