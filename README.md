# Estimote Positioning SDK for iOS (beta)

> **Compatibility Notice**
> This SDK supports Estimote UWB Beacons manufactured **after March 2025**. Earlier hardware revisions are not compatible.

**EstimotePositioningSDK** is an optional extension for the [EstimoteSDK](https://github.com/Estimote/estimote-sdk-ios) that provides real-time 2D positioning of the phone using distance estimates from multiple Estimote UWB Proximity Beacons. It is designed for indoor use cases such as navigation, tracking, or spatial interaction.

## Features

- Real-time 2D position estimation from Estimote UWB Proximity Beacons  
- Optimization-based calculations for accuracy in real-world conditions  
- High-performance computation using Apple's Accelerate framework
- Combine-based reactive API

## Installation

**EstimotePositioningSDK** is distributed via *Swift Package Manager* and internally depends on core **EstimoteSDK**. To integrate it into your Xcode project:

1. Open your project in Xcode.
2. Go to *File > Add Packages...*
3. Enter the EstimotePositioningSDK GitHub repository URL:

   `https://github.com/Estimote/estimote-positioning-sdk-ios.git`

4. Select the latest available version (e.g. `1.0.0-beta`) or specify a version range:

   `.package(url: "https://github.com/Estimote/estimote-positioning-sdk-ios.git", from: "1.0.0-beta")`

Make sure **EstimotePositioningSDK** is added to your target.

## Usage

### 1. Define Anchors

Anchors are fixed-position beacons. You must provide their known positions as a JSON array, using a Cartesian coordinate system (flat 2D plane) such as a floor plan. All distances must be expressed in meters, and the anchors should be positioned consistently relative to one another within the same reference frame.

```json
[
{ "id": "1cae6cfe66c0af54fab296ab320af019", "x": 0.0, "y": 0.0 },
{ "id": "d67ad7275ea880fad54313368470610f", "x": 0.0, "y": 3.0 },
{ "id": "f8bf584d6f3221ee9cb3bdcc723ee12e", "x": 3.0, "y": 0.0 }
]
```

Save this file to your app bundle as **anchors.json**.

### 2. Set Up Positioning

```swift
import EstimotePositioningSDK

// Load anchors from anchors.json in the app bundle
guard let url = Bundle.main.url(forResource: "anchors", withExtension: "json"),
      let anchorsJSON = try? String(contentsOf: url) else {
    fatalError("Could not load anchors.json")
}

// Initialize the positioning manager with anchor configuration and an optional `DeviceManager` from the core **EstimoteSDK** if you want to share it – e.g., using both distance and positioning updates; otherwise, the `EstimotePositioningManager` creates its own instance
let positioningManager = EstimotePositioningManager(anchorsJSON: anchorsJSON)

// Start the positioning process using ARKit-based camera assistance
positioningManager.startPositioning(withCameraAssistance: true)
```

### 3. Observe Position Updates

```swift
positioningManager.observePositionUpdates { position in
    print("Estimated position: (\(position.x), \(position.y)), error: \(position.error)")
}
```

or

```swift
positioningManager.observePositionUpdates()
    .sink { position in
        print("Estimated position: (\(position.x), \(position.y)), error: \(position.error)")
    }
    .store(in: &cancellables)
```

or, one-liner binding into your own @Published value

```swift
positioningManager.$position.assign(to: &$position)
```

### 4. Stop Positioning

```swift
positioningManager.stopPositioning()
```

Ensure the necessary keys are included in your app's `Info.plist`:

- `NSBluetoothAlwaysUsageDescription`: EstimoteSDK requires Bluetooth access to communicate with nearby Estimote Beacons.
- `NSNearbyInteractionUsageDescription`: EstimoteSDK requires Nearby Interaction access to measure distance to nearby Estimote Beacons.
- Optionally, `NSCameraUsageDescription`: EstimotePositioningSDK in `withCameraAssistance` mode requires Camera access to precisely measure distance and angle to nearby Estimote devices.

## How Estimote Positioning SDK Works

Instead of relying on basic trilateration, Estimote Positioning SDK uses an iterative optimization process to estimate the phone’s position from live distance data. This approach calculates the best-fit location that minimizes the difference between measured and expected distances to known anchors.

This is particularly important in real-world conditions, where signal noise, reflections, and minor measurement errors are unavoidable. The optimization smooths out these inconsistencies and produces more stable and reliable results compared to purely geometric methods.

The SDK also computes an error value for each estimated position, helping you understand how accurate the result is.

Internally, the system uses Apple’s **Accelerate** framework for high-performance vector math and matrix operations. This ensures fast, efficient computation even on resource-constrained devices.

To further enhance accuracy, the SDK can optionally use **ARKit** to provide camera-assisted context when available. This enables better heading and orientation information, which is especially valuable in indoor environments. Using the camera improves stability and responsiveness of the positioning output when supported.

All results are delivered using **Combine**, so you can subscribe to position updates reactively — perfect for SwiftUI, animations, or custom logic triggered by movement.

## License

© Estimote 2025. All rights reserved.

This software is licensed under a commercial license.  
Unauthorized use, modification, or distribution is strictly prohibited.  

For licensing inquiries, please contact *contact@estimote.com*.
