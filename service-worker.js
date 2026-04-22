const CACHE_NAME = "hematyuk-v2";
const BASE_URL = self.registration.scope;

const urlsToCache = [
  `${BASE_URL}`,
  `${BASE_URL}index.html`,
  `${BASE_URL}offline.html`,
  `${BASE_URL}manifest.json`,
  `${BASE_URL}icons/icon-192x192-A.png`,
  `${BASE_URL}icons/icon-512x512-B.png`,
];

// ── INSTALL: cache semua aset utama ──────────────────────────
self.addEventListener("install", event => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
      .catch(err => console.error("Cache gagal dimuat:", err))
  );
});

// ── ACTIVATE: hapus cache lama ───────────────────────────────
self.addEventListener("activate", event => {
  event.waitUntil(
    (async () => {
      const keys = await caches.keys();
      await Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            console.log("Menghapus cache lama:", key);
            return caches.delete(key);
          }
        })
      );
      await self.clients.claim();
    })()
  );
});

// ── FETCH: cache-first untuk lokal, network-first untuk API ──
self.addEventListener("fetch", event => {
  const request = event.request;
  const url = new URL(request.url);

  if (url.protocol.startsWith("chrome-extension")) return;
  if (request.method !== "GET") return;

  if (url.origin === self.location.origin) {
    event.respondWith(
      caches.match(request).then(response => {
        return (
          response ||
          fetch(request)
            .then(networkRes => {
              // Simpan ke cache untuk akses berikutnya
              const clone = networkRes.clone();
              caches.open(CACHE_NAME).then(cache => cache.put(request, clone));
              return networkRes;
            })
            .catch(() => caches.match(`${BASE_URL}offline.html`))
        );
      })
    );
  } else {
    event.respondWith(
      fetch(request)
        .then(networkResponse => {
          const clone = networkResponse.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(request, clone));
          return networkResponse;
        })
        .catch(() => caches.match(request))
    );
  }
});

// ── BACKGROUND SYNC ──────────────────────────────────────────
self.addEventListener("sync", event => {
  console.log("[SW] Background sync triggered:", event.tag);
  if (event.tag === "sync-hematyuk-data") {
    event.waitUntil(
      (async () => {
        try {
          // Sinkronisasi data inventaris / transaksi saat online kembali
          console.log("[SW] Syncing HematYuk data...");
          const clients = await self.clients.matchAll();
          clients.forEach(client => {
            client.postMessage({ type: "SYNC_COMPLETE", tag: event.tag });
          });
        } catch (err) {
          console.error("[SW] Background sync gagal:", err);
        }
      })()
    );
  }
});

// ── PERIODIC BACKGROUND SYNC ─────────────────────────────────
self.addEventListener("periodicsync", event => {
  console.log("[SW] Periodic sync triggered:", event.tag);
  if (event.tag === "hematyuk-periodic-update") {
    event.waitUntil(
      (async () => {
        try {
          // Cek produk kadaluarsa & perbarui data secara berkala
          console.log("[SW] Running periodic update...");
          const clients = await self.clients.matchAll();
          clients.forEach(client => {
            client.postMessage({ type: "PERIODIC_UPDATE" });
          });
        } catch (err) {
          console.error("[SW] Periodic sync gagal:", err);
        }
      })()
    );
  }
});

// ── PUSH NOTIFICATIONS ───────────────────────────────────────
self.addEventListener("push", event => {
  let data = {
    title: "HematYuk!",
    body: "Ada pembaruan inventaris atau keuangan yang perlu diperhatikan.",
    icon: `${BASE_URL}icons/icon-192x192-A.png`,
    badge: `${BASE_URL}icons/icon-192x192-A.png`,
    tag: "hematyuk-notif",
    requireInteraction: false
  };

  if (event.data) {
    try {
      const payload = event.data.json();
      data = { ...data, ...payload };
    } catch (e) {
      data.body = event.data.text();
    }
  }

  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: data.icon,
      badge: data.badge,
      tag: data.tag,
      requireInteraction: data.requireInteraction,
      data: { url: BASE_URL }
    })
  );
});

// ── NOTIFICATION CLICK ───────────────────────────────────────
self.addEventListener("notificationclick", event => {
  event.notification.close();
  const targetUrl = event.notification.data?.url || BASE_URL;

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true }).then(windowClients => {
      for (const client of windowClients) {
        if (client.url === targetUrl && "focus" in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(targetUrl);
      }
    })
  );
});

// ── MESSAGE HANDLER ──────────────────────────────────────────
self.addEventListener("message", event => {
  if (event.data && event.data.type === "SKIP_WAITING") {
    self.skipWaiting();
  }
  if (event.data && event.data.type === "CACHE_URLS") {
    event.waitUntil(
      caches.open(CACHE_NAME).then(cache => cache.addAll(event.data.urls || []))
    );
  }
});
