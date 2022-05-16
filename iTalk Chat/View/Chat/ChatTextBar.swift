//
//  ChatTextBar.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 15/05/2022.
//

import SwiftUI

struct ChatTextBar: View {
    @ObservedObject var vmChat: ChatsVM
    private let buttonsSize: CGFloat = 24
    private let topPadding: CGFloat = 8
    @FocusState var focus: Bool
    
    init(vm: ChatsVM) {
        self.vmChat = vm
    }

    var body: some View {
//        Text(vm.errorMessage)
        HStack {
//            DescriptionPlaceholder()
            // TextField("", text: $vmChat.chatText)
            TextEditor(text: $vmChat.chatText)
                .focused($focus)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top)
                .opacity(vmChat.chatText.isEmpty ? 0.5 : 1)
                .foregroundColor(Color.accentColor)
                .border(.blue)
                .accessibilityLabel("Message")
                .onAppear {
                    focus = true
                }
                .onSubmit {
                    vmChat.handleSend(.text)
//                    vmChat.focus = false
                }
                .submitLabel(.send)
            Button {
                vmChat.handleSend(.text)
//                vmChat.focus = false
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(Color.blue)
            }
            .font(.system(size: buttonsSize))
            .padding(.horizontal)
            .padding(.vertical, topPadding)
        }
        .padding()
    }
}
