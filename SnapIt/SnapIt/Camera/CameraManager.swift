//
//  CameraManager.swift
//  SnapIt
//
//  Created by Vishal Manhas on 17/12/24.
//

import AVFoundation
import Combine

class CameraManager: ObservableObject {
    static let shared = CameraManager()
    
    @Published var error: String?
    private let session = AVCaptureSession()
    private var output = AVCapturePhotoOutput()
    private var input: AVCaptureDeviceInput?
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    private var isFrontCamera = false
    private var currentDevice: AVCaptureDevice?
    
    private init() {
        configureSession()
    }
    
    private func configureSession() {
        sessionQueue.async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            self.setCamera(isFront: self.isFrontCamera)
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }
    
    private func setCamera(isFront: Bool) {
        let position: AVCaptureDevice.Position = isFront ? .front : .back
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            currentDevice = device
            do {
                let newInput = try AVCaptureDeviceInput(device: device)
                if let input = input {
                    session.removeInput(input)
                }
                input = newInput
                if session.canAddInput(input!) {
                    session.addInput(input!)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Error configuring camera: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: delegate)
    }
    
    func toggleCamera() {
        isFrontCamera.toggle()
        setCamera(isFront: isFrontCamera)
    }
    
    func getSession() -> AVCaptureSession {
        return session
    }
}
