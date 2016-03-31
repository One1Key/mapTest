//
//  ViewController.m
//  mapTest
//
//  Created by mac book on 15/12/8.
//  Copyright © 2015年 mac book. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MineMKAnnotation.h"

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UITextField *textfield;
@end

@implementation ViewController

@synthesize locationManager;
@synthesize mapView;
@synthesize geocoder;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    
    if (!locationManager.locationServicesEnabled) {
        NSLog(@"不可定位");
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //定位频率,每隔多少米定位一次
        locationManager.distanceFilter = 1.f;
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
    }
    
    
    
//    [locationManager requestWhenInUseAuthorization];
//    [locationManager startUpdatingLocation];
    
    mapView = [[MKMapView alloc] init];
    mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 1);
//    mapView.showsUserLocation = YES;
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
//    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
//    mapView.mapType = MKMapTypeHybrid;
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [mapView addGestureRecognizer:tap];
    
    
//    [self getAddressByLatitude:39.545454 longitude:116.284545];
    
    
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:@"button" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(250, 100, 100, 50);
    textField.placeholder = @"占位文字";
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = [UIColor blackColor];
    [self.view addSubview:textField];
    _textfield = textField;
    
    geocoder = [[CLGeocoder alloc] init];
//    [self getCoordinateByAdress:@"北京"];
    [self.locationManager startUpdatingLocation];
}
- (void)updateLocationBy:(CLLocationDegrees)lat and:(CLLocationDegrees)lon{
    CLLocationDegrees latitude = lat;
    CLLocationDegrees longtitude = lon;

    CLLocation *showLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
    mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
}
- (void)buttonAction:(UIButton *)btn{
    [locationManager startUpdatingHeading];
    NSLog(@"%s",__func__);
    [self getCoordinateByAdress:_textfield.text];
//    [locationManager startUpdatingHeading];
    [self.view endEditing:YES];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:tap.view];
    CLLocationCoordinate2D coord = [mapView convertPoint:point toCoordinateFromView:mapView];
    MineMKAnnotation *anno = [[MineMKAnnotation alloc] init];
    anno.coordinate = coord;
    anno.title0 = @"新加大头针";
    anno.subtitle0 = @"123";
    [mapView addAnnotation:anno];
    [self getAddressByLatitude:coord.latitude longitude:coord.longitude];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    [locationManager stopUpdatingLocation];
    NSLog(@"%s\n经度:%f\n纬度:%f\n海拔：%f\n航向：%f\n行走速度：%f",__func__,coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//
}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%s",__func__);
}
//加载完地图
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"%s",__func__);
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //点击大头针，会出现以下信息
    self.mapView.userLocation.title = @"雍和宫";
    self.mapView.userLocation.subtitle = @"123141241";
    //让地图显示用户的位置（iOS8一打开地图会默认转到用户所在位置的地图），该方法不能设置地图精度
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //这个方法可以设置地图精度以及显示用户所在位置的地图
    MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [self.mapView setRegion:region animated:YES];
    [self.view endEditing:YES];
    
    NSLog(@"%s\n%@\n%@\n%@",__func__,mapView.userLocation.title,self.mapView.userLocation.subtitle,userLocation);
//    mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}
//返地理编码
#pragma mark - 根据地名确定地理坐标
- (void)getCoordinateByAdress:(NSString *)address{
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        
        NSLog(@"----------位置:%f--%f,区域:%@,详细信息:%@",location.coordinate.longitude,location.coordinate.latitude,region,addressDic);
        [self updateLocationBy:location.coordinate.latitude and:location.coordinate.longitude];
//        [locationManager startUpdatingLocation];
    }];
}
#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSDictionary *addressDic = placemark.addressDictionary;
        NSLog(@"+++++++++++详细信息:%@",addressDic);
        [self updateLocationBy:location.coordinate.latitude and:location.coordinate.longitude];
    }];
}

@end
