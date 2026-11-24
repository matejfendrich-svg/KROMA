// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Kroma",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "Kroma", targets: ["KromaApp"])
    ],
    targets: [
        // Centrální registry: schémata parametrů, definice efektů, stránky.
        .target(name: "KromaRegistry"),

        // Datový model: média, node graf, projekt, perzistence.
        .target(name: "KromaCore", dependencies: ["KromaRegistry"]),

        // Render DAG a Metal kernely.
        .target(
            name: "KromaEngine",
            dependencies: ["KromaRegistry", "KromaCore"],
            resources: [.copy("Kernels")]
        ),

        // Design system a komponenty.
        .target(name: "KromaUI", dependencies: ["KromaRegistry"]),

        // Import, RAW, proxy, cache.
        .target(name: "KromaMediaKit", dependencies: ["KromaCore"]),

        // ICC, LUT, pracovní prostor, soft proofing.
        .target(name: "KromaColor", dependencies: ["KromaCore"]),

        // Definice efektů (halftone, pixel, písmenný raster, depth).
        .target(name: "KromaFX", dependencies: ["KromaRegistry"]),

        // Každá stránka je samostatný modul.
        .target(name: "ImportPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/ImportPage"),
        .target(name: "ObrazPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/ObrazPage"),
        .target(name: "ColorPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/ColorPage"),
        .target(name: "FXPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/FXPage"),
        .target(name: "EditPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/EditPage"),
        .target(name: "ExportPage", dependencies: ["KromaUI", "KromaCore", "KromaRegistry"], path: "Sources/KromaPages/ExportPage"),

        // Export foto, videa, animací a exportní fronta.
        .target(name: "KromaExporter", dependencies: ["KromaCore", "KromaRegistry", "KromaEngine"]),

        // Nastavení aplikace.
        .target(name: "KromaSettings", dependencies: ["KromaUI", "KromaRegistry", "KromaCore"]),

        // Vstupní bod aplikace.
        .executableTarget(
            name: "KromaApp",
            dependencies: [
                "KromaUI", "KromaCore", "KromaRegistry", "KromaEngine",
                "KromaMediaKit", "KromaColor", "KromaFX",
                "ImportPage", "ObrazPage", "ColorPage", "FXPage", "EditPage", "ExportPage",
                "KromaExporter", "KromaSettings",
            ]
        ),

        // Testy.
        .testTarget(name: "KromaCoreTests", dependencies: ["KromaCore", "KromaRegistry"], path: "Tests/KromaCoreTests"),
        .testTarget(name: "KromaRegistryTests", dependencies: ["KromaRegistry"], path: "Tests/KromaRegistryTests"),
        .testTarget(name: "KromaUITests", dependencies: ["KromaUI"], path: "Tests/KromaUITests"),
    ]
)
