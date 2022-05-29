//
//  InputsButtons.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct InputsButtons: View {
//    @State private var shouldShowImagePicker = false
//    @State private var shouldShowCamara = false
//    @State private var shouldShowContact = false
///Users/swiftbuild94/Documents/iTalk Chat/iTalk Chat/View/Chat/ChatTextBar.swift    @State private var shouldShowLocation = false
//    @State private var shouldShowDocument = false
//    @State var typeOfContent: TypeOfContent
    @ObservedObject var vm: ChatsVM
    
    private let buttonsSize: CGFloat = 32
    
    var body: some View {
        HStack {
            Spacer()
            if vm.typeOfContent != .audio {
                Button {
                    vm.focus = false
                    vm.typeOfContent = .audio
                } label: {
                    Image(systemName: "mic.circle")
                }
            } else {
                Button {
                    vm.focus = true
                    vm.typeOfContent = .text
                } label: {
                    Image(systemName: "character.bubble")
                }
            }
            Button {
                vm.shouldShowLocation.toggle()
            } label: {
                Image(systemName: "location.circle")
            }
            /*
            Button {
                vm.shouldShowDocument.toggle()
            } label: {
                Image(systemName: "doc.circle")
            }
            Button {
                vm.shouldShowContact.toggle()
            } label: {
                Image(systemName: "person.crop.circle")
            }
            Button {
                vm.shouldShowCamara.toggle()
            } label: {
                Image(systemName: "camera.on.rectangle")
            }
            */
            Button {
                vm.shouldShowImagePicker.toggle()
            } label: {
                Image(systemName: "photo.on.rectangle")
            }
            Spacer()
        }
        .font(.system(size: buttonsSize))
    }
}
