//
//  Constant.swift
//  WWSimpleAI_Claude
//
//  Created by William.Weng on 2025/3/27.
//

import WWSimpleAI_Ollama

public extension WWSimpleAI.Claude {
    
    /// ClaudeAPI版本
    enum Version {
        
        case v1
        
        /// 取得模型版本號
        /// - Returns: String
        func value() -> String {
            
            switch self {
            case .v1: return "v1"
            }
        }
    }
    
    /// [Claude模型名稱](https://docs.anthropic.com/en/docs/about-claude/models/all-models)
    enum Model {
        
        case haiku
        case sonnet
        
        /// 取得模型名稱
        /// - Returns: String
        func value() -> String {
            
            let model: String
            
            switch self {
            case .haiku: model = "claude-3-5-haiku-latest"
            case .sonnet: model = "claude-3-7-sonnet-latest"
            }
            
            return model
        }
    }
    
    /// API名稱
    enum API {
        
        case messages       // [訊息](https://docs.anthropic.com/zh-TW/api/messages)
        case tokenCount     // [計算訊息字符數](https://docs.anthropic.com/zh-TW/api/messages-count-tokens)
        
        /// 取得url
        /// - Returns: String
        func value() -> String {
            
            switch self {
            case .messages: return "\(WWSimpleAI.Claude.baseURL)/\(WWSimpleAI.Claude.version.value())/messages"
            case .tokenCount: return "\(WWSimpleAI.Claude.baseURL)/\(WWSimpleAI.Claude.version.value())/messages/count_tokens"
            }
        }
    }
    
    /// 角色類型
    enum RoleType {
        
        case user
        case assistant
        case system
        
        /// 取得字串值
        /// - Returns: String
        func value() -> String {
            
            switch self {
            case .user: return "user"
            case .assistant: return "assistant"
            case .system: return "system"
            }
        }
    }
    
    /// 自定義錯誤
    enum CustomError: Error {
        
        case notJSONObject
        case unknown
        case systemError(_ message: Any)
        
        /// 錯誤訊息
        /// - Returns: String
        func message() -> String {
            
            switch self {
            case .notJSONObject: return "不是JSON格式"
            case .unknown: return "未知錯誤"
            case .systemError(_): return "Claude系統錯誤"
            }
        }
    }
}
