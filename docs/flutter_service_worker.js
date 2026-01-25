'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "03acefbc3fa51b5b96da4aa73983689b",
".git/config": "12b88b0ea0dc7563bac42322ab7eeecb",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "86b66ad8fc19cec2bb01dfbef55a1ee3",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "89645aa28dcc03b0c67e53a3a946b55e",
".git/logs/refs/heads/gh-pages": "d22a079e9de4281238cba0f257a2d962",
".git/logs/refs/heads/main": "da22c365678a8931744d0c374ccae578",
".git/logs/refs/remotes/origin/gh-pages": "a38b03619ef9f5492b50c0a4393f0e38",
".git/objects/06/059ae247b33fcf2428d481df98302587f9738b": "5db4006926b81d7a374feee9858f1dc9",
".git/objects/06/09c62f16d95747ace1cffe8bcf0e21dff9921a": "566f726e5199b62d8efc3347f4c3a68c",
".git/objects/08/27c17254fd3959af211aaf91a82d3b9a804c2f": "360dc8df65dabbf4e7f858711c46cc09",
".git/objects/0c/664dfb00882a6bbeb2b695bac30f9b0b2c7efb": "60a37ef98436672c0794bf6529ece761",
".git/objects/0d/4437a1bba0d744c84e31ee60a473afade90538": "526ac5889bdf7e9762ffa6d98e990f1f",
".git/objects/20/d75801effb4581bed074033cf69b8cf6c1f7fa": "f99694fdb4694609caae8717df617e05",
".git/objects/22/df09b32ca3226674644c018686067cca94772c": "f9771c8a27f82102ddd5f95e1308d74d",
".git/objects/28/2789b99721f1a1b19c0464e8c97c40856011c4": "c16abf076495033cb4cca8dac8fab7b2",
".git/objects/29/5a249624ac8c9d417773f5aa0bca9cbc6951f5": "981d52454264a969525188a6ee35ae33",
".git/objects/2a/f6ebcf508494e6c1533e7317df82dd36916257": "68d09cd283f39b9b2fdee59dbd3dc02d",
".git/objects/36/87ce18834e64ba3f6bfa782e5388a93e6e4371": "8057926352cee877e3fdfab5f1a229b5",
".git/objects/37/346800bab38339d1eba2e8e922544e9ca91b6b": "2b4801c52e7f5accfa63f60aba8532d1",
".git/objects/3a/8cda5335b4b2a108123194b84df133bac91b23": "1636ee51263ed072c69e4e3b8d14f339",
".git/objects/4a/619fcfab26d9b376de8a9e528c2b4ab525dffd": "cfbdd7cbfe87f6c529018e1dbce549ce",
".git/objects/50/921f051af55c76fefb013f8ed53d5988f7e4ad": "2f9b80d09bedc0a28826f9d4234fee38",
".git/objects/50/de41c8315c248a4b380111aeb4d8faa5ac5a40": "b8583ff2d9af57a0745d7845cf867d55",
".git/objects/51/03e757c71f2abfd2269054a790f775ec61ffa4": "d437b77e41df8fcc0c0e99f143adc093",
".git/objects/68/43fddc6aef172d5576ecce56160b1c73bc0f85": "2a91c358adf65703ab820ee54e7aff37",
".git/objects/6a/dfb43ad223aa12979a2ef6d5b4d574132bc351": "e2171b6f0e851dbd1962caf10e4fc0e6",
".git/objects/6f/7661bc79baa113f478e9a717e0c4959a3f3d27": "985be3a6935e9d31febd5205a9e04c4e",
".git/objects/72/95201dad953e6185f5cf6d17b11248af9feed4": "7e1bf54e73aaaba25c378b5df1d591d1",
".git/objects/7c/3463b788d022128d17b29072564326f1fd8819": "37fee507a59e935fc85169a822943ba2",
".git/objects/85/63aed2175379d2e75ec05ec0373a302730b6ad": "997f96db42b2dde7c208b10d023a5a8e",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8e/21753cdb204192a414b235db41da6a8446c8b4": "1e467e19cabb5d3d38b8fe200c37479e",
".git/objects/91/336e208b60c0e5352b4cc16eaa9c3e32cc569d": "c55d0fab31a0b0f4918e3d9727335339",
".git/objects/92/6a12a59e1e14b7f883534313a0fa9e0663c31e": "e376d064763ec3d3a9e33171357d7bbb",
".git/objects/93/b363f37b4951e6c5b9e1932ed169c9928b1e90": "c8d74fb3083c0dc39be8cff78a1d4dd5",
".git/objects/96/049cfff98f55077a244d8c5ed3e0512b4198f7": "b7976efede2047c1fdb13dd74705be91",
".git/objects/97/05c573be0e04ca32d4a3dc37dc8044abac3b7b": "45a329d1d228b41f92274fa1e32adcca",
".git/objects/9a/a1c21b6d21a3d6a7e5708cf8e75c518d94414a": "624bd3d1d2f757179ece0cd6c0005f25",
".git/objects/a3/38b819e95afebcacfdc60c7ba141488bb750f9": "bba29193f59058511e176177813e1766",
".git/objects/a4/88ee4d363728fa350e7f7ad411d24ef75f13f2": "e9f59306063353a2427911c3917b693b",
".git/objects/a7/3f4b23dde68ce5a05ce4c658ccd690c7f707ec": "ee275830276a88bac752feff80ed6470",
".git/objects/ad/ced61befd6b9d30829511317b07b72e66918a1": "37e7fcca73f0b6930673b256fac467ae",
".git/objects/b0/f0652f51a255494b13afc5c79a2ccf38914aeb": "41e6f68dccdb779b677d99df7f63f332",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/3e39bd49dfaf9e225bb598cd9644f833badd9a": "666b0d595ebbcc37f0c7b61220c18864",
".git/objects/b9/4fc3dd33c6ab2af8fcc3dc065c34b7ac54ead1": "b28724cb30069b8c5dd98aef5db1c4e3",
".git/objects/bb/32ffcb5af8136f2120398ce82e296617a8e90b": "f6d67639902af87968428b0e69d4bd81",
".git/objects/bb/7ee099ecf7d1a4da5cc1a655e7bf103fc834ea": "ec42bcc06f311c2b38d8b96a47aea8fe",
".git/objects/c5/56e43512554bd17657f5acd12c1209d47109d9": "99fe4e609e15d0985842e84063932d63",
".git/objects/c8/3af99da428c63c1f82efdcd11c8d5297bddb04": "144ef6d9a8ff9a753d6e3b9573d5242f",
".git/objects/c9/5ffb348d98d0cfb0805bfc07b042b0faed3766": "f80f1f55175f55bff099c48fa56b5521",
".git/objects/cc/63cb72d7a775eef6b4c77a117259aaebf6c176": "27160d3e1e614b4a9717abf593909f52",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d9/5b1d3499b3b3d3989fa2a461151ba2abd92a07": "a072a09ac2efe43c8d49b7356317e52e",
".git/objects/e1/683bd4b7f5a1ab04fceea6ca883001847ec427": "fb8bbb3c8ff63828327e71f060044fe2",
".git/objects/e4/462ed25850f74fd857b07656a78275917197e4": "05819a3621ac92fbca76d6225aaf0b7a",
".git/objects/e8/7834dd54a27a86ac633a3cf71fe57bda4a9ba6": "d965325df7d1b8135ceb7aee477527a2",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ec/0ecd6665aa3589aa36b3a3d5d7af06d413be55": "42016556763c798ca2beedafce767f3d",
".git/objects/f3/3e0726c3581f96c51f862cf61120af36599a32": "afcaefd94c5f13d3da610e0defa27e50",
".git/objects/f4/a260edb4c2cd4a2a1d17e2fe50e26820757691": "f7bd56b1e9c457e8dd7a65f60d0f0ee9",
".git/objects/f6/e6c75d6f1151eeb165a90f04b4d99effa41e83": "95ea83d65d44e4c524c6d51286406ac8",
".git/objects/fd/05cfbc927a4fedcbe4d6d4b62e2c1ed8918f26": "5675c69555d005a1a244cc8ba90a402c",
".git/refs/heads/gh-pages": "6b845e86ab41460e38e66e4264e55771",
".git/refs/heads/main": "49d152068ccbdd4366b16b64c8cabd93",
".git/refs/remotes/origin/gh-pages": "6b845e86ab41460e38e66e4264e55771",
"assets/AssetManifest.bin": "b970c7cd98cdeaa711bb1896310a847b",
"assets/AssetManifest.bin.json": "908087926ac0b83e29dd2e8530c91003",
"assets/assets/logo.png": "7c1a2a10e4121af824ed291ffb25d51a",
"assets/assets/logo_low.png": "569c7b262e0a21972d58a87279a6ccad",
"assets/FontManifest.json": "2a3f09429db12146b660976774660777",
"assets/fonts/MaterialIcons-Regular.otf": "2c22b386fd3365a289251c0eeee4efaf",
"assets/NOTICES": "28eada9add56c96ae69ec5208cccac51",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "ea01bcc2b804af6a87b98b9aaebba571",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "bcc99d1f8d8ff315f3453953f5a0636b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "7c1a2a10e4121af824ed291ffb25d51a",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "907da5abe7d5433fcc0a922d50a01c02",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "d654b2aae16a331a46f2ccfbf7ca39e7",
"/": "d654b2aae16a331a46f2ccfbf7ca39e7",
"main.dart.js": "bd9d350236ae1caae6cee375162149de",
"manifest.json": "e7d321ff2fa73458148158b298ae22e5",
"version.json": "2300c2fed646243a2782923c655ce72e"};
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
