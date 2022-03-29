//
//  ChatView.swift
//  iTalk
//
//  Created by Patricio Benavente on 9/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {
	@Environment(\.presentationMode) var chatMode
    @ObservedObject private var vmLogin = LogInSignInVM()
    @ObservedObject private var vmChat: ChatsVM
	@State private var shouldShowImagePicker = false
	@State private var zoomed = false
	@State private var typeOfContent: TypeOfContent = .text
	var contact: User
	private let topPadding: CGFloat = 8
	
	init(chatUser: User){
		self.contact = chatUser
		self.vmChat = .init(chatUser: chatUser)
	}
	
	var body: some View {
//		NavigationView {
//			VStack {
//				ContactImage(contact: contact)
////				MessagesView(chatUser: contact)
//						.padding(.bottom, topPadding)
//				InputsButtons(typeOfContent: typeOfContent)
//				if typeOfContent == .text {
////					ChatTextBar(chatUser: contact)
//				} else if typeOfContent == .audio {
//					ChatAudioBar()
//				}
//			}
//			.navigationTitle(Text(contact.name))
//			.navigationBarTitleDisplayMode(.inline)
//			.toolbar {
//				ToolbarItemGroup(placement: .navigationBarLeading) {
//					Button {
//						chatMode.wrappedValue.dismiss()
//					} label: {
//						Text("<")
//					}
//				}
//			}
//			.onDisappear {
//				vm.stopFirestoreListener()
//			}
//			.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
//				//			ImagePicker(selectedImage: $image, didSet: $shouldShowImagePicker)
//			}
//		}
        Text("Hello World!")
	}
}


struct ContactImage: View {
	var contact: User
	private let imageSize: CGFloat  = 52
	private let imagePadding: CGFloat = 8
	private let shadowRadius: CGFloat = 15
	private let circleLineWidth: CGFloat = 1
	private let cornerRadius: CGFloat = 50
	
	var body: some View {
		HStack {
			if contact.photo == nil {
				Image(systemName: "person.fill")
					.clipShape(Circle())
					.shadow(radius: shadowRadius)
					.overlay(Circle().stroke(Color.black, lineWidth: circleLineWidth))
					.font(.system(size: imageSize))
					.padding(imagePadding)
			} else {
				WebImage(url: URL(string: contact.photo!))
					.resizable()
					.scaledToFill()
					.frame(width: imageSize, height: imageSize)
					.clipped()
					.cornerRadius(cornerRadius)
					.overlay(RoundedRectangle(cornerRadius: cornerRadius)
								.stroke(Color(.label), lineWidth: circleLineWidth)
					)
			}
		}
	}
}



struct MessagesView: View {
	@ObservedObject private var vm: ChatsVM
	private let topPadding: CGFloat = 10
	static let bottomAnchor = "BottomAnchor"
	var chatUser: User
	
//	init(chatUser: User){
//		self.chatUser = chatUser
//		self.vm = .init(chatUser: chatUser)
//	}
	
	var body: some View {
		ScrollView {
			ScrollViewReader { scrollViewProxy in
				VStack {
					ForEach(vm.chatMessages) { message in
						MessageView(message: message)
					}
					HStack { Spacer() }
						.id(Self.bottomAnchor)
				}
				.onReceive(vm.$count) { _ in
					withAnimation(.easeOut(duration: 0.5)) {
						scrollViewProxy.scrollTo(Self.bottomAnchor, anchor: .bottom)
					}
				}
			}
		}
	}
}

struct MessageView: View {
	let message: Chat
	private let topPadding: CGFloat = 8
	
	var body: some View {
		VStack {
			if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
				HStack {
					Spacer()
					HStack {
						Text(message.text ?? "")
							.foregroundColor(.white)
					}
					.padding()
					.background(Color.blue)
					.cornerRadius(8)
				}
				.background(.white)
				.padding(.horizontal)
				.padding(.top, topPadding)
			} else {
				HStack {
					HStack {
						Text(message.text ?? "")
							.foregroundColor(.white)
					}
					.padding()
					.background(Color.gray)
					.cornerRadius(8)
					Spacer()
				}
				.background(.white)
				.padding(.horizontal)
				.padding(.top, topPadding)
			}
		}
	}
}


struct InputsButtons: View {
	@State private var shouldShowImagePicker = false
	@State private var shouldShowCamara = false
	@State private var shouldShowContact = false
	@State private var shouldShowLocation = false
	@State private var shouldShowDocument = false
	@State var typeOfContent: TypeOfContent
	
	private let buttonsSize: CGFloat = 24
	
	var body: some View {
		HStack {
			if typeOfContent != .audio {
				Button {
					typeOfContent = .audio
				} label: {
					Image(systemName: "mic.circle")
				}
			}
			Button {
				shouldShowLocation.toggle()
			} label: {
				Image(systemName: "location.circle")
			}
			Button {
				shouldShowDocument.toggle()
			} label: {
				Image(systemName: "doc.circle")
			}
			Button {
				shouldShowContact.toggle()
			} label: {
				Image(systemName: "person.crop.circle")
			}
			Button {
				shouldShowCamara.toggle()
			} label: {
				Image(systemName: "camera.on.rectangle")
			}
			Button {
				shouldShowImagePicker.toggle()
			} label: {
				Image(systemName: "photo.on.rectangle")
			}
			if typeOfContent != .text {
				Button {
					typeOfContent = .text
				} label: {
					Image(systemName: "charecter.bubble")
				}
			}
		}
		.font(.system(size: buttonsSize))
	}
}


struct ChatAudioBar: View {
	@State private var audioIsRecording = false
	
	var body: some View {
		HStack {
			if audioIsRecording {
				Image("audiowave")
					.aspectRatio(contentMode: .fit)
				Image(systemName: "record.circle.fill")
					.foregroundColor(Color.blue)
				Image(systemName: "stop.circle")
				Button {
					audioIsRecording = false
				} label: {
					Image(systemName: "arrow.up.circle.fill")
						.foregroundColor(Color.blue)
				}
			} else {
				Button {
					audioIsRecording = true
				} label: {
					Image(systemName: "mic.circle")
						.foregroundColor(Color.blue)
				}
			}
		}
	}
}

struct ChatTextBar: View {
	@ObservedObject private var vm: ChatsVM
//	@ObservedObject private var chatText = vm.chatText
	private let buttonsSize: CGFloat = 24
	private let topPadding: CGFloat = 8
	var chatUser: User
	
//	init(chatUser: User){
//		self.chatUser = chatUser
//		self.vm = .init(chatUser: chatUser)
//	}
	
	var body: some View {
		Text(vm.errorMessage)
		HStack {
//			DescriptionPlaceholder()
			TextEditor(text: $vm.chatText)
				.opacity(vm.chatText.isEmpty ? 0.5 : 1)
			Button {
				vm.sendText()
			} label: {
				Image(systemName: "arrow.up.circle.fill")
					.foregroundColor(Color.blue)
			}
			.font(.system(size: buttonsSize))
			.padding(.horizontal)
			.padding(.vertical, topPadding)
		}
		.padding()
	}
}



struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
        ContentView()
	}
}
