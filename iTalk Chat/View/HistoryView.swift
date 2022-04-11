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
//    @ObservedObject private var vmChat = ChatsVM(chatUser: nil)
	@State private var shouldShowNewUserScreen = false
	@State private var shouldNavigateToChatView = false
	@State private var userSelected: User?
	
//    init(chatUser: User) {
//        self.vmChat = .init(chatUser: chatUser)
//        self.userSelected = chatUser
//    }
    
    var body: some View {
//		NavigationLink("", isActive: $shouldNavigateToChatView) {
////            ChatView(contact: vm.$userSelected)
//		}
		NavigationView {
			VStack {
//				Button {
//					shouldShowNewUserScreen.toggle()
//				} label: {
//					Image(systemName: "plus.message.fill")
//						.foregroundColor(Color.blue)
//				}
				ScrollView {
                    Text(vmConctacts.errorMessage)
                        .foregroundColor(Color.red)
                    ForEach(vmConctacts.recentMessages, id:\.self) { recentMessage in
                        let uid = recentMessage.fromId
						let user = vmConctacts.usersDictionary[uid]
                        NavigationLink(destination: ChatView(chatUser: user!)) {
                            HistoryCell(recentMessage: recentMessage, user: user!)
						}
					}
				}
                .navigationTitle("History")
			}
			.fullScreenCover(isPresented: $shouldShowNewUserScreen) {
				ContactsView(didSelectNewUser: { user in
//					print(user.name)
					self.userSelected = user
					self.shouldNavigateToChatView.toggle()
				})
			}
		}
	}
}




//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
////		HistoryView()
////			.preferredColorScheme(.dark)
//    }
//}
