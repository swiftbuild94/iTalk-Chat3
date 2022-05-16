//
//  HistoryCell.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/02/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HistoryCell: View {
	var recentMessage: RecentMessage
	let user: User
	let shadowRadius: CGFloat = 5
	let circleLineWidth: CGFloat = 1
	let imageSize: CGFloat  = 64
	let spacing: CGFloat = 4
	let contactSize: CGFloat = 16
	let ageOfMessageSize: CGFloat = 14
	let imagePadding: CGFloat = 8
	let contactSpacing: CGFloat = 16
	let cornerRadius: CGFloat = 50
	
	var body: some View {
		return
			VStack {
				HStack(spacing: contactSpacing) {
					if user.photo != nil {
						WebImage(url: URL(string: user.photo!))
							.resizable()
							.scaledToFill()
//							.resizable()
							.frame(width: imageSize, height: imageSize)
							.clipped()
							.cornerRadius(cornerRadius)
							.overlay(RoundedRectangle(cornerRadius: cornerRadius)
										.stroke(Color(.label), lineWidth: circleLineWidth)
							)
					}
					Spacer()
					VStack(alignment: .leading) {
						Text(user.name)
							.font(.system(size: contactSize))
							.foregroundColor(Color(.label))
							.multilineTextAlignment(.leading)
						Text(recentMessage.text)
							.font(.subheadline)
							.foregroundColor(.secondary)
							.multilineTextAlignment(.leading)
					}
					Spacer()
//					Text(recentMessage.timeAgo)
						.font(.system(size: ageOfMessageSize, weight: .semibold))
						.foregroundColor(Color(.label))
				}.padding(.horizontal)
				Divider()
					.padding(.vertical, imagePadding)
			}
	}
}
