//
//  ZGSystemAuth.swift
//  ZGSystemAuth
//
//  Created by Jax on 2017/12/25.
//  Copyright © 2017年 Jax. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation
import Contacts
import Photos

public typealias ZGSystemAuthAuthorizedBlock = () -> (Void)
public typealias ZGSystemAuthDeniedBlock = () -> (Void)

public enum ZGSystemAuthType : Int {
    case mediaAudio //>麦克风
    case photoLibrary //>相册
    case mediaVideo //>相机
    case contact //>联系人
}

public func requestSystemAuth(authType: ZGSystemAuthType, authorizedBlock: @escaping ZGSystemAuthAuthorizedBlock, deniedBlock: @escaping ZGSystemAuthDeniedBlock) {
    switch authType {
    case .mediaAudio:
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch authStatus {
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                DispatchQueue.main.async {
                    if granted {
                        authorizedBlock()
                    } else {
                        deniedBlock()
                    }
                }
            })
        case .restricted:
            deniedBlock()
        case .denied:
            deniedBlock()
        case .authorized:
            authorizedBlock()
        }
    case .photoLibrary:
        let authStatus:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    authorizedBlock()
                } else {
                    deniedBlock()
                }
            })
            case .restricted:
                deniedBlock()
            case .denied:
                deniedBlock()
            case .authorized:
                authorizedBlock()
        }
    case .mediaVideo:
        if AVCaptureDevice.responds(to: #selector(AVCaptureDevice.authorizationStatus(for:))) {
            let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if granted {
                        authorizedBlock()
                    } else {
                        deniedBlock()
                    }
                })
            case .restricted:
                deniedBlock()
            case .denied:
                deniedBlock()
            case .authorized:
                authorizedBlock()
            }
        }
    case .contact:
        if (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0 {
            let authStatus:CNAuthorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            switch authStatus {
            case .notDetermined:
                CNContactStore.init().requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) in
                    if granted && (error == nil){
                        authorizedBlock()
                    } else {
                        deniedBlock()
                    }
                })
            case .restricted:
                deniedBlock()
            case .denied:
                deniedBlock()
            case .authorized:
                authorizedBlock()
            }
        }
    }
}

///>定位权限
public func requestSystemLocation(locationManager: CLLocationManager, whenInUseAuthorization: Bool, alwaysAuthorization: Bool, authorizedBlock: @escaping ZGSystemAuthAuthorizedBlock, deniedBlock: @escaping ZGSystemAuthDeniedBlock) {
    let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    switch authStatus {
    case .notDetermined:
        if whenInUseAuthorization {
            locationManager.requestWhenInUseAuthorization()
            authorizedBlock()
        }
        if alwaysAuthorization {
            locationManager.requestWhenInUseAuthorization()
            authorizedBlock()
        }
    case .restricted:
        deniedBlock()
    case .denied:
        deniedBlock()
    case .authorizedAlways:
        authorizedBlock()
    case .authorizedWhenInUse:
        authorizedBlock()
    }
}
