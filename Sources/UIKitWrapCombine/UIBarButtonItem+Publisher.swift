//
//  UIBarButtonItem+Publisher.swift
//  UIKitWrapCombine
//
//  Created by 疋田 将一 on 2020/07/16.
//  Copyright © 2020 充実工房. All rights reserved.
//

import UIKit
import Combine

extension UIBarButtonItem {
    final class Subscription<S: Subscriber, Control: UIBarButtonItem>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        private weak var control: Control?
        
        fileprivate init(subscriber: S, control: Control) {
            self.subscriber = subscriber
            self.control = control
            control.target = self
            control.action = #selector(handleControlEvent)
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {
            subscriber = nil
        }
        
        @objc
        private func handleControlEvent() {
            _ = subscriber?.receive(())
        }
    }
    
    struct Publisher<Control: UIBarButtonItem>: Combine.Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        private let control: Control
        
        fileprivate init(control: Control) {
            self.control = control
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(subscriber: subscriber, control: control)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension UIBarButtonItem: WrapCombineCompatible {}

extension WrapCombine.Wrapper where Base: UIBarButtonItem {
    func publisher() -> AnyPublisher<Void, Never> {
        return UIBarButtonItem.Publisher(control: base)
            .eraseToAnyPublisher()
    }
}
