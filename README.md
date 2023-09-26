# CourierFCMExample

This is a basic Swift/Storyboard app that can send push notifications to iOS devices using Courier iOS and Firebase FCM

## How to Use
 
In ViewController, replace accessToken and authKey with the same value - your Courier API key. Get this from Settings > API keys in the Courier console. Also replace any user Ids with your own COurier user ID for testing purposes.

You'll need to configure Firebase and APNs in your Apple Developer account before this will work. This code sits alongside a Courier blog post that explains how to do this.

Connect a physical iOS device to your computer, build the code and run it on the device.
