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
    var users: [User]?
    
    init(){
        vm.getAllUsers()
        self.users = vm.users
        print(">>>>>USERS:")
        print(self.users!)
    }
    
	var body: some View {
		NavigationView {
                ScrollView {
                    Text("")
                    ForEach(vm.users) { contact in
                        NavigationLink(destination: ChatView(chatUser: contact)) {
//                            Text(contact.name)
                            ContactCell(contact: contact)
                        }
                    }
                }
//			if $vm.contacts != [] {
//				Grid(contacts!) { contact in
//					 Text("Count: \(contacts.count)")
//					NavigationLink(destination: ChatView(contact: contact)) {
//						ContactsView(contact: contact)
//					}
//				}
//			}
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
