//
//  Rx+Extensions.swift
//  SwiftWisdom
//
//  Created by Logan Wright on 3/31/16.
//  Copyright © 2016 Intrepid. All rights reserved.
//

import RxSwift
import RxCocoa

//swiftlint:disable static_operator

precedencegroup Binding {
    associativity: left
    higherThan: Disposing
    lowerThan: AssignmentPrecedence
}

precedencegroup Disposing {
    associativity: left
}

infix operator <-> : Binding
infix operator <- : Binding
infix operator >>> : Disposing

public func <- <T: ObserverType, O: ObservableType>(observer: T, observable: O) -> Disposable where T.E == O.E {
    return observable.observeOn(MainScheduler.instance).bind(to: observer)
}

public func <- <T: ObserverType, O: ObservableType>(observer: T, observable: O) -> Disposable where T.E == O.E? {
    return observable.observeOn(MainScheduler.instance).bind(to: observer)
}

public func <- <T: ObserverType, O>(observer: T, variable: Variable<O>) -> Disposable where T.E == O {
    return observer <- variable.asObservable()
}

public func <- <T: ObserverType, O>(observer: T, variable: Variable<O>) -> Disposable where T.E == O? {
    return observer <- variable.asObservable()
}

public func <- <T, O: ObservableType>(variable: Variable<T>, observable: O) -> Disposable where O.E == T {
    return observable.bind(to: variable)
}

public func <- <T>(observer: Variable<T>, observable: Variable<T>) -> Disposable {
    return observer <- observable.asObservable()
}

public func <- <T: ObserverType, O>(observer: T, behaviorRelay: BehaviorRelay<O>) -> Disposable where T.E == O {
    return observer <- behaviorRelay.asObservable()
}

public func <- <T: ObserverType, O>(observer: T, behaviorRelay: BehaviorRelay<O>) -> Disposable where T.E == O? {
    return observer <- behaviorRelay.asObservable()
}

public func <- <T, O: ObservableType>(behaviorRelay: BehaviorRelay<T>, observable: O) -> Disposable where O.E == T {
    return observable.bind(to: behaviorRelay)
}

public func <- <T>(observer: BehaviorRelay<T>, observable: BehaviorRelay<T>) -> Disposable {
    return observer <- observable.asObservable()
}

public func >>> (disposable: Disposable, disposeBag: DisposeBag) {
    disposeBag.insert(disposable)
}

public func >>> (disposable: Disposable, compositeDisposable: CompositeDisposable) {
    _ = compositeDisposable.insert(disposable)
}

//  Operators.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//  https://github.com/ReactiveX/RxSwift/blob/master/RxExample/RxExample/Operators.swift
public func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    let bindToUIDisposable = variable
        .asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(
            onNext: { next in
                variable.value = next
            },
            onCompleted: {
                bindToUIDisposable.dispose()
            }
    )

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

public func <-> <T>(property: ControlProperty<T>, behaviorRelay: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = behaviorRelay
        .asObservable()
        .bind(to: property)
    let bindToBehaviorRelay = property
        .subscribe(
            onNext: { next in
                behaviorRelay.accept(next)
        },
            onCompleted: {
                bindToUIDisposable.dispose()
        }
    )
    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}

extension ObservableType {
    /// This function just exists to enable use of the trailing closure.
    public func subscribeNext(_ on: @escaping (E) -> Swift.Void) -> Disposable {
        return subscribe(onNext: on)
    }
}
