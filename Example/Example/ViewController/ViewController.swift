//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/3/27.
//

import UIKit
import WWSimpleAI_Ollama
import WWSimpleAI_Claude

// MARK: - ViewController
final class ViewController: UIViewController {

    @IBOutlet weak var resultTextField: UITextView!
    
    private let apiKey = "<API-KEY>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWSimpleAI.Claude.configure(apiKey: apiKey)
    }
    
    @IBAction func talk(_ sender: UIBarButtonItem) {
        
        Task {
            let result = await WWSimpleAI.Claude.shared.talk(content: "今天是星期幾？")
            
            switch result {
            case .failure(let error): resultTextField.text = "\(error)"
            case .success(let value): resultTextField.text = "\(value)"
            }
        }
    }
    
    @IBAction func tokenCount(_ sender: UIBarButtonItem) {
        
        Task {
            let result = await WWSimpleAI.Claude.shared.tokenCount(content: "What day is it today?")
            
            switch result {
            case .failure(let error): resultTextField.text = "\(error)"
            case .success(let value): resultTextField.text = "\(value)"
            }
        }
    }
}
