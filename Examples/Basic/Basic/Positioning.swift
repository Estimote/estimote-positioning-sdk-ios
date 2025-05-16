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
    
    private let anchorsJSON = """
    [
      { "id": "1cae6cfe66c0af54fab296ab320af019", "x": 0.0, "y": 0.0 },
      { "id": "d67ad7275ea880fad54313368470610f", "x": 4.0, "y": 0.0 },
      { "id": "f8bf584d6f3221ee9cb3bdcc723ee12e", "x": 4.0, "y": 8.0 },
      { "id": "9db1c7f4f64c4fc4a52f6e01d121c07a", "x": 0.0, "y": 8.0 }
    ]
    """
    
    init() {
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
