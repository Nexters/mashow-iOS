//
//  CloudflareManager.swift
//  Mashow
//
//  Created by Kai Lee on 10/3/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import Foundation

class CloudflareManager {
    private static let workerPath = "rough-dream-72ba.mashow.workers.dev"
    
    /// Cloudflare Workers에 이미지 업로드
    static func uploadImageToCloudflare(imageData: Data) async throws -> (fileKey: String, url: String)? {
        let apiUrl = "https://\(workerPath)/upload"
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: imageData)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to upload image. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return nil
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: String],
               let imageUrl = jsonResponse["url"],
               let fileKey = jsonResponse["fileKey"] {
                return (fileKey, imageUrl)
            } else {
                print("Failed to parse response data")
                return nil
            }
        } catch {
            print("Error uploading image: \(error)")
            throw error
        }
    }
    
    /// Cloudflare Workers를 통한 이미지 삭제
    static func deleteImageFromCloudflare(fileKey: String) async throws -> Bool {
        let apiUrl = "https://\(workerPath)/delete/\(fileKey)"
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to delete image. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return false
            }
            
            print("Image successfully deleted from Cloudflare")
            return true
        } catch {
            print("Error deleting image: \(error)")
            throw error
        }
    }
}
