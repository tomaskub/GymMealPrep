//
//  MealPlanEditorView.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 6/24/23.
//

import SwiftUI

struct MealPlanEditorView: View {
    @State var draftMealPlan: MealPlan
    
    var body: some View {
        List {
            Text(draftMealPlan.name ?? "Meal plan")
        }
    }
}

struct MealPlanEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanEditorView(draftMealPlan: SampleData.sampleMealPlan)
    }
}
