//
//  LocalActivityMapper.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

enum LocalActivityMapper {
    static func map(_ item: LocalActivityContainer) -> ActivityContainer {
        .init(
            id: item.id,
            state: item.state,
            stateChangedAt: item.stateChangedAt,
            title: item.title,
            description: item.description,
            duration: item.duration,
            activity: item.activity.presentable
        )
    }
}

private extension LocalActivityContainer.Activity {
    var presentable: ActivityContainer.Activity {
        .init(screens: screens.map({ $0.presentable }))
    }
}

private extension LocalActivityContainer.Activity.Screen {
    var presentable: ActivityContainer.Activity.Screen {
        .init(
            id: id,
            type: type,
            question: question,
            multipleChoicesAllowed: multipleChoicesAllowed,
            choices: choices?.compactMap({ $0.presentable }),
            eyebrow: eyebrow,
            body: body,
            answers: answers?.compactMap({ $0.presentable }),
            correctAnswer: correctAnswer
        )
    }
}

private extension LocalActivityContainer.Activity.Screen.Answer {
    var presentable: ActivityContainer.Activity.Screen.Answer {
        .init(
            id: id,
            text: text
        )
    }
}

private extension LocalActivityContainer.Activity.Screen.Choice {
    var presentable: ActivityContainer.Activity.Screen.Choice {
        .init(
            id: id,
            text: text,
            emoji: emoji
        )
    }
}
