importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyC3zvucAw0eONF6kaxUCDY-jFnYYV7yc2k",
      authDomain: "mountainmarketec.firebaseapp.com",
      projectId: "mountainmarketec",
      storageBucket: "mountainmarketec.appspot.com",
      messagingSenderId: "885444187774",
      appId: "1:885444187774:web:2faeaaadf594e5a4ebea2f",
      measurementId: "G-QZDXTS9ZLL",
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