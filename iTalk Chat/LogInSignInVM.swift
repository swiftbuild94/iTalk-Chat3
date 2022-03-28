//
//  LogInSignInVM.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import SwiftUI

class LogInSignInVM: ObservableObject {
	@Published var isLoginMode = true
	@Published var isUserLoggedOut = true
	@Published var name = ""
	@Published var email = ""
	@Published var password = ""
	@Published var passwordRetype = ""
	@Published var phoneNumber = ""
	@Published var errorMessage = " "
	@Published var image: UIImage?
	@Published var shouldShowLogOutOptions = false
//    @Published var didCompleateLoginProcess: (()?) -> ()
    
    init() {
        
    }
    
	func handleAction() {
		if isLoginMode {
            loginUser()
            print("Login")
		} else {
            print("CreateUser")
            createAccount()
		}
	}
	
	
	// MARK: LogIn User
	func loginUser() {
		FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
			if let error = error {
				self.errorMessage = "Failed to login user: \(error)"
				return
			}
			print("Succefully login user:  \(result?.user.uid ?? "")")
//			self.didCompleateLoginProcess()
            self.isUserLoggedOut = false
		}
	}
	
	// MARK: Create Account
	func createAccount() {
        if self.image == nil {
            self.errorMessage = "You must select an image"
            return
        }
        if ((name != "") && (email != "") && (password != "")) {
			if (password == passwordRetype) {
                print("Name: \(name)")
				FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
					if let error = error {
						self.errorMessage = "Failed to create user: \(error)"
						return
					}
					print("Succefully created user:  \(result?.user.uid ?? "")")
                    self.persistImageToStorage()
				}
			} else {
				self.errorMessage = "Passwords do not match"
			}
        } else {
            self.errorMessage = "Please fill all data"
        }
	}
	
	func persistImageToStorage() {
		guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//		let fileName = UUID().uuidString
		let ref = FirebaseManager.shared.storage.reference(withPath: uid)
		guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
		ref.putData(imageData, metadata: nil) { metadata, error in
			if let err = error {
				self.errorMessage = "Fail to save image: \(err)"
				return
			}
			ref.downloadURL { url, error in
				if let err = error {
					self.errorMessage = "Fail to retrive downloadURL image: \(err)"
					return
				}
				print("Success storing image with URL \(String(describing: url?.absoluteString))")
				guard let url = url else { return }
				self.storeUserInformation(url)
			}
		}
	}
	   
	private func storeUserInformation(_ imageURL: URL? = nil) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let image = imageURL else { return }
        
        let userData: [String : Any] = [FirebaseConstants.uid: uid,
                            FirebaseConstants.name: self.name,
                            FirebaseConstants.email: self.email,
                            FirebaseConstants.phone: self.phoneNumber,
                            FirebaseConstants.photo:  image.absoluteString]
        print(userData)
		FirebaseManager.shared.firestore.collection("users")
			.document(uid).setData(userData) { error in
				if let err = error {
					print(err)
					self.errorMessage = "Error: \(err)"
					return
				}
				print("Success saving User")
                self.isUserLoggedOut = false
//				self.didCompleateLoginProcess()
			}
	}
	
	
	// MARK: - SignOut
	 func handleSignOut() {
		self.isUserLoggedOut.toggle()
		try? FirebaseManager.shared.auth.signOut()
	}
}
