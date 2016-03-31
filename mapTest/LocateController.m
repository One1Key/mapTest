//
//  LocateController.m
//  mapTest
//
//  Created by mac book on 15/12/15.
//  Copyright © 2015年 mac book. All rights reserved.
//

#import "LocateController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MineMKAnnotation.h"
#import "UIView+Extension.h"

@interface LocateController()<CLLocationManagerDelegate,MKMapViewDelegate                  ,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic) int num;
//--------------
@property (nonatomic, strong) UITableView *mapItemTableView;
@property (nonatomic, strong) NSMutableArray *mapItemsArray;
@end

@implementation LocateController
- (void)viewDidLoad{
    [super viewDidLoad];
    
//    locationManager = [[CLLocationManager alloc] init];
//    
//    if (!locationManager.locationServicesEnabled) {
//        NSLog(@"不可定位");
//    }
//    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
//        [locationManager requestWhenInUseAuthorization];
//    }
//    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
//        //定位频率,每隔多少米定位一次
//        locationManager.distanceFilter = 1.f;
//        //设置定位精度
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        locationManager.delegate = self;
//        
//    }
    
    _manager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_manager requestWhenInUseAuthorization];
    }else{
        _manager.delegate = self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 10.f;
    }
    
    
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.5);
    mapView.delegate = self;
    [self.view addSubview:mapView];
    _mapView = mapView;
    
    UIView *signView = [[UIView alloc] init];
    signView.frame = CGRectMake(mapView.width * 0.5 - 5 , mapView.height * 0.5 - 5, 10, 10);
    signView.backgroundColor = [UIColor redColor];
    [self.view addSubview:signView];
    _signView = signView;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [mapView addGestureRecognizer:tap];

    _geocoder = [[CLGeocoder alloc] init];
//    CLLocationDegrees lat = 39.91835400;
//    CLLocationDegrees lon = 116.38023350;
//    [self getAddressByLatitude:lat longitude:lon];
    [self.manager startUpdatingLocation];
//    [self getCoordinateByAdress:@"北京雍和宫"];
//    [self encodeLocationCoordinateByAddress:@"北京雍和宫"];
    [self createTableView];
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationInView:self.mapView];
    CLLocationCoordinate2D coord = [_mapView convertPoint:point toCoordinateFromView:self.mapView];
//    [self setUpRegion:coord naturalLanguageQuery:nil];
    MineMKAnnotation *annotation = [[MineMKAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title0 = @"12121";
    [_mapView addAnnotation:annotation];
    [self getAddressByLatitude:coord.latitude longitude:coord.longitude];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self startLocation];
    NSLog(@"%s",__func__);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
//    [self tapAction:nil];
}
- (void)startLocation{
    [_manager startUpdatingLocation];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
//    [self tapAction:nil];
//    CLLocationCoordinate2D coord = [_mapView convertPoint:self.signView.center toCoordinateFromView:self.mapView];
//    MineMKAnnotation *annotation = [[MineMKAnnotation alloc] init];
//    annotation.coordinate = coord;
//    annotation.title0 = @"12121";
//    [_mapView addAnnotation:annotation];
//    [self getAddressByLatitude:coord.latitude longitude:coord.longitude];
    NSLog(@"%s",__func__);
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    if (_num >= 2) {
//        CLLocationCoordinate2D coord = [_mapView convertPoint:self.signView.center toCoordinateFromView:self.mapView];
//        MineMKAnnotation *annotation = [[MineMKAnnotation alloc] init];
//        annotation.coordinate = coord;
//        annotation.title0 = @"12121";
//        [_mapView addAnnotation:annotation];
//        [self getAddressByLatitude:coord.latitude longitude:coord.longitude];
//    }
//    _num ++;
//    [self tapAction:nil];
//    [self setUpRegion:mapView.centerCoordinate naturalLanguageQuery:@"街"];
    [self getAddressByLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    NSLog(@"%s",__func__);
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"%s",__func__);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    NSLog(@"%s",__func__);
    CLLocation *location = [locations firstObject];
//    NSLog(@"------>%@",locations);
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    //    self getCoordinateByAdress:
}
#pragma mark -  根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    NSLog(@"%s",__func__);
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSDictionary *addressDic = placemark.addressDictionary;
        NSLog(@"+++++++++++详细信息:%@--%@",addressDic,/*placemark*/nil);
        [self setUpRegion:placemark.location.coordinate naturalLanguageQuery:placemark.name];
        NSLog(@"888888-----1>%s",__func__);
//        [self updateLocationBy:latitude and:longitude];
//        [self.manager stopUpdatingLocation];
    }];
    NSLog(@"888888-----2>%s",__func__);
    [self updateLocationBy:latitude and:longitude];
