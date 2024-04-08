// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

let service = ImageService()
let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
}()

@main
struct ImageTool: AsyncParsableCommand {
//    @Argument(help: "The image prompt")
//    var prompt: String

    mutating func run() async throws {
//        if prompt.isEmpty {
//            fatalError("Prompt is empty")
//        }

        await generate(prompts: [
//            "A white cute cat with a unicorn on its head",
//            "A wild `loading spinner` in the wild, nervous to be catched by a ranger",
//            "Munich in the 1950s",
//            "Berlin in the 1980s",
//            "Close-up, front shot, Apple Airpod pro, orange color, Fujifilm GFX 100S, aperture at f/8, ISO 100, solid black environment"
//            "Silver Unicorn in a mystic area"
//            "Winterwonderland in the mountains. Snow is falling, sun is shining"
//            "a painting of a Bird, in the style of iridescence/opalescence, curves, light azure and orange, elegant, emotive faces, split toning, gradient colors, black background"
//            "Bookstore in the style of sci-fi distopia, high contrast, hyper realistic, fantasy, bright colors"
            "Tree in the style of prismatic image, prismatic distortion, bold, black lines, backlit photography, iconic album covers, darksynth, hustlewave",
            "a group of people jogging in an empty snowy forest, in the style of romantic: dramatic landscapes, backlight, ricoh gr iii, dark gray and azure, interplay of light and color",
            "white shoes in water on reflecting glass for stockshots united, in the style of light pink and dark green, lee broom, subtle pastel tones, sharp lines and edges, terracotta, smokey background, vibrant color blocks",
            "sunset over the mountains by vyrokhorsak for stocksy united, in the style of realistic pop art, vintage poster design, dark brown and magenta, swiss style, graphic design poster art, ferdinand hodler, stencil-based"
        ])
    }

    private func generate(_ prompt: String) async {
        print("=== Generate new image ===\n", "\"\(prompt)\"")

        guard var imageData = await service.generateImage(prompt) else {
            print("Error, Can not generate image data")
            return
        }

        print("=== New Image generated ===\n", imageData)

        await Storage.downloadImage(&imageData)

        Storage.storeData(imageData)
    }

    private func generate(prompts: [String]) async {
        for prompt in prompts {
            await generate(prompt)

            Combiner().generate()

            print("=== Now sleep 70 seconds ...")
            try! await Task.sleep(for: .seconds(70))
        }
    }
}
