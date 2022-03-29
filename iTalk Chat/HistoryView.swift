//
//  HistoryView.swift
//  iTalk
//
//  Created by Patricio Benavente on 2/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject private var vmConctacts = ContactsVM()
//    @ObservedObject private var vmChat: ChatsVM
	@State private var shouldShowNewUserScreen = false
	@State private var shouldNavigateToChatView = false
	@State private var userSelected: User?
	
//    init(chatUser: User) {
//        self.vmChat = .init(chatUser: chatUser)
//        self.userSelected = chatUser
//    }
//    
    var body: some View {
		NavigationLink("", isActive: $shouldNavigateToChatView) {
//            ChatView(contact: vm.$userSelected)
		}
		NavigationView {
			VStack {
				Text("History")
				Spacer()
				Button {
					shouldShowNewUserScreen.toggle()
				} label: {
					Image(systemName: "plus.message.fill")
						.foregroundColor(Color.blue)
				}
				ScrollView {
//                    List(vmChat.recentMessages) { recentMessage in
////                    ForEach(0...10) {
//                    let uid = recentMessage.fromId
//						let user = vmChat.usersDictionary[uid]
//                        NavigationLink(destination: ChatView(contact: vm.user)) {
//							HistoryCell(recentMessage: recentMessage, user: user!)
//						}
//					}
				}
			}
			.navigationBarHidden(true)
			.fullScreenCover(isPresented: $shouldShowNewUserScreen) {
				ContactsView(didSelectNewUser: { user in
					print(user.name)
					self.userSelected = user
					self.shouldNavigateToChatView.toggle()
				})
			}
		}
	}
}




struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.preferredColorScheme(.dark)
        ContentView()
    }
}
