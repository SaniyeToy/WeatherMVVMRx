//
//  CityListViewModelImpl.swift
//  WeatherRx
//
//  Created by MacOS on 1.03.2022.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator
import Action


class CityListViewModelImpl: CityListViewModel, CityListViewModelInput, CityListViewModelOutput, CityListViewModelStoredProperties {
    
    private(set) lazy var selectedCity = selectedCityActions.inputs
    
    let disposeBag = DisposeBag()
    
    // MARK: -Inputs-
    
    
    // MARK: -Actions-
    
    lazy var selectedCityActions = Action<CityListResponse, Void> { [unowned self] city in
        self.router.rx.trigger(.cityDetails(city: city))
    }
    
    // MARK: -Outputs-
    var cityListResponse = PublishSubject<[CityListResponse]>()
    var cityList = PublishSubject<[CityListResponse]>()
    
    // MARK: -Stored properties-
    
    var cityListUseCase = CityListUseCase()
    private let router: UnownedRouter<AppRoute>
    // MARK: -Initialization-
    
    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
    
    func fetchCityList(params: [String: Any] ) {
        
        cityListUseCase.getCityList(params: params).subscribe(onNext: { [self] response in
            self.cityList.onNext(response)
        }).disposed(by: disposeBag)
    }
    
    func navigateToFavorites()  {
        router.trigger(.favoriteList)
    }
}
