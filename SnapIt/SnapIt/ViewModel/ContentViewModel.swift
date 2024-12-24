//
//  ContentViewModel.swift
//  SnapIt
//
//  Created by Vishal Manhas on 17/12/24.
//

import SwiftUI
import AVFoundation

class ContentViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: UIImage?
    @Published var showFullScreenImage = false
    @Published var showActionSheet = false
    
    private let cameraManager = CameraManager.shared
    
    func capturePhoto() {
        cameraManager.capturePhoto(delegate: self)
    }
    
    func toggleCamera() {
        cameraManager.toggleCamera()
    }
    
    func savePhotoToLibrary() {
        if let image = capturedImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.capturedImage = image
            }
        }
    }
}
