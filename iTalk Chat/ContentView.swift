//
//  MainView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
//    @ObservedObject private var vmContacts = ContactsVM()
//    @ObservedObject private var vmChats = ChatsVM(chatUser: nil)
    @ObservedObject var vm = LogInSignInVM()
    
    var body: some View {
        Text("Connected")
        TabView(selection: $selection){
//            iTalkView()
//                .tabItem {
//                    VStack {
//                        Image(systemName: "bubble.left.and.bubble.right.fill")
//                        Text("iTalk")
//                    }
//            }
//            .tag(0)
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
            }
            .tag(1)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .tag(2)
        }
        .fullScreenCover(isPresented: $vm.isUserLoggedOut) {
            LogInView(isPresented: $vm.isUserLoggedOut)
//            print("isPresented: \( $vm.isUserLoggedOut)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
