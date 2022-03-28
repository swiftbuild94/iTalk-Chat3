//
//  HistoryView.swift
//  iTalk
//
//  Created by Patricio Benavente on 2/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
	@ObservedObject private var vm = ContactsVM()
	@State private var shouldShowNewUserScreen = false
	@State private var shouldNavigateToChatView = false
	@State private var userSelected: User?
	
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
//				ScrollView {
//					List(vm.recentMessages) { recentMessage in
//						let uid = recentMessage.fromId
//						let user = vm.usersDictionary[uid]
////                        NavigationLink(destination: ChatView(contact: vm.user!)) {
////							HistoryCell(recentMessage: recentMessage, user: user!)
////						}
////					}
//				}
//			}
//			.navigationBarHidden(true)
//			.fullScreenCover(isPresented: $shouldShowNewUserScreen) {
////				ContactsView(didSelectNewUser: { user in
////					print(user.name)
////					self.userSelected = user
//					self.shouldNavigateToChatView.toggle()
////				})
			}
		}
	}
}




struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		HistoryView()
			.preferredColorScheme(.dark)
		HistoryView()
    }
}
