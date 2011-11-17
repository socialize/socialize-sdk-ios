//
//  CommentMapView.h
//  appbuildr
//
//  Created by Sergey Popenko on 4/8/11.
//  Copyright 2011 pointabout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CommentMapView : MKMapView {
}

-(void) setFitLocation: (CLLocationCoordinate2D) location withSpan: (MKCoordinateSpan) span;
-(void) setAnnotationOnPoint: (CLLocationCoordinate2D) centerPoint;
-(void) roundCorners;

+(MKCoordinateSpan) coordinateSpan;

@end
