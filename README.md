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

## Project Architecture
The project is implemented using MVC (Model-View-Controller) architecture. UIKit is used for screen layout and navigation.
