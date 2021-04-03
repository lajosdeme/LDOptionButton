# LDOptionButton

Clean and beautiful menu option button written in Swift.

![scrn2](https://user-images.githubusercontent.com/44027725/113474138-521edd80-946e-11eb-90dc-86a3dd105b4e.gif)
![scrn1-min](https://user-images.githubusercontent.com/44027725/113474170-8c887a80-946e-11eb-9201-36040a7e246b.gif)



## Installation
Simply copy the ```LDOptionButton.swift``` file into your project.

Or if you use Cocoapods then add the following to your Podfile:  

    pod 'LDOptionButton'

Or if you use Carthage add the following to your Cartfile:  

    github "lajosdeme/LDOptionButton'

## Usage

### Programatically

```swift
//Create the configurations for the side buttons
let configs = [
    SideButtonConfig(backgroundColor: .blue, normalIcon: "settings"),
    SideButtonConfig(backgroundColor: .green, normalIcon: "info"),
    SideButtonConfig(backgroundColor: .red, normalIcon: "location")
]

//Create the button, set its properties and pass in configs
button = LDOptionButton(frame: CGRect(x: view.bounds.width - 100 , y: view.bounds.height - 130, width: 50, height: 50), 
                      normalIcon: "home", 
                      selectedIcon: "close", 
                      buttonsCount: 3, 
                      sideButtonConfigs: configs, 
                      duration: 0.2)

button.startAngle = 0
button.endAngle = 90
button.delegate = self

//Delegate methods
//Side button at the specified index will be selected
func optionButton(optionButton: LDOptionButton, willSelect button: UIButton, atIndex: Int)

//Side button at the specified index was selected
func optionButton(optionButton: LDOptionButton, didSelect button: UIButton, atIndex: Int)

//Option button was selected and the side buttons are displayed
func optionButton(didOpen options: LDOptionButton)

//Option button was closed and the side buttons are not displayed anymore
func optionButton(didClose options: LDOptionButton)
```

### Storyboard
1. Drag a ```UIButton``` onto the scene
2. Set its properties via the Attributes Inspector
3. Connect it to code
4. Add delegate methods, start using it

## Contributing
If you have any suggestions or questions feel free to raise an issue or reach out to me directly via <a href="mailto:lajosd@protonmail.ch">lajosd@protonmail.ch</a>.  
  
If you like this button you can thank me by buying me a coffee.  

<a href="https://www.buymeacoffee.com/edgz29w" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
