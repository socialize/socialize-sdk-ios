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

@class CommentDetailsView;
@class URLDownload;
@protocol SocializeComment;
@class ImagesCache;

typedef URLDownload*(^LoaderFactory)(NSString* url, id sender, SEL selector, id tag);

@interface SocializeCommentDetailsViewController : SocializeBaseViewController 
{
    @private
        CommentDetailsView*     commentDetailsView;
        id<SocializeComment>    comment;
        ImagesCache*            cache;
}
-(IBAction)profileButtonTapped:(id)sender;

@property (nonatomic, retain) IBOutlet CommentDetailsView*     commentDetailsView;
@property (nonatomic, retain) id<SocializeComment>    comment;
@property (nonatomic, retain) URLDownload* profileImageDownloader;
@property (nonatomic, retain) LoaderFactory loaderFactory;
@property (nonatomic, retain) ImagesCache*  cache;

@end
