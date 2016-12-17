//
//  ViewController.swift
//  MapData
//
//  Created by timecapsule07 on 2016/12/15.
//  Copyright © 2016年 TimeCapsule. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    //MARK: Member Variables
    
    //位置情報有効フラグを下げておく
    var enableLocation = false
    
    var locationLongitude: CLLocationDegrees!
    var locationLatitude : CLLocationDegrees!
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //LocationManager生成
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        //位置情報の取得頻度を、指定したm数移動するごとに更新するよう変更
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //5m移動するごとに位置情報を更新
        self.locationManager.distanceFilter = 5
        //App使用中のみの位置情報取得をユーザに確認
        self.locationManager.requestWhenInUseAuthorization()
        //座標の取得を開始する。
        self.locationManager.startUpdatingLocation()
        
        // 地図の機能を有効化
        self.mapView.delegate = self;
        self.mapView.userTrackingMode = MKUserTrackingMode.Follow;
        
        //位置情報の取得開始
        self.locationManager.startUpdatingLocation()
        //以下、追記分
        //MapViewの各種の設定
        self.mapView.delegate = self
        self.mapView.userTrackingMode = MKUserTrackingMode.Follow
        //追記ここまで
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.enableLocation) {
            //地図の中心位置に現在地を指定
            var co = CLLocationCoordinate2D()
            co.latitude = self.locationLatitude
            co.longitude = self.locationLongitude
            self.mapView.centerCoordinate = co
            
            //表示縮尺の設定
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: co, span: span)
            self.mapView.setRegion(region, animated: true)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //位置情報の更新成功時にコールされるdelegateメソッド
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //緯度と経度を取得、メンバ変数へ保存
        self.locationLongitude = newLocation.coordinate.longitude
        self.locationLatitude = newLocation.coordinate.latitude
        
        //位置情報有効フラグを立てる
        self.enableLocation = true
        
        //ログ出力
        print("位置情報が更新されました")
    }
    //位置情報の更新失敗時にコールされるdelegateメソッド
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //位置情報の更新を停止する
        self.locationManager.stopUpdatingLocation()
    }


}

