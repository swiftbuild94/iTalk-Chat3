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
	
//    init(chatUser: User) {
//        self.vmChat = .init(chatUser: chatUser)
//        self.userSelected = chatUser
//    }
    
    var body: some View {
        NavigationView {
                ScrollView {
                    Text(vm.errorMessage)
                        .foregroundColor(Color.red)
                    ForEach(vm.recentMessages, id:\.self) { recentMessage in
                        let uid = recentMessage.fromId
                        let user = vm.usersDictionary[uid]
                        if let contact = user {
                            NavigationLink(destination: ChatView(chatUser: contact)) {
                                HistoryCell(recentMessage: recentMessage, user: contact)
                            }
                        } else {
                            Text("Error")
                                .foregroundColor(Color.red)
                            Text(String(describing: recentMessage))
                        }
                    }
                }
                .navigationBarTitle(Text("History"))
        }
    }
}




struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.preferredColorScheme(.dark)
    }
}
