//
//  ChatGPT.swift
//  Mashow
//
//  Created by Kai Lee on 10/3/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation



struct OpenAIImageClient {
    let apiKey: String
    let apiUrl = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(url: String, model: String, systemText: String, temperature: Double) async throws -> String {
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let message: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "system",
                    "content": systemText
                ],
                [
                    "role": "user",
                    "content": "{\"type\":\"image_url\", \"image_url\": {\"url\": \"\(url)\", \"deatil\": \"high\"}}"
                ]
            ],
            "temperature": temperature,
            "max_tokens": 300
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            request.httpBody = jsonData
        } catch {
            throw NSError(domain: "Invalid JSON", code: 0)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let messageContent = choices.first?["message"] as? [String: Any],
              let content = messageContent["content"] as? String
        else {
            throw NSError(domain: "Invalid response", code: 0)
        }
        
        return content
    }
    
    func sendMessage(ocrResult: String, model: String, systemText: String, temperature: Double) async throws -> String {
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let message: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "system",
                    "content": systemText
                ],
                [
                    "role": "user",
                    "content": "\(ocrResult)"
                ]
            ],
            "temperature": temperature,
            "max_tokens": 300
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
            request.httpBody = jsonData
        } catch {
            throw NSError(domain: "Invalid JSON", code: 0)
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let messageContent = choices.first?["message"] as? [String: Any],
              let content = messageContent["content"] as? String
        else {
            throw NSError(domain: "Invalid response", code: 0)
        }
        
        return content
    }
}

// SpiritGPT 클래스
class SpiritGPT {
    private static let api = OpenAIImageClient(apiKey: (Bundle.main.object(forInfoDictionaryKey: "GPT_KEY") as? String)!)
    
    private static let systemText = """
    I’ll provide an OCR result from a liquor bottle's label.
    Please extract the information and create a JSON with the following keys: ‘type’, ‘name’, ‘manufacturer’.
    ---
    Preconditions:
    - You must download the image form URL and should analyze it.
    - 'type' must be one of this; 'soju', 'liquor', 'beer', 'wine', 'sake', 'highball', 'cocktail'
    - If you feel that you don’t have enough information, first search the internet. If the information is still insufficient, return the category with an empty value (null)
    - Response should include the JSON data only, not other text
    """
    
    static private(set) var inProgress = false
    
    struct Spirit: Decodable {
        let type: String
        let name: String
        let manufacturer: String?
    }
    
    static func ask(_ ocrResult: String) async throws -> Spirit {
        defer { inProgress = false }
        inProgress = true
        
        var response = try await api.sendMessage(ocrResult: ocrResult,
                                                 model: "gpt-4o-mini",
                                                 systemText: Self.systemText,
                                                 temperature: 0.5)
        
        print("[GPT] Recognized texts: ", ocrResult)
        print("[GPT] Response: ", response)
        
        if response.hasPrefix("```json") { response.removeFirst(7) }
        if response.hasSuffix("```") { response.removeLast(3) }
        
        guard let responseData = response.data(using: .utf8) else {
            throw GPTError.network
        }
        
        do {
            return try JSONDecoder().decode(Spirit.self, from: responseData)
        } catch {
            throw GPTError.cannotRecognize
        }
    }
}

extension SpiritGPT {
    enum GPTError: Error {
        case cannotRecognize
        case network
        case unknown
    }
}

import UIKit
import Vision

class OCRManager {
    static func extractText(from image: UIImage) async throws -> String? {
        guard let image = binarizeImage(image), let ciImage = CIImage(image: image) else {
            throw NSError(domain: "Invalid image", code: 0, userInfo: nil)
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    print("Error recognizing text: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }

                var recognizedText = ""
                for observation in request.results as? [VNRecognizedTextObservation] ?? [] {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    recognizedText += topCandidate.string + "\n"
                }

                continuation.resume(returning: recognizedText.isEmpty ? nil : recognizedText)
            }

            request.recognitionLanguages = ["en-US", "fr-FR"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.customWords = [
                // 주류 유형
                "Wine", "Red Wine", "White Wine", "Rosé", "Sparkling Wine",
                "Beer", "Lager", "Ale", "Stout", "Porter", "IPA", "India Pale Ale", "Pilsner",
                "Whiskey", "Whisky", "Bourbon", "Scotch", "Rye",
                "Vodka", "Rum", "Gin", "Tequila", "Mezcal", "Brandy", "Cognac", "Absinthe",
                "Soju", "Sake", "Makgeolli", "Shochu",
                "Liqueur", "Schnapps", "Amaro", "Vermouth", "Aperitif", "Digestif",
                
                // 브랜드 이름
                "Jack Daniel's", "Jim Beam", "Johnnie Walker", "Glenfiddich", "Macallan",
                "Absolut", "Smirnoff", "Grey Goose", "Belvedere",
                "Bacardi", "Captain Morgan", "Havana Club",
                "Hennessy", "Remy Martin", "Martell",
                "Heineken", "Budweiser", "Guinness", "Stella Artois", "Corona",
                "Moët & Chandon", "Dom Pérignon", "Veuve Clicquot",
                "Chivas Regal", "Jameson", "Ballantine's", "Bombay",
                
                // 알코올 도수 관련 용어
                "ABV", "Alcohol by Volume", "Proof",
                "% Alcohol", "% Alc", "Vol",
                "Low Alcohol", "High Alcohol",
                
                // 라벨 정보 (일반적인 표현)
                "Distilled", "Aged", "Matured", "Barrel-aged",
                "Single Malt", "Blended", "Double Distilled", "Triple Distilled",
                "Reserve", "Premium", "Vintage", "Non-Vintage", "Limited Edition",
                "Handcrafted", "Small Batch", "Estate Bottled",
                "Produced", "Bottled", "Distilled", "Fermented", "Brewed",
                "Imported", "Exported", "Product of",
                
                // 기타 관련 용어
                "Water", "Barley", "Yeast", "Hops", "Grapes", "Corn", "Wheat", "Rye", "Agave", "Sugarcane",
                "Serving Size", "Serving Suggestion", "Chilled", "Best Served",
                "Organic", "Natural", "Gluten-Free", "Sulfite-Free", "Sugar-Free",
                "France", "Italy", "Spain", "USA", "Korea", "Japan", "Mexico", "Scotland", "Ireland",
                
                // 와인에 특화된 용어
                "Chardonnay", "Cabernet Sauvignon", "Merlot", "Pinot Noir", "Sauvignon Blanc", "Riesling", "Syrah",
                "Appellation", "Vineyard", "Terroir", "Estate", "Winery",
                "Tannins", "Acidity", "Full-Bodied", "Light-Bodied",
                "Old World", "New World",
                
                // 라벨에 표시될 수 있는 연도
                "Year", "Vintage", "2000", "2015", "2020",
                
                // 인증 마크나 기호
                "Organic Certified", "Fair Trade", "DOC", "DOCG", "AOC",
                "Kosher", "Halal"
            ]

            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Error performing text recognition: \(error.localizedDescription)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    private static func binarizeImage(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        // Apply a threshold filter to binarize the image
        let thresholdFilter = CIFilter(name: "CIColorMonochrome")
        thresholdFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        thresholdFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor")
        thresholdFilter?.setValue(1.0, forKey: "inputIntensity") // Maximum contrast
        
        guard let outputImage = thresholdFilter?.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
