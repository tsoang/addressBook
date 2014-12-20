-------------------
Overall Approach: 
The objective is to write an address book application and pull random users from the server to display as a demo app. I modelled this app's UI and UX after the native iPhone Contacts app using native GUI components. 

Because the simplicity of this demo app, there's no need to use third-party libraries. I chose to use all native frameworks including the network connection. 

I used the Storyboard to create the user interface and created one view controller for each screen in the Storyboard. 

There's a AddressBookManager single to manage the address book retrieval and parsing of the data.



-------------------
Requirements:
1. The project is written Xcode 6.1.1. Please use 6.1.1 or newer to open the project. 
2. The source code is written in Objective-C
3. The app is configured to deploy on iOS 7.0 and newer. 
4. The app is a universal app for both iPhone and iPad. 
5. The app orientation is configured to up right portrait, landscape left, and landscape right. 
6. The app requires Internet connection to access randomuser.me to pull the address book contacts. 



-------------------
Running instruction: 
1. Go to the root folder and open “AddressBook.xcodeproj” in Xcode 6.1.1
2. Select a desire simulator from the menu at the top. 
3. Click the run button to run the app in the simulator. 



-------------------
Notes: 
1. Sometimes the server randomuser.me returns an error message sporadically. It’s not a problem from the address book application. 