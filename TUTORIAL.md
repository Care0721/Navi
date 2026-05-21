# Galgame Station - 完整部署与优化教程

## 📁 完整文件结构

```
your-repo/
├── .editorconfig              # 编辑器统一配置
├── .gitignore                 # Git忽略规则
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions自动部署
├── .nojekyll                  # 禁用Jekyll处理
├── 404.html                   # 自定义404错误页
├── _config.yml                # Jekyll配置
├── _headers                   # HTTP响应头（缓存/安全/预连接）
├── humans.txt                 # 项目信息
├── index.html                 # 主入口文件
├── manifest.json              # PWA配置（可安装到桌面）
├── optimize.sh                # 一键优化脚本
├── robots.txt                 # 搜索引擎爬虫配置
├── security.txt               # 安全策略声明
├── sw.js                      # Service Worker（CDN资源缓存）
└── README.md                  # 项目说明
```

---

## 📖 每个文件的作用详解

### 1. `.nojekyll` - 禁用Jekyll处理
```
作用：告诉GitHub Pages不要用Jekyll处理文件
效果：部署速度更快，不会出现文件被忽略的问题
```
**为什么需要**：GitHub Pages默认会用Jekyll处理所有文件，某些以下划线开头的文件可能被忽略。有了这个文件，所有文件原样部署。

---

### 2. `manifest.json` - PWA配置
```
作用：让网站可以"安装"到手机桌面
效果：像App一样打开，没有浏览器地址栏，加载更快
```
**使用方法**：
1. 用手机浏览器打开网站
2. 点击"添加到主屏幕"（iOS Safari点分享按钮 → 添加到主屏幕）
3. 桌面会出现App图标，点击直接打开

**配置项说明**：
```json
{
  "name": "Galgame Station",        // 完整名称
  "short_name": "GalStation",       // 短名称（桌面图标下方）
  "start_url": "/index.html",       // 启动页面
  "display": "standalone",          // 显示模式（standalone=全屏App）
  "background_color": "#1a1a2e",   // 启动画面背景色
  "theme_color": "#6366f1",        // 主题色（影响状态栏颜色）
  "icons": [...]                    // 应用图标
}
```

---

### 3. `sw.js` - Service Worker（最影响性能的文件）
```
作用：在浏览器后台运行，缓存外部资源
效果：二次访问时，Tailwind CSS、Font Awesome等直接从本地加载
```
**工作原理**：
```
首次访问：
  浏览器 → 下载Tailwind CSS → 渲染页面 → Service Worker缓存CSS到本地

二次访问：
  浏览器 → 从本地缓存读取CSS → 瞬间渲染页面（零网络延迟）
```

**缓存策略**：
- CDN资源（cdn.*、cdnjs.*等）：缓存优先，后台静默更新
- 图片资源（.png/.jpg/.webp等）：缓存优先
- HTML文件：始终从网络获取（保证内容最新）

---

### 4. `_headers` - HTTP响应头配置
```
作用：控制浏览器如何缓存和加载资源
效果：减少重复请求，加快页面加载
```
**关键配置说明**：
```http
# 预连接 - 提前和CDN服务器建立连接
Link: <https://cdn.tailwindcss.com>; rel=preconnect
```
这个配置让浏览器在解析HTML的同时就开始和CDN服务器建立TCP连接，等真正需要加载CSS时连接已经就绪，省去几百毫秒。

**缓存策略**：
| 文件类型 | 缓存时间 | 原因 |
|---------|---------|------|
| HTML | 不缓存 | 每次都要获取最新内容 |
| CSS/JS | 1年 | 文件名不变则内容不变 |
| 图片 | 1年 | 静态资源很少变化 |
| sw.js | 不缓存 | Service Worker需要及时更新 |

---

### 5. `robots.txt` - 搜索引擎配置
```
作用：告诉Google/Bing等搜索引擎如何抓取网站
效果：网站能被搜索引擎收录，用户能搜到你的网站
```
**配置说明**：
```
User-agent: *          # 所有搜索引擎
Allow: /               # 允许抓取所有页面
Disallow: /api/        # 禁止抓取API路径（如果有）
Crawl-delay: 1         # 每秒最多抓取1个页面
```

**提交到搜索引擎**：
1. Google: https://search.google.com/search-console → 添加资源 → 验证所有权
2. Bing: https://www.bing.com/webmasters → 添加站点

---

### 6. `.gitignore` - Git忽略规则
```
作用：防止不必要的文件被提交到仓库
效果：仓库更干净，推送更快
```
**忽略的文件**：
- `.DS_Store` - macOS系统文件
- `Thumbs.db` - Windows缩略图缓存
- `.vscode/` - VS Code编辑器配置
- `.env` - 环境变量（可能含API密钥）
- `node_modules/` - 依赖包

