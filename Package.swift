// swift-tools-version: 6.0

import Foundation
import PackageDescription

let reactHeaders: [Target.Dependency] = [
    .product(name: "ReactHeaders", package: "ReactNative"),
    .product(name: "ReactNativeHeaders", package: "ReactNative"),
    .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
    .product(name: "ReactAppHeaders", package: "React-GeneratedCode"),
]

// React Native resolves this package from its generated autolinking/libs directory.
let usedRootEntries: Set<String> = ["ios", "spm-headers", "spm-support", "Package.swift"]
let unusedRootEntries = try! FileManager.default.contentsOfDirectory(atPath: Context.packageDirectory)
    .filter { !usedRootEntries.contains($0) }
    .sorted()
let iosEntries = try! FileManager.default.subpathsOfDirectory(
    atPath: Context.packageDirectory + "/ios"
).filter { !$0.contains(".xcodeproj/") }
let swiftExcludes = iosEntries.filter {
    $0.hasSuffix(".xcodeproj") || ["h", "m", "mm", "cpp"].contains(URL(fileURLWithPath: $0).pathExtension)
}.map { "ios/" + $0 }
let objcExcludes = iosEntries.filter {
    $0.hasSuffix(".xcodeproj") || $0.hasSuffix(".swift")
}.map { "ios/" + $0 }

let package = Package(
    name: "LiquidGlass",
    platforms: [.iOS("15.1")],
    products: [
        .library(name: "LiquidGlass", targets: ["LiquidGlass", "LiquidGlassObjC"]),
    ],
    dependencies: [
        .package(name: "ReactNative", path: "../../../../xcframeworks"),
        .package(name: "React-GeneratedCode", path: "../../../ios"),
    ],
    targets: [
        .target(
            name: "LiquidGlass",
            path: ".",
            exclude: unusedRootEntries + ["spm-headers"] + swiftExcludes,
            sources: ["ios", "spm-support"]
        ),
        .target(
            name: "LiquidGlassObjC",
            dependencies: ["LiquidGlass"] + reactHeaders,
            path: ".",
            exclude: unusedRootEntries + ["spm-support"] + objcExcludes,
            sources: ["ios"],
            publicHeadersPath: "spm-headers/public",
            cSettings: [
                .define("RCT_NEW_ARCH_ENABLED", to: "1"),
                .headerSearchPath("spm-headers"),
            ],
            cxxSettings: [
                .define("RCT_NEW_ARCH_ENABLED", to: "1"),
                .headerSearchPath("spm-headers"),
                .define("DEBUG", .when(configuration: .debug)),
                .define("NDEBUG", .when(configuration: .release)),
            ]
        ),
    ],
    swiftLanguageModes: [.v5],
    cxxLanguageStandard: .cxx20
)
