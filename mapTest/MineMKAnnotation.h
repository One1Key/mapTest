//
//  MineMKAnnotation.h
//  mapTest
//
//  Created by mac book on 15/12/8.
//  Copyright © 2015年 mac book. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MineMKAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title0;
@property (nonatomic, copy) NSString *subtitle0;

@end
