//
//  ContentView.swift
//  ExamplePixzleUnsplashPhotoPicker
//
//  Created by Matt Jankowiak on 6/25/25.
//

import SwiftUI
import PixzleUnsplashPhotoPicker

struct ContentView: View {
    @StateObject private var delegate = UnsplashPickerDelegateBridge()
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding()
                } else {
                    Text("No image selected yet")
                        .foregroundColor(.gray)
                }

                Button("Pick from Unsplash") {
                    presentUnsplashPicker(delegate: delegate) { image in
                        self.selectedImage = image
                    }
                }

                if let attribution = delegate.attribution {
                    Text("📷 by \(attribution.authorName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Unsplash Demo")
        }
    }
}

//
//  UnsplashPhotoPicker.swift
//  Pixzle
//
//  Created by Matt Jankowiak on 5/7/25.
//

import SwiftUI
import PixzleUnsplashPhotoPicker

final class UnsplashPickerDelegateBridge: NSObject, UnsplashPhotoPickerDelegate, ObservableObject {
    var onSelect: ((UnsplashPhoto) -> Void)?
    @Published var attribution: UnsplashAttribution?
    
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        DispatchQueue.main.async {
            photoPicker.dismiss(animated: true) {
                if let photo = photos.first {
                    self.onSelect?(photo)
                }
            }
        }
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        DispatchQueue.main.async {
            photoPicker.dismiss(animated: true, completion: nil)
        }
    }
}

func presentUnsplashPicker(
    delegate: UnsplashPickerDelegateBridge,
    searchQuery: String? = nil,
    onDownload: @escaping (UIImage) -> Void
) {
    let configuration = UnsplashPhotoPickerConfiguration(
        accessKey: "",
        secretKey: "",
        query: nil,
        allowsMultipleSelection: false
    )
    
    let picker = UnsplashPhotoPicker(configuration: configuration)
    delegate.onSelect = { photo in
        guard let url = photo.urls[.regular],
              let authorName = photo.user.name,
              let authorLink = photo.user.links[.html] else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                delegate.attribution = UnsplashAttribution(authorName: authorName, authorURL: authorLink)
                onDownload(image)
            }
        }.resume()
    }
    
    picker.photoPickerDelegate = delegate
    
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let root = scene.windows.first?.rootViewController {
        root.present(picker, animated: true, completion: nil)
    }
}

struct UnsplashAttribution {
    let authorName: String
    let authorURL: URL
}
