importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
<<<<<<< HEAD
    apiKey: "AIzaSyC3zvucAw0eONF6kaxUCDY-jFnYYV7yc2k",
      authDomain: "mountainmarketec.firebaseapp.com",
      projectId: "mountainmarketec",
      storageBucket: "mountainmarketec.appspot.com",
      messagingSenderId: "885444187774",
      appId: "1:885444187774:web:2faeaaadf594e5a4ebea2f",
      measurementId: "G-QZDXTS9ZLL",
=======
    apiKey: "AIzaSyDH4Y9rnt-Ui5FGTT5G1ivY2tlNFc9jrAo",
      authDomain: "emarket-e420c.firebaseapp.com",
      projectId: "emarket-e420c",
      storageBucket: "emarket-e420c.appspot.com",
      messagingSenderId: "151590191214",
      appId: "1:151590191214:web:6d2f54d2dd45fc7aa5667f",
      measurementId: "G-RQ899NQVHN"
>>>>>>> 6c53e34d80390c8a7d59fed5efa8d67c686f3e0c
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});