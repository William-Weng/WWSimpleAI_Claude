//
//  WWSimpleAI_Claude.swift
//  WWSimpleAI_Claude
//
//  Created by William.Weng on 2025/3/27.
//

import WWSimpleAI_Ollama
import WWNetworking

// MARK: - WWSimpleAI.Claude
extension WWSimpleAI {
    
    open class Claude {
        
        public static let shared = Claude()
        
        static let baseURL = "https://api.anthropic.com"
        
        static var apiKey = "<API-KEY>"
        static var anthropicVersion = "2023-06-01"
        static var version: Claude.Version = .v1
        static var model: Claude.Model = .sonnet
        
        private init() {}
    }
}

// MARK: - 初始值設定 (static function)
public extension WWSimpleAI.Claude {
    
    /// [參數設定](https://docs.anthropic.com/zh-TW/api/getting-started)
    /// - Parameters:
    ///   - apiKey: String
    ///   - version: WWSimpleAI.Claude.Version
    ///   - model: WWSimpleAI.Claude.Model
    ///   - anthropicVersion: String
    static func configure(apiKey: String, version: WWSimpleAI.Claude.Version = .v1, model: WWSimpleAI.Claude.Model = .sonnet, anthropicVersion: String = "2023-06-01") {
        self.apiKey = apiKey
        self.anthropicVersion = anthropicVersion
        self.version = version
        self.model = model
    }
}

// MARK: - WWSimpleAI.Claude
public extension WWSimpleAI.Claude {
    
    /// [說話模式](https://docs.anthropic.com/zh-TW/api/messages)
    /// - Parameters:
    ///   - content: 談話文字
    ///   - maxTokens: 最大Token數
    /// - Returns: Result<String?, Error>
    func talk(content: String, maxTokens: Int = 1024) async -> Result<Any, Error> {
        
        let api = WWSimpleAI.Claude.API.messages
        let header = authorizationHeaders()
        let json = """
        {
          "model": "\(WWSimpleAI.Claude.model.value())",
          "max_tokens": \(maxTokens),
          "messages": [
            { "role": "\(RoleType.user.value())", "content": "\(content)" }
          ]
        }
        """
        
        let result = await WWNetworking.shared.request(httpMethod: .POST, urlString: api.value(), headers: header, httpBodyType: .string(json))
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let info):
            
            guard let data = info.data,
                  let jsonObject = data._jsonObject() as? [String: Any],
                  let type = jsonObject["type"] as? String
            else {
                return .failure(CustomError.notJSONObject)
            }
            
            if (type == "error") {
                guard let error = jsonObject["error"] else { return .failure(CustomError.notJSONObject) }
                return .failure(CustomError.systemError(error))
            }
            
            return .success(jsonObject["content"])
        }
    }
    
    /// [計算訊息字符數](https://docs.anthropic.com/zh-TW/api/messages-count-tokens)
    /// - Parameter content: 談話文字
    /// - Returns: Result<Int, Error>
    func tokenCount(content: String) async -> Result<Int, Error> {
        
        let api = WWSimpleAI.Claude.API.tokenCount
        let header = authorizationHeaders()
        let json = """
        {
          "model": "\(WWSimpleAI.Claude.model.value())",
          "messages": [
            { "role": "\(RoleType.user.value())", "content": "\(content)" }
          ]
        }
        """
        
        let result = await WWNetworking.shared.request(httpMethod: .POST, urlString: api.value(), headers: header, httpBodyType: .string(json))
        
        switch result {
        case .failure(let error): return .failure(error)
        case .success(let info):
            
            guard let data = info.data,
                  let jsonObject = data._jsonObject() as? [String: Any]
            else {
                return .failure(CustomError.notJSONObject)
            }
            
            if let type = jsonObject["type"] as? String, type == "error" {
                guard let error = jsonObject["error"] else { return .failure(CustomError.notJSONObject) }
                return .failure(CustomError.systemError(error))
            }
            
            guard let inputTokens = jsonObject["input_tokens"] as? Int else { return .failure(CustomError.notJSONObject) }
            return .success(inputTokens)
        }
    }
}

// MARK: - 小工具
private extension WWSimpleAI.Claude {
    
    /// 安全認證Header
    /// - Returns: [String: String]
    func authorizationHeaders() -> [String: String] {
        
        let headers = [
            "x-api-key": "\(WWSimpleAI.Claude.apiKey)",
            "anthropic-version": "\(WWSimpleAI.Claude.anthropicVersion)"
        ]
        
        return headers
    }
}
