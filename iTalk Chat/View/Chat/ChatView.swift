//
//  ChatView.swift
//  iTalk
//
//  Created by Patricio Benavente on 9/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import FDWaveformView

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
                        ChatAudioBar(vmChat: vmChat)
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
                    vmChat.handleSend(.photoalbum)
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
                            MessageView(vm: vm, message: message)
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
    @ObservedObject var vm: ChatsVM
    
	let message: Chat
	private let topPadding: CGFloat = 8

	var body: some View {
		VStack {
			if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
				HStack {
					Spacer()
                    HStack {
                        Bubble(vm: vm, message: message)
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
                        Bubble(vm: vm, message: message)
                    }
                    .padding()
                    .background(vm.bubbleColor)
					.cornerRadius(8)
					Spacer()
				}
				.padding(.horizontal)
				.padding(.top, topPadding)
			}
		}
	}
}

struct Bubble: View {
    @ObservedObject var vm: ChatsVM
    let message: Chat
    
    var body: some View {
        if message.photo != nil {
            showPhoto(vm: vm, message: message)
        }
        if message.audio != nil {
            showAudio(vm: vm, message: message)
        }
        showText(message: message)
    }
}

struct showText: View {
    let message: Chat
    
    var body: some View {
        if let text = message.text {
            if ((text.prefix(7) == "http://") || (message.text?.prefix(8) == "https://")) {
                Link(text, destination: URL(string: text)!)
                    .foregroundColor(.red)
            } else if text.prefix(4) == "www." {
                Link(text, destination: URL(string: "http://" + text)!)
                    .foregroundColor(.red)
            } else if text.isEmail() {
                Link(text, destination: URL(string: "mailto://" + text)!)
                    .foregroundColor(.red)
            } else if text.isPhone() {
                Link(text, destination: URL(string: "phone://" + text)!)
                    .foregroundColor(.red)
            } else {
                Text(text)
                    .foregroundColor(.white)
            }
        }
            
    }
}

struct showPhoto: View {
    @ObservedObject var vm: ChatsVM
    let message: Chat
    
    var body: some View {
        Button {
            print("Show Image")
        } label: {
            if let photo = vm.downloadPhoto(message.photo!) {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 200, height: 200)
            } else {
                WebImage(url: URL(string: message.photo!))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 200, height: 200)
            }
        }
    }
}

struct showAudio: View {
    @ObservedObject var vm: ChatsVM
    @ObservedObject var vmAudio = AudioPlayer()
    @ObservedObject var timerManager = TimerManager()
    let message: Chat
    
    var body: some View {
        if vmAudio.isPlaying {
            Button {
                vmAudio.stopPlay()
                let _ = timerManager.stopTimer()
            } label: {
                Image(systemName: "stop.fill")
                Text(String(format: "%.1f", timerManager.secondsElapsed))
            }
        } else {
            Button {
                timerManager.startTimer()
                if let audio = vm.downloadAudio(message.audio!) {
                    vmAudio.playAudio(audio)
                }
            } label: {
                Image(systemName: "play.fill")
                if let audioTimer = message.audioTimer {
                    let trimedAudio = String(audioTimer).prefix(2)
                    Text(trimedAudio)
                }
            }
        }
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
