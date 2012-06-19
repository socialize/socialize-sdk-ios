//
//  ActivityDetailsViewControllerTests.h
//  SocializeSDK
//
//  Created by Isaac Mosquera on 12/29/11.
//  Copyright (c) 2011 Socialize, Inc. All rights reserved.
//

#import "SocializeBaseViewControllerTests.h"
#import "SocializeActivityDetailsViewController.h"

@interface ActivityDetailsViewControllerTests : SocializeBaseViewControllerTests

{
    
}
@property (nonatomic, retain) SocializeActivityDetailsViewController* activityDetailsViewController;
@property (nonatomic, retain) id partialActivityDetailsViewController;
@property (nonatomic, retain) id mockActivityDetailsView;
@property (nonatomic, retain) id mockSocializeActivity;
@property (nonatomic, retain) id mockActivityViewController;
@property (nonatomic, retain) id mockSocializeUser;
@property (nonatomic, retain) id mockShowEntityButton;
@property (nonatomic, retain) id mockTableView;
@end
