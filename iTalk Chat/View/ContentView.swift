//
//  MainView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vmLogin = LogInSignInVM()
    @ObservedObject private var vmContacts = ContactsVM()
    //    @ObservedObject private var vmChats = ChatsVM(chatUser: nil)
//    @State var isUserLoggedOut = false
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
            iTalkView()
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("iTalk")
                    }
            }
            .tag(0)
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
        .fullScreenCover(isPresented: $vmLogin.isUserLoggedOut) {
            LogInView(didCompleateLoginProcess: {
                self.vmLogin.isUserLoggedOut = false
                self.vmLogin.getCurrentUser()
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
