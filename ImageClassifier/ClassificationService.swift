//
//  ClassificationService.swift
//  ImageClassifier
//
//  Created by Illya Sirosh on 16.01.2021.
//

import Foundation
import UIKit
import CoreML
import Vision

class ClassificationService: ObservableObject {
    let model: MLModel
    @Published var result: ClassificationResult?
    
    init(with model: MLModel){
        self.model = model
    }
    
    func proccess(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            result = .unrecognized
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            do {
                let request = try self.getRequest()
                try handler.perform([request])
            } catch {
                self.result = .unrecognized
            }
        }
        
        result = .proccessing
    }
    
    private func getRequest() throws  -> VNCoreMLRequest {
        guard let visionModel = try? VNCoreMLModel(for: model) else {
            throw ServiceError.cannotConvertModel
        }

        let request = VNCoreMLRequest(model: visionModel, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error)
        })
    
        return request
    }
    
    private func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            result = .unrecognized
            return
        }
        
        let classifications = results as! [VNClassificationObservation]
        
        if let mostPossibleClassification = classifications.first {
            result = .recognized(mostPossibleClassification.identifier)
        }
    }
}

extension ClassificationService {
    
    enum ServiceError: Error {
        case cannotConvertModel
    }
    
}

