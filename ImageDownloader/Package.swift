// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ImageDownloader",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "ImageDownloader",
      targets: ["ImageDownloader"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0"))
  ],
  targets: [
    .target(
      name: "ImageDownloader",
      dependencies: [
        "Alamofire"
      ]
    ),
    .testTarget(
      name: "ImageDownloaderTests",
      dependencies: ["ImageDownloader"]),
  ]
)
