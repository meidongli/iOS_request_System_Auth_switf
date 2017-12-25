//
//  ViewController.swift
//  ZGSystemAuth
//
//  Created by Jax on 2017/12/25.
//  Copyright © 2017年 Jax. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    ///>获取麦克风权限
    @IBAction func getMicrophoneAuth(_ sender: UIButton) {
        requestSystemAuth(authType: ZGSystemAuthType.mediaAudio, authorizedBlock: { () -> (Void) in
            print("使用麦克风")
        }, deniedBlock: { () -> (Void) in
            print("无麦克风权限")
        })
    }
    
    @IBAction func getPhotoLibraryAuth(_ sender: UIButton) {
        requestSystemAuth(authType: ZGSystemAuthType.photoLibrary, authorizedBlock: { () -> (Void) in
            print("使用相册")
        }, deniedBlock: {() -> (Void) in
            print("无相册权限")
        })
    }
    
    @IBAction func getMediaVideoAuth(_ sender: UIButton) {
        requestSystemAuth(authType: ZGSystemAuthType.mediaVideo, authorizedBlock: { () -> (Void) in
            print("使用相机")
        }, deniedBlock: {() -> (Void) in
            print("无相机权限")
        })
    }
    
    @IBAction func getContactAuth(_ sender: UIButton) {
        requestSystemAuth(authType: ZGSystemAuthType.contact, authorizedBlock: { () -> (Void) in
            print("使用通讯录")
        }, deniedBlock: {() -> (Void) in
            print("无通讯录权限")
        })
    }

    @IBAction func getLocationAuth(_ sender: UIButton) {
        locationManager = CLLocationManager.init()
        
        requestSystemLocation(locationManager: locationManager!, whenInUseAuthorization: true, alwaysAuthorization: false, authorizedBlock: { () -> (Void) in
            self.locationManager!.delegate = self;
            self.locationManager!.startUpdatingLocation()
        }, deniedBlock: { () -> (Void) in
            print("无定位权限")
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            print(locations.last!)
            manager.stopUpdatingLocation()
        }
    }
}

