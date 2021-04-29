//
//  ImageModel.swift
//  ToolbarsDemo
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI

struct ImageModel {
    let imageName: String
    var description: String = ""
    var filter: ImageFilter = .none
    private var imageFilters = ImageFilters()
    
    var image: UIImage {
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "jpg") else { return UIImage() }
        guard let image = UIImage(contentsOfFile: url.path) else { return UIImage() }
        
        if filter == .none {
            return image
        } else {
            return imageFilters.apply(filter: filter, to: image) ?? UIImage()
        }
        
    }
    
    init(with name: String) {
        imageName = name
    }
}
