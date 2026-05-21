// Service Worker - 缓存关键外部资源，大幅提升动画流畅度
// 核心原理：外部CDN资源（Tailwind、Font Awesome等）首次加载后缓存到本地
// 后续访问直接从本地读取，零网络延迟，动画立刻生效

const CACHE_NAME = 'galgame-station-v2';
const CACHE_DURATION = 7 * 24 * 60 * 60 * 1000; // 7天

// 需要预缓存的关键资源（这些是影响动画流畅度的核心文件）
const PRECACHE_URLS = [
  // Tailwind CSS - 整个UI框架
  'https://cdn.tailwindcss.com',
  // Font Awesome - 所有图标
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css'
];

// 安装时预缓存关键资源
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[SW] 预缓存关键资源...');
      return cache.addAll(PRECACHE_URLS).catch(err => {
        console.warn('[SW] 部分资源预缓存失败:', err);
      });
    })
  );
  self.skipWaiting();
});

// 激活时清理旧缓存
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      );
    })
  );
  self.clients.claim();
});

// 拦截请求 - 缓存优先策略
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // 只缓存GET请求
  if (event.request.method !== 'GET') return;
  
  // 缓存CDN资源（CSS、JS、字体）
  if (url.hostname.includes('cdn.') || 
      url.hostname.includes('cdnjs.') ||
      url.hostname.includes('jsdelivr.') ||
      url.hostname.includes('googleapis.') ||
      url.hostname.includes('gstatic.') ||
      url.hostname.includes('unpkg.')) {
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((cached) => {
          if (cached) {
            // 后台静默更新缓存
            fetch(event.request).then((response) => {
              if (response && response.status === 200) {
                cache.put(event.request, response);
              }
            }).catch(() => {});
            return cached;
          }
          // 首次加载：网络请求 + 缓存
          return fetch(event.request).then((response) => {
            if (response && response.status === 200) {
              cache.put(event.request, response.clone());
            }
            return response;
          });
        });
      })
    );
    return;
  }
  
  // 缓存图片资源
  if (url.pathname.match(/\.(png|jpg|jpeg|gif|webp|svg|ico)$/i)) {
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((cached) => {
          if (cached) return cached;
          return fetch(event.request).then((response) => {
            if (response && response.status === 200) {
              cache.put(event.request, response.clone());
            }
            return response;
          });
        });
      })
    );
    return;
  }
});
