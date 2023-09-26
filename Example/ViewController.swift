import UIKit
import Courier_iOS
    
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
                            
            // Make sure your user is signed into Courier
            // This allows Courier to sync push notification tokens automatically
            try await Courier.shared.signIn(
                accessToken: "<YOUR_API_KEY>",
                clientKey: "nil",
                userId: "<COURIER_USER_ID>"
            )

            // Shows a popup where your user can allow or deny push notifications
            // You should put this in a place that makes sense for your app
            // You cannot ask the user for push notification permissions again
            // if they deny, you will have to get them to open their device settings to change this
            let status = try await Courier.requestNotificationPermission()

        }
        
       
    }
    
    @IBAction func clickAction(_ sender: Any) {
            Task {
            
                let firebaseChannel = FirebaseCloudMessagingChannel(
                    fcmData: [
                        "FCM_CUSTOM_KEY": "YOUR_CUSTOM_VALUE",
                    ],
                    aps: [
                        "sound": "ping.aiff",
                        "badge": 123,
                        "APNS_CUSTOM_NUMBER": 456,
                        "APNS_CUSTOM_BOOLEAN": true,
                        "APNS_CUSTOM_KEY": "YOUR_CUSTOM_VALUE"
                    ]
                )


                try await Courier.shared.sendMessage(
                    authKey: "<YOUR_API_KEY>",
                    userIds: ["<COURIER_USER_ID>"],
                    title: "This is a Firebase notification",
                    body: "Text of the Firebase notification",
                    channels: [firebaseChannel]
                )
            }
    }
    
}

