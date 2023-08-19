//
//  RecipeCreatorViewModel.swift
//  GymMealPrep
//
//  Created by Tomasz Kubiak on 5/27/23.
//

import Foundation
import Combine

class RecipeCreatorViewModel: RecipeCreatorViewModelProtocol {
    private var recipeImageData: Data?
    private var dataManager: DataManager
    private var imageSourcesRef: [String]?
    private var subscriptions = Set<AnyCancellable>()
    let networkController: NetworkController
    let edamamLogicController: EdamamLogicControllerProtocol
    let webLinkLogicController: WebLinkLogicController
    
    init(dataManager: DataManager = .shared) {
        self.dataManager = dataManager
        self.networkController = NetworkController()
        self.edamamLogicController = EdamamLogicController(networkController: networkController)
        self.webLinkLogicController = WebLinkLogicController(networkController: networkController)
        super.init()
        self.ingredientsNLArray = [String]()
        self.ingredientsEntry = String()
        self.instructionsEntry = String()
    }
    
    override func processLink() {
        //TODO: ADD IMPLEMENTATION
        guard let _ = URL(string: recipeLink) else {
            alertTitle = "Cannot load the link"
            alertMessage = "The recipe link provided was not valid"
            isShowingAlert.toggle()
            return
        }
        self.webLinkLogicController.getData(for: recipeLink)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.alertTitle = "Error while downloading the recipe"
                    self?.alertMessage = "\(error.localizedDescription)"
                    self?.isShowingAlert.toggle()
                    return
                case .finished:
                    print("Network request for data finished with success")
                }
            } receiveValue: { [weak self] data in
                self?.processDataFromLink(data: data)
            }
            .store(in: &subscriptions)
    }
    
    override func processInput() {
        // check if there is ingredient input, otherwise return
        guard !ingredientsEntry.isEmpty else {
            alertTitle = "Cannot create recipe"
            alertMessage = "The recipe cannot be created without ingredients! To proceed please add ingredients"
            isShowingAlert.toggle()
            return
        }
        parseIngredients(input: ingredientsEntry)
        parseInstructions(input: instructionsEntry)
    }
    
    override func saveRecipe() -> Recipe {
        
        var recipe = Recipe(
            name: recipeTitle,
            servings: servings,
            timeCookingInMinutes: Int(timeCookingInMinutes) ?? 0,
            timePreparingInMinutes: Int(timePreparingInMinutes) ?? 0,
            timeWaitingInMinutes: Int(timeWaitingInMinutes) ?? 0,
            ingredients: Array(matchedIngredients.values),
            instructions: parsedInstructions,
            tags: tags)
        if let recipeImageData {
            recipe.imageData = recipeImageData
        }
        
        dataManager.updateAndSave(recipe: recipe)
        return recipe
    }
    
    override func addTag() {
        tags.append(Tag(text: tagText))
        tagText = String()
    }
    //MARK: INGREDIENT FUNCTIONS
    override func addIngredient(_ ingredientToSave: Ingredient, _ key: String?) {
        if let key {
            matchedIngredients.updateValue(ingredientToSave, forKey: key)
        }
    }
    
    //MARK: INSTRUCTION FUNCTIONS
    override func deleteInstruction(at offset: IndexSet) {
        parsedInstructions.remove(atOffsets: offset)
    }
    
    override func moveInstruction(fromOffset source: IndexSet, toOffset destination: Int) {
        parsedInstructions.move(fromOffsets: source, toOffset: destination)
        for (index, instruction) in parsedInstructions.enumerated() {
            let targetInstruction = Instruction(id: instruction.id, step: index + 1, text: instruction.text)
            parsedInstructions[index] = targetInstruction
        }
    }
    
    override func addInstruction() {
        parsedInstructions.append(Instruction(step: parsedInstructions.count + 1))
    }
    
    //MARK: IMAGE FUNCTIONS
    override func addImageData(data: Data) {
        recipeImageData = data
    }
    
    override func deleteImageData() {
        recipeImageData = nil
    }
}

//MARK: Data processing functions
extension RecipeCreatorViewModel {
    
    private func processDataFromLink(data: Data) {
        //Parse recipe titile and image source links with swift soup
        do {
            let soupEngine = try WebsiteRecipeSoupEngine(documentData: data)
            if let titleString = try soupEngine.getTitle() {
                recipeTitle = titleString
            }
            if let imageSources = try soupEngine.getImageSourceLinks() {
                imageSourcesRef = imageSources
            }
        } catch WebsiteRecipeSoupEngineError.failedToCreateStringFromData {
            print("Error while creating a string from data")
        } catch {
            print("Error while parsing into document")
        }
        // Parse text from data for lists with ingredients and instructions
        do{
            let parser = try WebsiteRecipeParserEngine(source: data)
            let (scannedIngredients, scannedInstructions): (String, String) = parser.scanForRecipeData()
            ingredientsEntry = scannedIngredients
            instructionsEntry = scannedInstructions

        } catch {
            alertTitle = "Cannot parse recipe from the link"
            alertMessage = "The retrived recipe failed to parse, please continue and enter the ingredients and instructions manually"
            isShowingAlert.toggle()
        }
    }
    
    private func parseIngredients(input: String) {
        clearIngredientsParsedData()
        // process ingredients entry into array of natural language ingredients for use with edamam parser
        let ingredientParser = RecipeInputParserEngine(input: input)
        do {
            ingredientsNLArray = try ingredientParser.parseList()
        } catch {
            //show error and return
            print(error)
            return
        }
        retriveIngredientDataFromEdamam()
    }
    
    private func parseInstructions(input: String) {
        clearInstructionsParsedData()
        do {
            let parser = RecipeInputParserEngine(input: instructionsEntry)
            instructionsNLArray = try parser.parseList()
        } catch {
            print(error)
        }
        for (index, instructionText) in instructionsNLArray.enumerated() {
            let instructionToAppend = Instruction(step: index + 1, text: instructionText)
            parsedInstructions.append(instructionToAppend)
        }
    }
    
    /// Remove parsed ingredients data from previous calls
    private func clearIngredientsParsedData() {
        ingredientsNLArray = [String]()
        parsedIngredients = [String : [[Ingredient]]]()
        matchedIngredients = [String : Ingredient]()
    }
    
    /// Remove parsed instructions data from previous calls
    private func clearInstructionsParsedData() {
        instructionsNLArray = [String]()
        parsedInstructions = [Instruction]()
    }
    
    /// Get matching ingredients from Edamam API
    private func retriveIngredientDataFromEdamam() {
        
        for searchTerm in ingredientsNLArray {
            edamamLogicController.getIngredientsWithParsed(for: searchTerm)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("Completed edamam API request with success for \(searchTerm)")
                    case .failure(let error):
                        print("Error requesting response for \(searchTerm). Error: \(error) - \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] (data, parsed) in
                    guard let self else { return }
                    self.parsedIngredients.updateValue(data, forKey: searchTerm)
                    if let bestMatch = parsed {
                        self.matchedIngredients.updateValue(bestMatch, forKey: searchTerm)
                    }
                }
                .store(in: &subscriptions)
        }
    }
}
