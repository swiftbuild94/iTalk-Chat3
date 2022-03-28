//
//  LogInView.swift
//  iTalk
//
//  Created by Patricio Benavente on 24/03/2022.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm = LogInSignInVM()
    @Binding var isPresented: Bool
//    @State private var name = ""
//    @State private var email = ""
//    @State private var password = ""
//    @State private var passwordRetype = ""
//    @State private var phoneNumber = ""
//    @State private var errorMessage = "Error"
//  @State private var isLoginMode = true
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
//    @State var didCompleateLoginProcess: () -> ()
    
    var body: some View {
          VStack {
              Picker(selection: $vm.isLoginMode, label: Text("Picker")) {
                  Text("Login")
                      .tag(true)
                  Text("Create Account")
                      .tag(false)
              }.pickerStyle(SegmentedPickerStyle())
                  .padding()
              Spacer()
              ScrollView {
                  VStack {
                      if !vm.isLoginMode {
                          Button {
                              shouldShowImagePicker.toggle()
                          } label: {
                              VStack {
                                  if let image = self.image {
                                      Image(uiImage: image)
                                          .resizable()
                                          .scaledToFill()
                                          .frame(width: 128, height: 128)
                                          .cornerRadius(64)
                                  } else {
                                      Image(systemName: "person.fill")
                                          .font(.system(size: 64))
                                          .padding()
                                          .foregroundColor(Color(.label))
                                  }
                              }
                              .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 3))
                          }
                          Spacer()
                          Group {
                              TextField("Name", text: $vm.name)
                                  .autocapitalization(.words)
                                  .keyboardType(.asciiCapable)
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                              TextField("Phone", text: $vm.phoneNumber)
                                  .keyboardType(.phonePad)
                              SecureField("Password", text: $vm.password)
                              SecureField("Retype Password", text: $vm.passwordRetype)
                          }.textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                              .background(Color.white)
                              .disableAutocorrection(true)
                              .font(.system(size: 32))
                          Spacer()
                      } else {
                          Group {
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                              SecureField("Password", text: $vm.password)
                          }
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                              .background(Color.white)
                              .disableAutocorrection(true)
                              .font(.system(size: 32))
                      }
                  }
                 
                  Button(action: {
                      vm.handleAction()
                  }, label: {
                      Text(vm.isLoginMode ? "Log In" : "Create Account" )
                          .font(.system(size: 32))
                          .foregroundColor(.white)
                          .padding(.vertical, 10)
                  })
                      .background(Color.blue)
                      .padding()
                  Text(vm.errorMessage)
                      .foregroundColor(.red)
              }
          }
          .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
              ImagePicker(selectedImage: $image, didSet: $shouldShowImagePicker)
          }
    }
        
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
