// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PXiCalendar",
  products: [
    .library(
      name: "PXiCalendar",
      targets: ["PXiCalendar"]),
  ],
  targets: [
    .target(
      name: "PXiCalendar"),
    .testTarget(
      name: "PXiCalendarTests",
      dependencies: ["PXiCalendar"]),
  ]
)
