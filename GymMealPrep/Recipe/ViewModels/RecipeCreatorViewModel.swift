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
        setProcessingState(to: true, withText: "Downloading the recipe")
        
        //TODO: ADD IMPLEMENTATION
        guard let _ = URL(string: recipeLink) else {
            showAlert("Cannot load the link", message: "The recipe link provided was not valid")
            return
        }
        self.webLinkLogicController.getData(for: recipeLink)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.showAlert("Error while downloading the recipe", message: "\(error.localizedDescription)")
                    self?.isProcessingData = false
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
        setProcessingState(to: true, withText: "Processing ingredients & instructions")
        guard !ingredientsEntry.isEmpty else {
            showAlert("Cannot create recipe", message: "The recipe cannot be created without ingredients! To proceed please add ingredients")
            return
        }
        parseIngredients(input: ingredientsEntry)
        parseInstructions(input: instructionsEntry)
        setProcessingState(to: false)
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
        setProcessingState(to: true, withText: "Scanning downloaded data")
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
        let parser = WebsiteRecipeParserEngine()
        setProcessingState(to: true, withText: "Getting ingredeints and instructions")
        do{
            let (scannedIngredients, scannedInstructions): (String, String) = try parser.scanForRecipeData(in: data)
            ingredientsEntry = scannedIngredients
            instructionsEntry = scannedInstructions

        } catch {
            showAlert("Cannot parse recipe from the link", message: "The retrived recipe failed to parse, please continue and enter the ingredients and instructions manually")
        }
        setProcessingState(to: false)
    }
    
    private func parseIngredients(input: String) {
        clearIngredientsParsedData()
        // process ingredients entry into array of natural language ingredients for use with edamam parser
        let ingredientParser = RecipeInputParserEngine()
        do {
            ingredientsNLArray = try ingredientParser.parseList(from: input)
        } catch ParserEngineError.emptyInput {
            showAlert("Failed to process ingredients input", message: "It appears that there is no text for ingredients in the recipe. Please add at least one ingredient!")
            return
        } catch {
            print(error)
        }
        retriveIngredientDataFromEdamam()
    }
    
    private func parseInstructions(input: String) {
        clearInstructionsParsedData()
        do {
            let parser = RecipeInputParserEngine()
            instructionsNLArray = try parser.parseList(from: instructionsEntry)
        } catch {
            print(error)
        }
        for (index, instructionText) in instructionsNLArray.enumerated() {
            let instructionToAppend = Instruction(step: index + 1, text: instructionText)
            parsedInstructions.append(instructionToAppend)
        }
        setProcessingState(to: false)
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
//MARK: LOADING VIEW
extension RecipeCreatorViewModel {
    func setProcessingState(to value: Bool, withText text: String? = nil) {
        isProcessingData = value
        processName = value ? (text ?? String()) : String()
    }
}

//MARK: ALERTS
extension RecipeCreatorViewModel {
    func showAlert(_ title: String, message: String) {
        setProcessingState(to: false)
        alertTitle = title
        alertMessage = message
        isShowingAlert = true
    }
}
