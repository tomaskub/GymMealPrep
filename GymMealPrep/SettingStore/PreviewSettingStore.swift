//
//  PreviewSettingStore.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 31/10/2023.
//

import Foundation
///  PreviewSettingStore provides access and ability to modify user settings for the app. The use of this class is for previews. 
///
///  This class does not have presistent storage container and will not retain any changes between launch.
///  While there is no presisten storage, as long as the instance is not deinitialize it will retain values, which are open to modification.
///  Value for a given setting can be accessed by using an Setting enum instance as key to settings property dictionary and can be updated directly by updating the value in the settings dictionary.
class PreviewSettingStore: SettingStoreable {
    
    override init() {
        super.init()
        self.settings = provideDefaultSettingsDictionary()
    }
    
    /// Reset settings values of this instance to default defined by SettingStoreable.
    /// After calling this function the instance of store will be restored to it initial state.
    override func resetStore() {
        settings = provideDefaultSettingsDictionary()
    }
    
    /// Provide a dictionary of setting and default values for the setting
    private func provideDefaultSettingsDictionary() -> [Setting : Any?] {
        return Dictionary(uniqueKeysWithValues: Setting.allCases.map({( $0, SettingStoreable.provideDefaultValue(for: $0))}))
    }
    
}
