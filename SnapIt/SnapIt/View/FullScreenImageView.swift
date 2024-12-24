//
//  FullScreenImageView.swift
//  SnapIt
//
//  Created by Vishal Manhas on 24/12/24.
//

import SwiftUI

struct FullScreenImageView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var isShareSheetPresented = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }
            
            // Top Buttons
            VStack {
                HStack {
                    // Dismiss Button
                    Button(action: {
                        viewModel.showFullScreenImage = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Three-dot Options Button
                    Button(action: {
                        viewModel.showActionSheet = true
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("Options"),
                buttons: [
                    .default(Text("Save to Photos"), action: {
                        viewModel.savePhotoToLibrary()
                    }),
                    .default(Text("Share"), action: {
                        isShareSheetPresented = true
                    }),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isShareSheetPresented) {
            if let image = viewModel.capturedImage {
                ShareSheet(activityItems: [image])
            }
        }
    }
}

#Preview {
    FullScreenImageView(viewModel: ContentViewModel())
}
