//
//  BaseViewModel.swift
//  CoreDataDemo
//
//

import Foundation
import RxSwift
import Action

enum LoadingState: Int {
    case notLoad
    case loading
    case finished
    case failed
    case noValid
}

protocol BaseViewModelInput {

}

protocol BaseViewModelOuput {
    var baseStateObservable: Observable<LoadingState> { get }
   
}

protocol BaseViewModelType {
    var baseInputs: BaseViewModelInput { get }
    var baseOutputs: BaseViewModelOuput { get }
}

class BaseViewModel: NSObject, BaseViewModelInput, BaseViewModelOuput, BaseViewModelType {
    var disposeBag = DisposeBag()

    // MARK: Inputs & Outputs
    var baseInputs: BaseViewModelInput { return self }
    var baseOutputs: BaseViewModelOuput { return self }
    
    // MARK: Input

    // MARK: Output
    let baseStateObservable: Observable<LoadingState>
   

    // MARK: Subscriber
    let baseStateProperty = BehaviorSubject<LoadingState>(value: .notLoad)
   

    // MARK: Init
    override init() {
        baseStateObservable = baseStateProperty.asObservable()
       
        super.init()
    }
    
    deinit {
        print("Deinit \(type(of: self))")
    }
}
