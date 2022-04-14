//
//  LogInView.swift
//  iTalk
//
//  Created by Patricio Benavente on 24/03/2022.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm = LogInSignInVM()
//    @State private var name = ""
//    @State private var email = ""
//    @State private var password = ""
//    @State private var passwordRetype = ""
//    @State private var phoneNumber = ""
//    @State private var errorMessage = "Error"
//  @State private var isLoginMode = true
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    var didCompleateLoginProcess: () -> ()
    
//    init(){
//        if !vm.isUserLoggedOut {
//            self.didCompleateLoginProcess()
//        }
//    }
    
    func handleAction() {
        if vm.isLoginMode {
            vm.loginUser()
        } else {
            vm.createAccount()
        }
        print("IsUserLoggedOut \(vm.isUserLoggedOut)")
        if vm.isUserLoggedOut {
            self.didCompleateLoginProcess()
        }
    }
    
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
                                  if let image = vm.image {
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
                                  .dynamicTypeSize(.large)
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                              TextField("Phone", text: $vm.phoneNumber)
                                  .keyboardType(.phonePad)
                                  .dynamicTypeSize(.large)
                              SecureField("Password", text: $vm.password)
                                  .keyboardType(/*@START_MENU_TOKEN@*/.asciiCapableNumberPad/*@END_MENU_TOKEN@*/)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                              SecureField("Retype Password", text: $vm.passwordRetype)
                                  .keyboardType(/*@START_MENU_TOKEN@*/.asciiCapableNumberPad/*@END_MENU_TOKEN@*/)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                          }.textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                              .background(Color.white)
                              .disableAutocorrection(true)
                              .font(.system(size: 24))
                          Spacer()
                      } else {
                          Group {
                              TextField("Email", text: $vm.email)
                                  .keyboardType(.emailAddress)
                                  .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                              SecureField("Password", text: $vm.password)
                                  .keyboardType(.asciiCapableNumberPad)
                              .autocapitalization(.none)
                                  .dynamicTypeSize(.large)
                          }
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding(12)
                              .background(Color.white)
                              .disableAutocorrection(true)
                      }
                  }
                 
                  Button(action: {
                      handleAction()
                  }, label: {
                      Text(vm.isLoginMode ? "Log In" : "Create Account" )
                          .font(.headline)
                          .foregroundColor(.white)
                          .padding(.vertical, 10)
                  })
//                      .buttonStyle(.bordered)
//                      .background(Color.blue)
                      .buttonStyle(.borderedProminent)
                      .buttonBorderShape(.roundedRectangle(radius: 10))
                      .controlSize(.regular)
                      .padding()
                  Text(vm.errorMessage)
                      .foregroundColor(.red)
              }
          }
          .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
              ImagePicker(selectedImage: $vm.image, didSet: $shouldShowImagePicker)
          }
    }
        
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(didCompleateLoginProcess: {
            
        })
    }
}
