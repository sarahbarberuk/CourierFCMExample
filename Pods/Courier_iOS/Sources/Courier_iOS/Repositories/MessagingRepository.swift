//
//  MessagingRepository.swift
//  
//
//  Created by https://github.com/mikemilla on 7/21/22.
//

import Foundation

internal class MessagingRepository: Repository {
    
    internal func send(authKey: String, userIds: [String], title: String, body: String, channels: [CourierChannel]) async throws -> String {
        
        let json = [
            
            "message": [
                "to": userIds.map { [ "user_id": $0 ] }, // Map all user ids,
                "content": [
                    "title": title,
                    "body": body,
                    "version": "2020-01-01",
                    "elements": channels.flatMap { $0.elements }.map { $0.toMap() } // Get the elements
                ],
                "data": channels.map { $0.data ?? [:] }.reduce(into: [:]) { result, data in
                    for (key, value) in data {
                        result[key] = value
                    }
                },
                "routing": [
                    "method": "all",
                    "channels": channels.map { $0.key } // Get the keys
                ],
                "providers": channels.reduce(into: [:]) { result, channel in
                    result[channel.key] = channel.toOverride() // Map the provider
                }
            ]
            
        ].toJson()
        
        let data = try await post(
            accessToken: authKey,
            url: "\(CourierUrl.baseRest)/send",
            body: json,
            validCodes: [200, 202]
        )
        
        do {
            
            let res = try JSONDecoder().decode(MessageResponse.self, from: data ?? Data())
            let messageId = res.requestId
            
            Courier.log("\nNew Courier message sent. View logs here:")
            Courier.log("https://app.courier.com/logs/messages?message=\(messageId)\n")
            
            return messageId
            
        } catch {
            Courier.log(error.friendlyMessage)
            throw CourierError.requestParsingError
        }

    }
    
}
