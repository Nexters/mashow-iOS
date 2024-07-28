//
//  AuthorizationManager+Apple.swift
//  MashowTests
//
//  Created by Kai Lee on 7/25/24.
//  Copyright © 2024 com.alcoholers. All rights reserved.
//

import UIKit
import AuthenticationServices

extension AuthorizationManager {
    func signInWithApple(_ view: UIViewController) async throws -> String {
        let appleAuthManager = AppleAuthManager()
        return try await appleAuthManager.didTapSignInWithAppleButton(from: view)
    }
}

final class AppleAuthManager: NSObject {
    weak var viewController: UIViewController?
    private var completionHandler: ((Result<String, Error>) -> Void)? = nil
    
    func setAppleAuthPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
    
    func didTapSignInWithAppleButton(from view: UIViewController) async throws -> String {
        setAppleAuthPresentationAnchorView(view)
        return try await withCheckedThrowingContinuation { continuation in
            startAuthFlow { result in
                switch result {
                case .success(let identityToken):
                    continuation.resume(returning: identityToken)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    
    private func startAuthFlow(completion: @escaping (Result<String, Error>) -> Void) {
        completionHandler = completion
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let idToken = credential.identityToken,
           let idTokenString = String(data: idToken, encoding: .utf8) {
            completionHandler?(.success(idTokenString))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print(error.localizedDescription)
        completionHandler?(.failure(error))
    }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}
