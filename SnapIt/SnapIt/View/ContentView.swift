//
//  ContentView.swift
//  SnapIt
//
//  Created by Vishal Manhas on 17/12/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
           
            CameraPreview(session: CameraManager.shared.getSession())
                .edgesIgnoringSafeArea(.all)
         
            VStack {
                Spacer()
                
                if let image = viewModel.capturedImage {
                    Button(action: {
                        viewModel.showFullScreenImage = true
                    }) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.leading, 16)
                    }
                }
              
                HStack {
                  
                    Button(action: {
                        viewModel.toggleCamera()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.capturePhoto()
                    }) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                            )
                    }
                    
                    Spacer()
                   
                    Button(action: {
                       
                    }) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .fullScreenCover(isPresented: $viewModel.showFullScreenImage) {
            FullScreenImageView(viewModel: viewModel)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}




struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


#Preview {
    ContentView()
}


