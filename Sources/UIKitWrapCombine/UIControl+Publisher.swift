//
//  UIControl+Publisher.swift
//  UIKitWrapCombine
//
//  Created by 疋田 将一 on 2020/04/19.
//  Copyright © 2020 充実工房. All rights reserved.
//

import UIKit
import Combine

extension UIControl {
    final class Subscription<S: Subscriber, Control: UIControl, Value>: Combine.Subscription where S.Input == Value {
        private var subscriber: S?
        private weak var control: Control?
        let keyPath: KeyPath<Control, Value>

        fileprivate init(subscriber: S, control: Control, event: UIControl.Event, keyPath: KeyPath<Control, Value>) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            control.addTarget(self, action: #selector(handleControlEvent), for: event)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            subscriber = nil
        }

        @objc
        private func handleControlEvent() {
            guard let control = control else { return }
            _ = subscriber?.receive(control[keyPath: keyPath])
        }
    }

    struct Publisher<Control: UIControl, Value>: Combine.Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        private let control: Control
        private let controlEvents: UIControl.Event
        private let keyPath: KeyPath<Control, Value>

        fileprivate init(control: Control, keyPath: KeyPath<Control, Value>, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
            self.keyPath = keyPath
        }

        public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control, event: controlEvents, keyPath: keyPath)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIControl: WrapCombineCompatible {}

extension WrapCombine.Wrapper where Base: UIControl {
    public func publisher<Value>(for keyPath: KeyPath<Base, Value>, events: UIControl.Event) -> AnyPublisher<Value, Never> {
        return UIControl.Publisher(control: base, keyPath: keyPath, events: events)
            .eraseToAnyPublisher()
    }
    public func publisher(events: UIControl.Event) -> AnyPublisher<Void, Never> {
        return UIControl.Publisher(control: base, keyPath: \UIControl.tag, events: events)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

extension UIControl.Event {
    public static var defaultValueEvents: UIControl.Event {
        return [.allEditingEvents, .valueChanged]
    }
}
