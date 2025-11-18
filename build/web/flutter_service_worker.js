'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "0f9059e88fc89b251f4f86d6ce5f8594",
"assets/AssetManifest.bin.json": "8898f7cc692e32a4cd23046268db703e",
"assets/AssetManifest.json": "84bb102f01a9c180420ca6a4d0955452",
"assets/assets/pngs/AppLogo.png": "6854c7cfa553fda29bb7387900ccad16",
"assets/assets/pngs/google.png": "584207091dea42c3f0c3bbd306c9f03f",
"assets/assets/pngs/icApple.png": "6ef590ffadad66591c648ecb12e849a9",
"assets/assets/pngs/imagebg.png": "bd58075c81bc8a9c16e45cc010d5ee5b",
"assets/assets/pngs/image_icon.png": "91c8d191f2a933cfb31761616eef84a2",
"assets/assets/pngs/logo.png": "ded472a945ea3368fe764226ed539a97",
"assets/assets/pngs/logo_auth.png": "4f01d73045b07d98e1df922aba07146e",
"assets/assets/pngs/person_img.png": "3c97d38925c33188e3ba1d71f2f0bf86",
"assets/assets/pngs/profile_img.png": "58c559c8e5ea53f5f2bf3ba90c67a0ad",
"assets/assets/pngs/user-icon-icon_1076610-59410.avif": "4b9d01bc9f4d159914656bdc5664bd80",
"assets/assets/svgs/add.svg": "53cc640bd2f5b80728abed67b0270ed9",
"assets/assets/svgs/back_arrow.svg": "a4d3f8f243829e6d4dbdea903ca9d752",
"assets/assets/svgs/bottombar/act_home_icon.svg": "5b3bb25fc04f553a8648ac106504586d",
"assets/assets/svgs/bottombar/act_notification_icon.svg": "7f3134710cad0069eb64b9b4e596fa19",
"assets/assets/svgs/bottombar/act_person_icon.svg": "f1e4cd4f59792561dcc12e307d131eec",
"assets/assets/svgs/bottombar/act_search_icon.svg": "43e5780153e6e01a19fbfc8f36860e7b",
"assets/assets/svgs/bottombar/inact_home_icon.svg": "81431fd1251315fe17bc2d9edcc4fc45",
"assets/assets/svgs/bottombar/inact_notification_icon.svg": "7cc8c901e797ea67b088327c8a1a4fcb",
"assets/assets/svgs/bottombar/inact_person_icon.svg": "12fd106cad71f3f3af71d69ea01b2016",
"assets/assets/svgs/bottombar/inact_search_icon.svg": "7bcb41cc5f633798ca50734f40a145b1",
"assets/assets/svgs/calendar.svg": "a7c79c3fd56a08b611328e703e3f9252",
"assets/assets/svgs/comment.svg": "c71adfc2e42274c06a1085e842068e4c",
"assets/assets/svgs/dashboard.svg": "6256b1e0010cbd2e1f411b5ec5e85a97",
"assets/assets/svgs/default_img.svg": "1d0c53162c67101b93acb68fe9361b1a",
"assets/assets/svgs/download.svg": "8f45f3653ed556283ea100d5fbd501f6",
"assets/assets/svgs/edit_icon.svg": "f5e569cb04fcd3f888035eedc643dcb6",
"assets/assets/svgs/icApple.svg": "fb99a1c5c172aa4a1182a2978ad0d6fc",
"assets/assets/svgs/icLike.svg": "d0414fc48a84090d55530bad774c4796",
"assets/assets/svgs/icLikeSelected.svg": "20cfcfa26c4246b9472c7c62ea64678a",
"assets/assets/svgs/light_comment.svg": "c2e0a8775af7628c171d84560c9d0878",
"assets/assets/svgs/light_dashboard.svg": "54e8b040eb78b73cfb67a56f8a26c51a",
"assets/assets/svgs/search.svg": "db58142a424e746fb64b23fbd9be15b9",
"assets/assets/svgs/send.svg": "81403bfbf5bcd41e86c82e0e4be377b9",
"assets/assets/svgs/settings.svg": "2309fcc35b34ad1bb9e075d99701886f",
"assets/assets/svgs/share.svg": "ba5e920907eee67f60fcb80b8dd91e0b",
"assets/FontManifest.json": "6956a7e54e044af3d1bf54556a251e4a",
"assets/fonts/MaterialIcons-Regular.otf": "b363e2b5a70b36f66294828ae52ef2c5",
"assets/fonts/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/fonts/Poppins-ExtraBold.ttf": "d45bdbc2d4a98c1ecb17821a1dbbd3a4",
"assets/fonts/Poppins-ExtraLight.ttf": "6f8391bbdaeaa540388796c858dfd8ca",
"assets/fonts/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/fonts/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/fonts/Poppins-Thin.ttf": "9ec263601ee3fcd71763941207c9ad0d",
"assets/NOTICES": "46d72038d680a84ff3b9d373514b1999",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "b1110d76b10c5edb906e6fb1fd3b6095",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9b00e5ed4586849d0ca18cd43ef69459",
"/": "9b00e5ed4586849d0ca18cd43ef69459",
"main.dart.js": "b3ea2e46b13229c330b7ef60bd6ce514",
"manifest.json": "2e7b539c992be48e806ec24644484e8c",
"vercel.json": "eb246d0f93676e8f9044aa528846d567",
"version.json": "8b179af208e82196776bd0c4a982fb62"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
