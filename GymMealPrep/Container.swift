//
//  Container.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 26/10/2023.
//

import Foundation

fileprivate enum ContainerType {
    case production, test, preview
}

class Container: ObservableObject {
    private(set) var settingStore: SettingStore = .init() // no protocol avaliable
    private(set) var dataManager: DataManager = .shared // no protocol avaliable
    private(set) var networkController: NetworkController // network protocol
    
    fileprivate init(type: ContainerType) {
        switch type {
        case .production:
            self.settingStore = SettingStore()
            self.dataManager = DataManager.shared
            self.networkController = NetworkController()
        case .test:
            self.dataManager = DataManager.testing
            //TODO: IMPLEMET TESTING ENVIRONMENT SETTING STORE AND NETWORK CONTROLLER
            self.settingStore = SettingStore()
            self.networkController = NetworkController()
        case .preview:
            self.dataManager = .preview
            self.settingStore = SettingStore()
            self.networkController = NetworkController()
        }
    }
    
    
}

struct ContainerFactory {
    static func build() -> Container {
        if ProcessInfo.processInfo.environment[K.previewEnvironmentFlagKey] == "1" {
            return Container(type: .preview)
        } else if CommandLine.arguments.contains(K.testingFlag){
            return Container(type: .test)
        } else {
            return Container(type: .production)
        }
    }
}
