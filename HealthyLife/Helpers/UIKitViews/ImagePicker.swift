//
//  ImagePicker.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 2/6/22.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias SourceType = UIImagePickerController.SourceType
    
    // Let user decide in viewmodel if photo picked from gallery or camera
    let sourceType: SourceType
    let completionHandler: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
    // Coordinator with image picker and navigation delegate
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completionHandler: (UIImage?) -> Void
        
        init(completionHandler: @escaping (UIImage?) -> Void) {
            self.completionHandler = completionHandler
        }
        
        // User picks a photo
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image: UIImage? = {
                if let image = info[.editedImage] as? UIImage {
                    return image
                }
                return info[.originalImage] as? UIImage
            }()
            completionHandler(image)
        }
        
        // User cancel photo picking
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completionHandler(nil)
        }
    }
}
