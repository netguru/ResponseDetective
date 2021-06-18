// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ResponseDetective",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "ResponseDetective",
            targets: [
                "ResponseDetective",
                "ResponseDetectiveObjC"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Quick/Quick.git",
            .exact("3.0.0")
        ),
        .package(
            url: "https://github.com/Quick/Nimble.git",
            .exact("9.0.0")
        ),
        .package(
            url: "https://github.com/AliSoftware/OHHTTPStubs.git",
            .exact("9.1.0")
        )
    ],
    targets: [
        .target(
            name: "ResponseDetective",
            dependencies: ["ResponseDetectiveObjC"],
            path: "ResponseDetective",
            exclude: [
                "Configuration",
                "Resources",
                "Tests",
                "include",
                "Sources/RDTHTMLBodyDeserializer.h",
                "Sources/RDTXMLBodyDeserializer.h",
                "Sources/ResponseDetective.h",
                "Sources/RDTHTMLBodyDeserializer.m",
                "Sources/RDTBodyDeserializer.h",
                "Sources/RDTXMLBodyDeserializer.m"
            ],
            sources: [
                "Sources/ResponseRepresentation.swift",
                "Sources/ErrorRepresentation.swift",
                "Sources/ResponseDetective.swift",
                "Sources/BufferOutputFacility.swift",
                "Sources/ConsoleOutputFacility.swift",
                "Sources/URLEncodedBodyDeserializer.swift",
                "Sources/PlaintextBodyDeserializer.swift",
                "Sources/ImageBodyDeserializer.swift",
                "Sources/JSONBodyDeserializer.swift",
                "Sources/Dictionary.swift",
                "Sources/URLProtocol.swift",
                "Sources/OutputFacility.swift",
                "Sources/RequestRepresentation.swift"
            ]
        ),
        .target(
            name: "ResponseDetectiveObjC",
            dependencies: [],
            path: "ResponseDetective",
            exclude: [
                "Configuration",
                "Resources",
                "Tests",
                "Sources/ResponseRepresentation.swift",
                "Sources/ErrorRepresentation.swift",
                "Sources/ResponseDetective.swift",
                "Sources/BufferOutputFacility.swift",
                "Sources/ConsoleOutputFacility.swift",
                "Sources/URLEncodedBodyDeserializer.swift",
                "Sources/PlaintextBodyDeserializer.swift",
                "Sources/ImageBodyDeserializer.swift",
                "Sources/JSONBodyDeserializer.swift",
                "Sources/Dictionary.swift",
                "Sources/URLProtocol.swift",
                "Sources/OutputFacility.swift",
                "Sources/RequestRepresentation.swift"
            ],
            sources: [
                "Sources/RDTHTMLBodyDeserializer.h",
                "Sources/RDTXMLBodyDeserializer.h",
                "Sources/ResponseDetective.h",
                "Sources/RDTHTMLBodyDeserializer.m",
                "Sources/RDTBodyDeserializer.h",
                "Sources/RDTXMLBodyDeserializer.m"
            ]
        ),
        .testTarget(
            name: "ResponseDetectiveTests",
            dependencies: [
                "ResponseDetective",
                "ResponseDetectiveObjC",
                "Quick",
                "Nimble",
                "OHHTTPStubs"
            ],
            path: "ResponseDetective",
            exclude: [
                "Configuration",
                "Resources",
                "Sources",
                "include",
            ],
            sources: ["Tests"]
        ),
    ]
)
