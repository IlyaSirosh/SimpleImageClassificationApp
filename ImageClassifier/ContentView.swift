//
//  ContentView.swift
//  ImageClassifier
//
//  Created by Illya Sirosh on 16.01.2021.
//

import SwiftUI
import ImagePickerView

struct ContentView: View {
    @EnvironmentObject var service: ClassificationService
    @State var uiImage: UIImage = UIImage()
    @State var isTakingPhoto = false
    
    var title: String {
        switch service.result {
        case .recognized(let name):
            return name
        case .none, .proccessing:
            return ""
        default:
            return "Unrecognized"
        }
    }
    
    var body: some View {
    
        ZStack {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
            VStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .offset(y: 20)
                Spacer()
                Button(action: {
                    self.isTakingPhoto = true
                }, label: {
                    Text("Take photo")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(40)
                })
                .offset(y: -20)
            }
        }.sheet(isPresented: $isTakingPhoto, content: {
            ImagePickerView(sourceType: .camera, onImagePicked: { image in
                self.uiImage = image
                self.service.proccess(image: image)
            })
        })
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
