# MobileUpGallery

## Project Description
MobileUpGallery is an iOS application for authorizing in the social network VK via OAuth, with the ability to view photos and videos from the `https://vk.com/mobileup_studio` group. Users can save photos, share them and watch videos via the built-in player.

## Project Decomposition
1. **Project Setup and Repository Configuration** – 1 hour
    - Create a new project in Xcode with a minimum iOS support of 15.0;
    - Initialize a Git repository and create the main branch;
    - Configure .gitignore;
    - Initialize a remote repository and connect it to the local repository;
    - Make all initial changes and perform the first commit.
  
2. **Adding OAuth Authorization Support** – 4 hours
    - Create an authorization screen with a "Вход через VK" button;
    - Set up WebView for authorization and access token retrieval;
    - Handle authorization results and store the token in KeyChain.

3. **Implementing Session Saving and Restoration** – 2 hours
    - Implement functionality for automatic login if the token is still valid;
    - Handle token expiration and redirect to the authorization screen.

4. **Implementing the "Photos" Screen** – 5 hours
    - Create a screen with a collection view to display photos;
    - Use VK API to fetch photos from `https://vk.com/mobileup_studio`;
    - Implement data loading, error handling, and display a loading indicator.

5. **Implementing the "Videos" Screen** – 5 hours
    - Create a screen with a collection view to display video thumbnails;
    - Use VK API to fetch videos from the group `https://vk.com/mobileup_studio`;
    - Implement data loading, error handling, and display a loading indicator.

6. **Viewing and Saving Photos** – 4 hours
    - Implement functionality to view photos in full screen;
    - Implement Zooming functionality;
    - Display the upload date of the photo in the header;
    - Implement a Share menu for photos, allowing users to save photos to the gallery or share them;
    - Handle successful photo saving.

7. **Viewing and Saving Videos** – 4 hours
    - Implement functionality to view videos in WebView;
    - Add the ability to open videos in full-screen mode and control playback;
    - Implement a Share menu for videos, allowing users to share the video link.

8. **Implementing Logout Functionality** – 1 hour
    - Add a "Logout" button on the main screen that clears saved user data and redirects to the authorization screen.

9. **Implementing Light and Dark Themes** – 2 hours
    - Ensure all screens and UI elements are correctly displayed in both light and dark themes.

10. **Error Handling and Alerts Display** – 3 hours
    - Implement error handling for all possible application errors (e.g., network errors, photo saving errors, authorization errors);
    - Add alerts for users when errors occur.

11. **Testing on Various Devices and iOS Versions** – 3 hours
    - Test the app on various iPhone models, including older ones (e.g., iPhone SE 1st generation) and newer ones (e.g., iPhone 15 Pro Max);
    - Ensure the app works correctly on all supported iOS versions;
    - Fix any bugs found during testing.
   
**Total estimated time: 36 hours**

## Libraries Used
- **KingFisher** - for image loading and caching
- **WebKit** - for working with WebView
- **KeyChainWrapper** - for storing data in KeyChain
- **ProgressHUD** - for displaying loading animations

## Project Architecture
The project is implemented using MVC (Model-View-Controller) architecture. UIKit is used for screen layout and navigation.

## Real Work vs. Time Estimates
#### Initial Estimate:

The project was initially estimated to take 36 hours, broken down into specific tasks as outlined in the project decomposition. This estimation aimed to cover the full development cycle, including setting up the project, implementing features, handling errors, and testing.

#### Actual Time Spent:
Upon completing the project, the actual time spent on each task was as follows:
- **Project Setup and Repository Configuration**: 1 hour (as estimated)
- **Adding OAuth Authorization Support**: 15 hours (11 hours over the estimate)
- **Implementing Session Saving and Restoration**: 1 hours (1 hour under the estimate)
- **Implementing the "Photos" Screen**: 3 hours (2 hours under the estimate)
- **Implementing the "Videos" Screen**: 1 hours (4 hours under the estimate)
- **Viewing and Saving Photos**: 4 hours (1 hour under the estimate)
- **Viewing and Saving Videos**: 1 hours (4 hours under the estimate)
- **Implementing Logout Functionality**: 1 hour (as estimated)
- **Implementing Light and Dark Themes**: 1 hour (1 hour under the estimate)
- **Error Handling and Alerts Display**: 10 hours (7 hours over the estimate)
- **Testing on Various Devices and iOS Versions**: 2 hours (1 hour under the estimate)

**Total actual time: 40 hours**

#### Analysis:
The project exceeded the initial time estimate by 4 hours. The primary factors contributing to the additional time included unexpected complexities in handling VK API responses, handling various possible error cases, and refactoring code for better separation of concerns. The OAuth implementation also required much more time than anticipated due to the recent changes in VK development policy.

## Potential Improvements
1. Codebase optimization and refactoring:
    - Further refactor the code to enhance modularity and reusability, potentially transitioning towards a more component-based architecture like MVP or MVVM.
    - Implement unit tests and UI tests to ensure better coverage and stability.

2. Advanced Libraries:
    - Integrate Alamofire for more efficient networking.
    - Integrate Core Data or Realm for more efficient data storage and retrieval.

3. User Experience:
    - Add custom loading animations via Core Animation or Lottie.
    - Add stub image or label to be shown on screen if there is no photo or video data avaliable.

## Conclusion
The MobileUpGallery project was successfully completed and now represents a feature-complete iOS app that meets the initial requirements. The time I spent working on the project provided me with valuable insights and experience in integrating external APIs, handling various error cases, writing generic functions, configuring app themes for both light and dark modes, and organizing and structuring my code. I believe that this project can serve as a foundation for the development of a more complex app with potential real-world implications. I’m grateful for the opportunity to work on this project.
