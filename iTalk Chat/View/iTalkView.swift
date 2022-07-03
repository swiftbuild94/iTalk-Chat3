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
    
    init(){
        vm.getAllUsers()
        vm.getRecentMessagges()
    }

	var body: some View {
		NavigationView {
            Text(vm.errorMessage)
                .foregroundColor(Color.red)
            ScrollView {
                    ForEach(vm.recentMessages, id:\.self) { recentMessage in
                        let uid = recentMessage.toId
                        let user = vm.usersDictionary[uid]

                        NavigationLink(destination: ChatView(chatUser: user!)) {
                            HistoryCell(contact: user!, recentMessage: recentMessage)
                        }
                    }
//                    if UIDevice.current.userInterfaceIdiom == .pad {
//                        ForEach(vm.users, id:\.self) { contact in
//                            NavigationLink(destination: ChatView(chatUser: contact)) {
//                                ContactCell(contact: contact)
//                            }
//                        }
//                    } else {
//                        ForEach(vm.users, id:\.self) { contact in
//                            Button {
//                                vm.currentUser = contact
//                                vm.isShowChat = true
//                                print("Button Pressed for: \(String(describing: vm.currentUser?.name))")
//                            } label: {
//                                ContactCell(contact: contact)
//                            }
//                        }
//                    }
                    //			if $vm.contacts != [] {
                    //				Grid(contacts!) { contact in
                    //					 Text("Count: \(contacts.count)")
                    //					NavigationLink(destination: ChatView(contact: contact)) {
                    //						ContactsView(contact: contact)
                    //					}
                    //				}
                    //			}
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
