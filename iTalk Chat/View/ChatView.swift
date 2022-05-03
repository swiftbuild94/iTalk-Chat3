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
//    @ObservedObject private var vmLogin = LogInSignInVM()
    @ObservedObject fileprivate var vmChat: ChatsVM
	@State private var zoomed = false
//	@State private var typeOfContent: TypeOfContent = .text
//    @State private var image: UIImage?
    @State private var shouldShowImagePicker = false
    @FocusState fileprivate var focus
	private var contact: User
	private let topPadding: CGFloat = 8
	
	init(chatUser: User){
		self.contact = chatUser
		self.vmChat = .init(chatUser: chatUser)
        self.focus = vmChat.focus
	}
	
	var body: some View {
            ZStack(alignment: .top) {
                VStack() {
                    MessagesView(vm: vmChat)
                        .padding(.bottom, topPadding)
                        .gesture(
                            TapGesture()
                                .onEnded({ _ in
                                    focus = false
                                })
                        )
                    InputsButtons(vm: vmChat)
                    if vmChat.typeOfContent == .text {
                        ChatTextBar(vm: vmChat)
                    } else if vmChat.typeOfContent == .audio {
                        ChatAudioBar()
                    }
                }
            }
			.toolbar {
                ToolbarItem(placement: .navigation ) {
                    Button {
//                          chatMode.wrappedValue.dismiss()
                    } label: {
                        Text(contact.name)
                            .foregroundColor(Color.accentColor)
                            .dynamicTypeSize(.xxxLarge)
                        ContactImage(contact: contact)
                    }
                }
//                ToolbarItemGroup(placement: .navigationBarTrailing)  {
//                    Image(systemName: "phone.fill")
//                        .foregroundColor(Color.blue)
//                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
//                    Image(systemName: "video.fill")
//                        .foregroundColor(Color.blue)
//                        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
//                }
            }
			.onDisappear {
//                $vmChat.stopFirestoreListener()
			}
            .fullScreenCover(isPresented: $vmChat.shouldShowImagePicker, onDismiss: {
                if vmChat.image != nil {
                    vmChat.persistImageToStorage()
                }
            }) {
                ImagePicker(selectedImage: $vmChat.image, didSet: $shouldShowImagePicker)
			}
	}
}


struct ContactImage: View {
	var contact: User
	private let imageSize: CGFloat  = 38
	private let imagePadding: CGFloat = 8
	private let shadowRadius: CGFloat = 15
	private let circleLineWidth: CGFloat = 1
	private let cornerRadius: CGFloat = 38
    
    var body: some View {
        if contact.profileImageURL == nil {
            Image(systemName: "person.fill")
                .clipShape(Circle())
                .shadow(radius: shadowRadius)
                .overlay(Circle().stroke(Color.black, lineWidth: circleLineWidth))
                .font(.system(size: imageSize))
                .padding(imagePadding)
        } else {
            Image(contact.profileImageURL!)
            WebImage(url: URL(string: contact.profileImageURL!))
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipped()
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color(.label), lineWidth: circleLineWidth) )
        }
    }
}



struct MessagesView: View {
	@ObservedObject var vm: ChatsVM
	private let topPadding: CGFloat = 10
	static let bottomAnchor = "BottomAnchor"
//	var chatUser: User
	
//	init(chatUser: User){
//		self.chatUser = chatUser
//		self.vm = .init(chatUser: chatUser)
//	}
	
	var body: some View {
        ZStack(alignment: .top){
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
//        .background(.gray)
        #warning("TODO: Image Background")
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
                        if message.photo != nil {
                                Image(message.photo ?? "")
                                WebImage(url: URL(string: message.photo ?? "" ))
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 200, height: 200)
                        }
						Text(message.text ?? "")
							.foregroundColor(.white)
					}
					.padding()
                    .background(.gray)
					.cornerRadius(8)
				}
				.padding(.horizontal)
				.padding(.top, topPadding)
			} else {
				HStack {
					HStack {
                        if message.photo != nil {
                                Image(message.photo ?? "")
                                WebImage(url: URL(string: message.photo ?? "" ))
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 200, height: 200)
                        }
						Text(message.text ?? "")
							.foregroundColor(.white)
					}
					.padding()
					.background(Color.blue)
					.cornerRadius(8)
					Spacer()
				}
				.padding(.horizontal)
				.padding(.top, topPadding)
			}
		}
	}
}


struct InputsButtons: View {
//	@State private var shouldShowImagePicker = false
//	@State private var shouldShowCamara = false
//	@State private var shouldShowContact = false
//	@State private var shouldShowLocation = false
//	@State private var shouldShowDocument = false
//	@State var typeOfContent: TypeOfContent
    @ObservedObject var vm: ChatsVM
    
	private let buttonsSize: CGFloat = 24
	
	var body: some View {
		HStack {
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
            /*
			Button {
                vm.shouldShowLocation.toggle()
			} label: {
                Image(systemName: "location.circle")
			}
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
		}
		.font(.system(size: buttonsSize))
	}
}


struct ChatAudioBar: View {
    @State private var audioIsRecording = false
    @ObservedObject var audioRecorder = AudioRecorder()
   
    var body: some View {
        if audioIsRecording == true {
            Button {
                print("Stop Recording")
                self.audioIsRecording = false
                self.audioRecorder.stopRecording()
                self.audioRecorder.stopTimer()
            } label: {
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipped()
                    .foregroundColor(.primary)
                    .padding(.bottom, 40)
                    .padding()
                Spacer()
                Text(String(format: "%.1f", audioRecorder.secondsElapsed))
                    .dynamicTypeSize(.xxxLarge)
                Spacer()
                Button {
                    self.audioIsRecording = false
                    self.audioRecorder.stopRecording()
                    self.audioRecorder.stopTimer()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .foregroundColor(.blue)
                        .padding(.bottom, 40)
                        .padding()
                }
            }
        } else {
            Button {
                print("Start Recording")
//                self.audioIsRecording = true
//                self.audioRecorder.startTimer()
                self.audioRecorder.startRecording()
            } label: {
                Image(systemName: "circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .foregroundColor(.red)
                    .padding(.bottom, 40)
            }
        }
    }
}

struct ChatTextBar: View {
    @ObservedObject var vmChat: ChatsVM
//	@ObservedObject private var chatText = vm.chatText
//    @State var chatText: String?
   
	private let buttonsSize: CGFloat = 24
	private let topPadding: CGFloat = 8
//	var chatUser: User
    @FocusState var focus: Bool
    
    init(vm: ChatsVM) {
        self.vmChat = vm
        self.focus = true
    }
//
	var body: some View {
//		Text(vm.errorMessage)
		HStack {
//			DescriptionPlaceholder()
            TextField("", text: $vmChat.chatText)
//            TextEditor(text: $vmChat.chatText)
                .focused($focus)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)
                .opacity(vmChat.chatText.isEmpty ? 0.5 : 1)
                .foregroundColor(Color.accentColor)
                .border(.blue)
                .accessibilityLabel("Message")
                .onSubmit {
                    vmChat.sendText()
//                    vmChat.focus = false
                }
                .submitLabel(.send)
			Button {
                vmChat.sendText()
//                vmChat.focus = false
                //UIApplication.shared.keyWindow?.endEditing(true)
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


let data: [String: Any] = ["name": "Test"]
let userTest = User(data: data)

struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
        ChatView(chatUser: userTest)
//            .preferredColorScheme(.dark)
	}
}
