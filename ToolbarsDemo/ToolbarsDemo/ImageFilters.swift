//
//  ImageFilters.swift
//  ToolbarsDemo
//
//  Created by Gabriel Theodoropoulos.
//

import Foundation
import UIKit

enum ImageFilter {
    case none, sepia, mono, blur
}

class ImageFilters {
    var context = CIContext()
    
    func apply(filter: ImageFilter, to image: UIImage) -> UIImage? {
        guard let originalImage = CIImage(image: image) else { return nil }
        
        var output: CIImage?
        
        switch filter {
            case .sepia:
                guard let sepia = CIFilter(name:"CISepiaTone") else { return nil }
                sepia.setValue(originalImage, forKey: kCIInputImageKey)
                sepia.setValue(0.75, forKey: kCIInputIntensityKey)
                output = sepia.outputImage
                
            case .mono:
                guard let mono = CIFilter(name:"CIPhotoEffectMono") else { return nil }
                mono.setValue(originalImage, forKey: kCIInputImageKey)
                output = mono.outputImage
            
            case .blur:
                guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
                blur.setValue(originalImage, forKey: kCIInputImageKey)
                blur.setValue(10, forKey: kCIInputRadiusKey)
                output = blur.outputImage
                
            default: return nil
        }
        
        guard let outputImage = output,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
