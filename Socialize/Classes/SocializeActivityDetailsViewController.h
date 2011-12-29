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

}
-(IBAction)profileButtonTapped:(id)sender;
-(id)initWithActivity:(id<SocializeActivity>)socializeActivity;
    
@property (nonatomic, retain) IBOutlet SocializeActivityDetailsView*     activityDetailsView;
@property (nonatomic, retain) id<SocializeActivity> socializeActivity;
@property (nonatomic, retain) URLDownload* profileImageDownloader;
@property (nonatomic, retain) ImagesCache*  cache;
@property (nonatomic, retain) SocializeActivityViewController*  activityViewController;


@end
