//
//  Positioning.swift
//  Basic
//
//  Created by Estimote on 2025-03-12.

import Foundation
//import EstimoteSDK
import EstimotePositioningSDK

/*
 📋 Permissions & Capabilities Setup
 
 To use EstimotePositioningSDK properly, add core EstimoteSDK first.
 Then, ensure the following entries are added to your app's Info.plist:
 
 - `NSBluetoothAlwaysUsageDescription`:
 A string explaining why your app needs Bluetooth access.
 
 - `NSNearbyInteractionUsageDescription`:
 A string explaining why your app uses Nearby Interaction (required for UWB).
 
 - `NSCameraUsageDescription` (optional):
 Required if you enable camera-assisted positioning for improved accuracy.
 */

class Positioning: ObservableObject {
    
    //    private let deviceManager = EstimoteDeviceManager()
    private var positioningManager: EstimotePositioningManager!
    @Published private(set) var position: EstimotePositioningSDK.EstimatedPosition?
    
    init() {
        // Load anchors from anchors.json in the app bundle
        guard let url = Bundle.main.url(forResource: "anchors", withExtension: "json"),
              let anchorsJSON = try? String(contentsOf: url) else {
            fatalError("Could not load anchors.json")
        }
        
        positioningManager = EstimotePositioningManager(anchorsJSON: anchorsJSON)
        positioningManager.startPositioning(withCameraAssistance: true)
        
        // Observe position updates calulated using nearby Estimote UWB Beacons
        positioningManager.observePositionUpdates({ position in
            print("Estimated position: (\(position.x), \(position.y)), error: \(position.error)")
        })
        
//        positioningManager.observePositionUpdates()
//            .receive(on: DispatchQueue.main)
//            .sink { print($0) }
//            .store(in: &cancellables)
        
        // Or forward SDK updates into our @Published value
        positioningManager.$position.assign(to: &$position)
    }
}
