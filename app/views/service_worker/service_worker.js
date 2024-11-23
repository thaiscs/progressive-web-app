// Workbox library
importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/6.4.1/workbox-sw.js"
);

workbox.routing.registerRoute(
  ({ url }) => url.pathname.startsWith('/search/forecasts'),
  new workbox.strategies.NetworkFirst({
    cacheName: 'dynamic-pages',
    plugins: [
      new workbox.expiration.ExpirationPlugin({
        maxEntries: 50,
        maxAgeSeconds: 7 * 24 * 60 * 60, // Cache for 7 days.
      }),
    ],
  })
);

function onInstall(event) {
  console.log('[Serviceworker]', "Installing!", event);
}

function onActivate(event) {
  console.log('[Serviceworker]', "Activating!", event);
}

function onFetch(event) {
  console.log('[Serviceworker]', "Fetching!", event);
  console.log("self?", self)
}
self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);