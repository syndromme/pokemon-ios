//
//  MainTabController.swift
//  pokemon-ios
//
//  Created by syndromme on 01/08/25.
//

import UIKit
import XLPagerTabStrip

class MainTab: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .orange
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = "Pokédex"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let dashboardController = DashboardController.init(nibName: "DashboardView", bundle: nil)
        let profileController = ProfileController.init(nibName: "ProfileView", bundle: nil)
        
        return [dashboardController, profileController]
    }
}
