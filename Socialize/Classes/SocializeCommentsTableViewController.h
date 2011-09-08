//
//  SocializeCommentsTableViewController.h
//  appbuildr
//
//  Created by Fawad Haider  on 12/2/10.
//  Copyright 2010 pointabout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocializeService.h"
#import "CommentsTableFooterView.h"
#import "TableBGInfoView.h"
#import "PostCommentViewController.h"
#import "Socialize.h"
#import "LoadingView.h"
#import "ImagesCache.h"

/*
@protocol SocializeCommentsDelegate 

-(void)postComment:(NSString*)commentText location:(CLLocation *)commentLocation shareLocation:(BOOL)shareLocation;
-(void)startFetchingComments;

@end
*/

@class CommentsTableViewCell;

@interface SocializeCommentsTableViewController : UIViewController<UITableViewDataSource, SocializeServiceDelegate> 
{

	IBOutlet UITableView*   _tableView;
	IBOutlet UIView*        backgroundView;
	IBOutlet UIImageView*   brushedMetalBackground;
	IBOutlet UIView*        roundedContainerView;
	IBOutlet UIImageView*   noCommentsIconView;
	
	BOOL				_isLoading;
	BOOL				_errorLoading;
    LoadingView*        _loadingView;
    
	NSArray*            _arrayOfComments;
	NSDateFormatter*    _commentDateFormatter;

	CommentsTableFooterView*      footerView;
	TableBGInfoView*              informationView; 
    CommentsTableViewCell*        commentsCell;
    
    SocializeEntity*              _entity;
    Socialize*                    _socialize;
    ImagesCache*                  _cache;
}

@property (retain, nonatomic) IBOutlet UITableView  *_tableView;
@property (retain, nonatomic) IBOutlet UIToolbar    *topToolBar;
@property (retain, nonatomic) IBOutlet UIImageView	*brushedMetalBackground;
@property (retain, nonatomic) IBOutlet UIView		*backgroundView;
@property (retain, nonatomic) IBOutlet UIView		*roundedContainerView;
@property (retain, nonatomic) IBOutlet UIImageView	*noCommentsIconView;

@property (nonatomic, assign) IBOutlet CommentsTableViewCell     *commentsCell;
@property (retain, nonatomic) IBOutlet CommentsTableFooterView   *footerView;

-(IBAction)addCommentButtonPressed:(id)sender;

-(void)addNoCommentsBackground;
-(void)removeNoCommentsBackground;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entryUrlString:(NSString*) entryUrlString;
@end