//    [self.manager stopUpdatingLocation];
}
#pragma mark -  根据地名取得坐标
//地理编码
- (void)encodeLocationCoordinateByAddress:(NSString *)address{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = placemarks[0];
        CLLocation *location = placemark.location;
        [self setUpRegion:location.coordinate naturalLanguageQuery:placemark.name];
    }];
}
- (void)getCoordinateByAdress:(NSString *)address{
    NSLog(@"%s",__func__);
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
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
        NSMutableArray *array = [NSMutableArray array];
        for (CLPlacemark *plmark in placemarks) {
            [array addObject:plmark.addressDictionary];
        }
//        NSLog(@"------>>>%ld》》》》%@\n\n\n---->%@",placemarks.count,array,placemarks[0]);
        NSLog(@"----------位置:%f--%f,区域:%@,详细信息:%@",location.coordinate.longitude,location.coordinate.latitude,region,addressDic);
        [self updateLocationBy:location.coordinate.latitude and:location.coordinate.longitude];
        [self setUpRegion:location.coordinate naturalLanguageQuery:placemark.name];
        //        [locationManager startUpdatingLocation];
    }];
}
#pragma mark - 附近兴趣点检索
- (void)setUpRegion:(CLLocationCoordinate2D)centerCoordinate naturalLanguageQuery:(NSString *)naturalLanguageQuery{
    NSLog(@"%s",__func__);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, 10000, 10000);
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.region = region;
    request.naturalLanguageQuery = naturalLanguageQuery;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mapItems = response.mapItems;
//        for (MKMapItem *item in mapItems) {
//            
//        }
        MKMapItem *item0 = mapItems[0];
        NSLog(@"-----^^^^^^item>>:%@===%@===%@===",nil,/*mapItems[0]*/nil,item0.placemark.addressDictionary);
        //----------
        [_mapItemsArray removeAllObjects];
        [_mapItemsArray addObjectsFromArray:mapItems];
        [_mapItemTableView reloadData];
    }];
}
#pragma mark - 地图添加annotation
- (void)updateLocationBy:(CLLocationDegrees)lat and:(CLLocationDegrees)lon{
    
    NSLog(@"%s",__func__);
    CLLocationDegrees latitude = lat;
    CLLocationDegrees longtitude = lon;
    
    CLLocation *showLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
//    _mapView.centerCoordinate = showLocation.coordinate;
//    _mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
    _mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
//    _mapView.region = MKCoordinateRegionMakeWithDistance(showLocation.coordinate, 5000, 5000);
//    _mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.000001, 0.000001));
//    MineMKAnnotation *annotation = [[MineMKAnnotation alloc] init];
//    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
//    annotation.title0 = @"我的位置";
//    annotation.subtitle0 = @"niakan";
//    [_mapView addAnnotation:annotation];
}

#pragma mark - 添加兴趣点列表
- (void)createTableView{
    _mapItemsArray = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = CGRectMake(0, self.view.height * 0.5, self.view.width, self.view.height * 0.5);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _mapItemTableView = tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mapItemsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"1"];
    }
    MKMapItem *item = _mapItemsArray[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.name;
    return cell;
}

@end