---

### 7. `.editorconfig` - 编辑器配置
```
作用：统一所有开发者的代码风格
效果：不管用什么编辑器，缩进、编码都一致
```
**配置说明**：
```ini
charset = utf-8           # 统一UTF-8编码
end_of_line = lf          # 统一换行符（不要混用CRLF和LF）
indent_style = space      # 用空格缩进（不用Tab）
indent_size = 4           # HTML/JS缩进4个空格
```

---

### 8. `404.html` - 自定义404页面
```
作用：用户访问不存在的页面时显示
效果：不会显示GitHub默认的丑陋404页面
```

---

### 9. `humans.txt` - 项目信息
```
作用：让访问者了解这个网站是谁做的
效果：增加网站的可信度和人情味
```
访问 `your-domain.com/humans.txt` 即可查看。

---

### 10. `security.txt` - 安全策略
```
作用：告诉安全研究者如何报告漏洞
效果：如果有人发现安全漏洞，知道怎么联系你
```
需要放在 `.well-known/security.txt` 路径下（GitHub Pages自动处理）。

---

### 11. `_config.yml` - Jekyll配置
```
作用：配置Jekyll构建行为
效果：排除不需要部署的文件
```

---

### 12. `deploy.yml` - GitHub Actions自动部署
```
作用：推送代码后自动部署到GitHub Pages
效果：不需要手动去Settings里点Deploy
```
**工作流程**：
```
推送代码到main分支
    ↓
GitHub Actions自动触发
    ↓
拉取代码 → 配置Pages → 上传文件 → 部署
    ↓
网站自动更新（约1-2分钟）
```

---

## 🚀 部署教程（从零开始）

### 第一步：创建GitHub仓库

1. 打开 https://github.com/new
2. 仓库名称：`galgame-station`（或任意名称）
3. 选择 **Public**（公开仓库才能用免费GitHub Pages）
4. 点击 **Create repository**

### 第二步：上传文件

```bash
# 克隆仓库
git clone https://github.com/你的用户名/galgame-station.git
cd galgame-station

# 复制所有文件到仓库目录
# （将index.html、sw.js、manifest.json等所有文件复制进来）

# 提交并推送
git add .
git commit -m "🎉 初始部署"
git push origin main
```

### 第三步：启用GitHub Pages

1. 打开仓库 → **Settings** → **Pages**
2. **Source** 选择 **GitHub Actions**（推荐）
3. 保存

> 如果选择Actions方式，推送代码后会自动部署，无需手动操作。

### 第四步：验证部署

1. 等待1-2分钟
2. 访问 `https://你的用户名.github.io/galgame-station/`
3. 如果有自定义域名，在Pages设置中填写

### 第五步：验证Service Worker

1. 打开网站
2. 按F12 → Application → Service Workers
3. 看到状态为"Activated and is running"即成功
4. 按F12 → Application → Cache Storage
5. 看到缓存的CDN资源即成功

### 第六步：提交搜索引擎

1. 打开 https://search.google.com/search-console
2. 添加资源 → 输入网站URL
3. 验证所有权（HTML标签方式最简单）
4. 提交站点地图

---

## ⚡ 性能优化效果

| 优化项 | 优化前 | 优化后 |
|-------|--------|--------|
| 首次加载 | ~3-5秒 | ~2-3秒（preconnect加速） |
| 二次加载 | ~3-5秒 | **~0.5秒**（SW缓存） |
| CSS加载 | 等网络请求 | **瞬间**（preload预加载） |
| 动画流畅度 | CSS加载后才流畅 | **立即流畅** |
| 图标显示 | 可能闪烁 | **无闪烁** |

---

## 🔧 自定义配置

### 修改网站图标
编辑 `manifest.json` 中的 `icons` 字段，替换为你的图标URL。

### 添加自定义域名
1. 在仓库根目录创建 `CNAME` 文件
2. 内容写你的域名：`gal.yourdomain.com`
3. 在域名DNS设置中添加CNAME记录指向 `你的用户名.github.io`

### 修改缓存策略
编辑 `_headers` 文件中的 `Cache-Control` 值。

### 添加Google Analytics
在 `index.html` 的 `<head>` 中添加：
```html
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
```

---

## 📝 注意事项

1. **GitHub Pages限制**：仓库大小不超过1GB，带宽每月100GB
2. **Service Worker更新**：修改 `sw.js` 后需要更新 `CACHE_NAME` 变量才能让用户获取新版本
3. **HTTPS**：GitHub Pages自动提供HTTPS，无需额外配置
4. **_headers文件**：只在Netlify上完全生效，GitHub Pages部分支持

---

**最后更新**: 2026-05-21
