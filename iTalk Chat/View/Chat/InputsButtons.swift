//
//  InputsButtons.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct InputsButtons: View {
    // @State private var shouldShowImagePicker = false
    // @State private var shouldShowCamara = false
    // @State private var shouldShowContact = false
    // @State private var shouldShowLocation = false
    // @State private var shouldShowDocument = false
    // @State var typeOfContent: TypeOfContent
    @ObservedObject var vm: ChatsVM
    @ObservedObject var vmContacts = ContactsVM()
    private let buttonsSize: CGFloat = 42
    
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
                    Image(systemName: "a.circle")
                }
            }
            Button {
                vmContacts.shouldShowLocation = true
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
                vm.shouldShowImagePicker.toggle()
             } label: {
             Image(systemName: "gift.circle")
             }
             Button {
             vm.shouldShowCamara.toggle()
             } label: {
             Image(systemName: "camera.circle")
             }
             */
            Button {
                vm.shouldShowImagePicker.toggle()
            } label: {
                Image(systemName: "photo.circle")
            }
            Button {
               // vmContacts.shouldShowLocation = true
            } label: {
                Image(systemName: "flame.circle")
            }
            Spacer()
        }
        .font(.system(size: buttonsSize))
    }
}
