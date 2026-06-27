# 使用指南

## 1. 本机启动

Windows：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-upstream.ps1
docker compose up -d --build
```

macOS / Linux：

```bash
chmod +x scripts/setup-upstream.sh
./scripts/setup-upstream.sh
docker compose up -d --build
```

启动后打开：

```text
http://localhost:9000
```

如果修改了 `.env` 的 `APP_PORT`，访问对应端口。

## 2. 首次登录前必须修改

编辑 `.env`：

```text
ADMIN_USERNAME=admin
ADMIN_PASSWORD=你的强密码
JWT_SECRET_KEY=一串足够长的随机字符串
```

修改后重启：

```bash
docker compose down
docker compose up -d
```

## 3. 建议配置顺序

### 第一步：只开关键词回复

保持：

```text
AUTO_REPLY_ENABLED=true
AI_REPLY_ENABLED=false
AUTO_DELIVERY_ENABLED=false
```

先配置常见问题关键词，例如：

| 买家问题 | 建议回复 |
| --- | --- |
| 还在吗 | 在的，可以直接拍。 |
| 包邮吗 | 默认按商品页说明，部分地区可能需要补运费。 |
| 什么时候发 | 正常付款后尽快处理，具体以商品说明为准。 |
| 可以便宜吗 | 价格已经尽量低了，诚心要可以小幅优惠。 |

### 第二步：再开 AI 回复

确认关键词回复稳定后，再开启：

```text
AI_REPLY_ENABLED=true
```

AI 建议只做兜底，不要让它承诺退款、赔偿、站外交易或无法确认的服务。

### 第三步：最后开自动发货

自动发货建议只用于低风险虚拟商品，例如资料链接、卡密、教程文本等。

开启前先配置好：

- 商品匹配规则
- 发货内容
- 发货延迟
- 防重复规则
- 发货日志和通知

确认后再开启：

```text
AUTO_DELIVERY_ENABLED=true
```

## 4. 日常维护命令

```bash
# 查看服务状态
docker compose ps

# 查看实时日志
docker compose logs -f

# 重启
docker compose restart

# 停止
docker compose down

# 重新构建
docker compose up -d --build
```

## 5. 更新上游代码

Windows：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-upstream.ps1
docker compose up -d --build
```

macOS / Linux：

```bash
./scripts/setup-upstream.sh
docker compose up -d --build
```

## 6. 远程访问建议

默认只允许本机访问：

```text
127.0.0.1:9000
```

如果确实要远程访问，优先使用：

- Tailscale
- ZeroTier
- Cloudflare Tunnel

不建议直接用路由器端口转发把后台暴露到公网。
