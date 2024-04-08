import Foundation
import SwiftOpenAI
import Core

let directoryURL = URL(fileURLWithPath: "/Users/michael/workspace/privat/talks/LoadingSpinners/Packages/Core/Sources/Core/Resources")

final class ImageService {
    private static let imageService: any OpenAIService = OpenAIServiceFactory.service(
        azureConfiguration: .init(
            resourceName: "",
            openAIAPIKey: .apiKey(""),
            apiVersion: "2024-02-15-preview"
        )
    )

    func generateImage(_ prompt: String) async -> ImageData? {
        do {
            let response = try await Self.imageService.createImages(parameters: .init(prompt: prompt, model: .dalle3(.largeSquare)))
            guard let imageResponse = response.data.first, let url = imageResponse.url else { return nil }

            let titleResponse = try? await Self.imageService.startChat(parameters: .init(messages: [
                .init(role: .system, content: .text("You are an AI assistant helping analyzing an image. You will receive an image and will response with a short title about the image. Only response the title of the image. The title should be without quotation marks.")),
                .init(role: .user, content: .contentArray([.text("Give me a title for this image"), .imageUrl(url)])),
            ], model: .gpt4VisionPreview))

            let title = titleResponse?.choices.first?.message.content ?? "No title"

            try? await Task.sleep(for: .seconds(61))

            let descriptionResponse = try? await Self.imageService.startChat(parameters: .init(messages: [
                .init(role: .system, content: .text("You are an AI assistant helping analyzing an image. You will receive an image and will response with a description about the image. Include the style of the image in your description. Only response with the description.")),
                .init(role: .user, content: .contentArray([.text("Describe this image"), .imageUrl(url)])),
            ], model: .gpt4VisionPreview))

            let description = descriptionResponse?.choices.first?.message.content ?? "No description"

            return ImageData(id: UUID().uuidString, title: title, description: description, prompt: prompt, url: url.absoluteString)
        } catch {
            return nil
        }
    }
}

import UnifiedBlurHash

class Storage {
    static func storeData(_ imageData: ImageData) {
        do {
            let data = try encoder.encode(imageData)
            let fileURL = directoryURL.appendingPathComponent(imageData.jsonFileName)
            try data.write(to: fileURL, options: [])
            print("File saved: \(fileURL)")
        } catch {}
    }
    
    static func downloadImage(_ imageData: inout ImageData) async {
        do {
            guard let url = URL(string: imageData.url) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let unifiedImage = UnifiedImage(data: data) {
                let hash = await UnifiedBlurHash.getBlurHashString(from: unifiedImage)
                imageData.blurHash = hash
            }
            
//            let fileURL0 = directoryURL.appendingPathComponent(imageData.imageFileName)
//            try data.write(to: fileURL0, options: [])
//            
            let folder = directoryURL
                .appendingPathComponent("Media.xcassets", isDirectory: true)
                .appendingPathComponent("\(imageData.id).imageset", isDirectory: true)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            
            var fileURL = folder.appendingPathComponent(imageData.imageFileName)
            try data.write(to: fileURL, options: [])

            fileURL = folder.appendingPathComponent("Contents.json")
            try assetContent(id: imageData.id).data(using: .utf8)?.write(to: fileURL)

            print("Image saved: \(folder)")
        } catch {}
    }
    
    private static func assetContent(id: String) -> String {
"""
{
  "images" : [
    {
      "filename" : "\(id).png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}

"""
    }
}

class Combiner {
    func generate() {
        let fileManager = FileManager.default
        var jsonArray: [Any] = []

        do {
            // Get the list of JSON files in the specified directory
            let jsonFiles = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil).filter { $0.pathExtension == "json" }

            // Iterate through the found JSON files
            for fileURL in jsonFiles {
                // Read the data from the file
                let data = try Data(contentsOf: fileURL)

                // Parse the JSON data into a Swift object
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Add the object to the array
                    jsonArray.append(jsonObject)
                } else {
                    print("Could not parse JSON file: \(fileURL)")
                }
            }

            // Serialize the array back to JSON data
            let combinedData = try JSONSerialization.data(withJSONObject: jsonArray, options: [.prettyPrinted, .sortedKeys])

            // Write the JSON data to an output file
            let outputPath = directoryURL.appendingPathComponent("combined.json")
            try combinedData.write(to: outputPath)

            print("Successfully combined JSON files into: \(outputPath)")
        } catch {
            print("An error occurred: \(error)")
        }

    }
}
