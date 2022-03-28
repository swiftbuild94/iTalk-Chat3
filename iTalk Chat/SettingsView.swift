//
//  SettingsView.swift
//  iTalk
//
//  Created by Patricio Benavente on 25/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SettingsView: View {
    @ObservedObject private var vmContacts = ContactsVM()
    @ObservedObject private var vmLogin = LogInSignInVM()
    @State var shouldShowLogOutOptions = true
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
     @State private var isAutoPlayAudio = true
     @State private var isAutoRecordAudio = true
//    @State private var isUserLoggedOut = true

    let optionsSize: CGFloat = 16
    
    var body: some View {
        NavigationView {
            Form {
                userInfo(currentUser: vmContacts.currentUser)
                Divider()
                Text("Chat Background")
                Toggle("Auto play audio message", isOn: $isAutoPlayAudio)
                Toggle("Auto record audio message", isOn: $isAutoRecordAudio)
                Divider()
                Text("Blocked Users")
                Divider()
                Button {
                    vmLogin.shouldShowLogOutOptions.toggle()
                } label: {
                    Text("Log Out")
                        .font(.system(size: optionsSize, weight: .bold))
                        .foregroundColor(Color.red)
                }
            }
            //            .padding()
            .actionSheet(isPresented: $vmLogin.shouldShowLogOutOptions) {
                .init(title: Text("Log Out"), message: Text("Are you sure you want to Log Out"), buttons: [
                        .destructive(Text("Log Out"), action: {
                            print("Logged Out")
                            vmLogin.handleSignOut()
                        }),
                        .cancel()
                ])
            }
        }
//        .fullScreenCover(isPresented: vm.$shouldShowImagePicker, onDismiss: nil) {
//            ImagePicker(selectedImage: vm.$image, didSet: vm.$shouldShowImagePicker)
//        }
//        .navigationBarTitle(Text("Settings"), displayMode: .inline)

//}
    }    
}

struct userInfo: View {
    let shadowRadius: CGFloat = 15
    let circleLineWidth: CGFloat = 1
    let imageSize: CGFloat  = 52
    let spacing: CGFloat = 4
    let usernameSize: CGFloat = 16
    let onlineCircleSize: CGFloat = 14
    let hstackSpacing: CGFloat = 16
    var currentUser: User?
    @State private var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: hstackSpacing) {
                    Text((currentUser?.photo)!)
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        WebImage(url: URL(string: (currentUser?.photo)!))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(imageSize)
                                .frame(width: imageSize, height: imageSize)
                    }
                    .clipShape(Circle())
                        .shadow(radius: shadowRadius)
                        .overlay(Circle().stroke(Color.blue, lineWidth: circleLineWidth))
                    Spacer()
                    VStack(alignment: .leading, spacing: spacing) {
                        Text(currentUser?.name ?? "Name not Registered")
                            .font(.system(size: usernameSize, weight: .bold))
                        HStack {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: onlineCircleSize, height: onlineCircleSize)
                            Text("online")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    Divider()
                }.padding(.horizontal)
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
