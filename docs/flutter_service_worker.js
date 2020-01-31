'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "bb95faa24c2f921a737b29cd9e73e4f4",
"/main.dart.js": "eaa63a12059204c5d7e29d4c1aba7d82",
"/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"/manifest.json": "7c344858a4f2447422dc21ec5f14461a",
"/assets/LICENSE": "cabb5bbf6a524029b5c699675d07167d",
"/assets/CHANGELOG.md": "d64673e486ad45d9c9224c1f28799a77",
"/assets/AssetManifest.json": "b824ceeef8f81e274d5ac28856d9414f",
"/assets/FontManifest.json": "f7161631e25fbd47f3180eae84053a51",
"/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/assets/images/login_contact.png": "d5889853bb80e0bfec003ea8546ef433"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
