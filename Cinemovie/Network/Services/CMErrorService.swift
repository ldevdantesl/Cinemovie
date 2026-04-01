//
//  CMErrorService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 19.02.2026.
//

import Foundation

protocol ErrorServiceProtocol {
    func handle(_ error: any Error) -> UserFacingError
    func shouldRetry(_ error: APIError) -> Bool
    func shouldLogout(_ error: APIError) -> Bool
}

final class CMErrorService: ErrorServiceProtocol {
    
    var onUnauthorized: (() -> Void)?
    
    func handle(_ error: any Error) -> UserFacingError {
        #if DEBUG
        print("🔴 API Error: \(error)")
        #endif
        
        guard let apiError = error as? APIError else {
            return UserFacingError(
                title: "Ошибка",
                message: error.localizedDescription,
                isRetryable: false
            )
        }
        
        
        switch apiError {
        case .noConnection:
            return UserFacingError(
                title: "Нет соединения",
                message: "Проверьте подключение к интернету",
                isRetryable: true
            )
            
        case .timeout:
            return UserFacingError(
                title: "Превышено время ожидания",
                message: "Сервер не отвечает. Попробуйте позже",
                isRetryable: true
            )
            
        case .statusCode(let code, _) where code == 401:
            onUnauthorized?()
            return UserFacingError(
                title: "Сессия истекла",
                message: "Войдите снова",
                isRetryable: false
            )
            
        case .statusCode(let code, _) where code >= 500:
            return UserFacingError(
                title: "Ошибка сервера",
                message: "Попробуйте позже",
                isRetryable: true
            )
            
        case .custom(let message, let errors):
            let fieldDetails = errors?.values.flatMap { $0 }.joined(separator: "\n")
            let fullMessage = [message, fieldDetails].compactMap { $0 }.joined(separator: "\n")
            return UserFacingError(
                title: "Ошибка",
                message: fullMessage,
                isRetryable: false
            )
        
            
        default:
            return UserFacingError.from(apiError)
        }
    }
    
    func shouldRetry(_ error: APIError) -> Bool {
        switch error {
        case .noConnection, .timeout:
            return true
        case .statusCode(let code, _) where code >= 500:
            return true
        default:
            return false
        }
    }
    
    func shouldLogout(_ error: APIError) -> Bool {
        if case .statusCode(401, _) = error {
            return true
        }
        return false
    }
}
