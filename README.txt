-------------------
Overall Approach: 
The objective is to write an address book application and pull random users from the server to display as a demo app. I modelled this app's UI and UX after the native iPhone Contacts app using native GUI components. 

Because the simplicity of this demo app, there's no need to use third-party libraries. I chose to use all native frameworks including the network connection. 

I used the Storyboard to create the user interface and created one view controller for each screen in the Storyboard. 

There's a AddressBookManager single to manage the address book retrieval and parsing of the data.



-------------------
Features Completed: 
1. An initial pulled from random user.me to get random contacts to display. 
2. A table view of all the contacts
3. The contacts are sorted alphabetically with an index on the right hand side of the table view. 
4. A detailed view of any particular contact. 
5. A retry feature it encounters an error message while retrieving the users from the server. 
6. A universal app that works on both iPhone and iPad for both portrait and landscape orientation that resize properly. 



-------------------
Nice to have features:
1. Locally store the downloaded contacts (4 hr)
2. Edit contact info (1 hr)
3. Sort by last name (0.5 hr)
4. Search (2 hr)
5. Server control configuration parameters for the app such the number of contacts, contact server end point URL, etc. (2 hr)
6. Localization (0.5 hr)



-------------------
Features to make it more robust: 
1. Automatic retry upon connection error for up to a configurable number of times. 
2. Listen to the network connect when it couldn't connect to the Internet to reconnect automatically when the network is available. 



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
Running instruction for test cases:
1. Go to the root folder and open “AddressBook.xcodeproj” in Xcode 6.1.1
2. Select a desire simulator from the menu at the top. 
3. Click "Product -> Test" to run the app in the simulator. 
Note: Performance measuring tests always report failure on the first run and until a baseline value is set on a particular device configuration.



-------------------
Notes: 
1. Sometimes the server randomuser.me returns an error message sporadically. It’s not a problem from the address book application. 