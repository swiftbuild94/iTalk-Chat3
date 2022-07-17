//
//  iTalk.swift
//  iTalk
//
//  Created by Patricio Benavente on 26/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI

struct iTalkView: View {
	@ObservedObject private var vm = ContactsVM()
    @State private var shouldShowNewUserScreen = false
    @State private var shouldNavigateToChatView = false
    @State private var userSelected: User?

	var body: some View {
		NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                    .foregroundColor(Color.red)
                ForEach(vm.recentMessages, id:\.self) { recentMessage in
                    let uid = recentMessage.toId
                    let user = vm.usersDictionary[uid]
                    if let user = user {
                        NavigationLink(destination: ChatView(chatUser: user)) {
                            HistoryCell(contact: user, recentMessage: recentMessage)
                        }
                    }
                }
                ForEach(vm.users, id:\.self) { user in
                    if let user = user {
                        NavigationLink(destination: ChatView(chatUser: user)) {
                            ContactCell(contact: user)
                        }
                    }
                }
//                    if UIDevice.current.userInterfaceIdiom == .pad {
            }
                .navigationBarTitle(Text("iTalk"))
        }
	}
}

struct NotificationsView: View {
	var chats: Int
	var body: some View {
		ZStack{
			Text("\(chats) chats")
				.font(.headline)
				.bold()
				.foregroundColor(Color.black)
				.accentColor(Color.black)
				.clipShape(Circle())
		}
//		.overlay(Circle().fill(Color.red))
		.overlay(Circle().stroke(Color.black))
		.shadow(radius: 20)
	}
}

struct iTalk_Previews: PreviewProvider {
    static var previews: some View {
		iTalkView()
    }
}
