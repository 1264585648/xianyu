# xianyu-local-assistant

这是一个用于本机部署闲鱼自动回复与自动发货系统的包装仓库。核心运行代码来自上游开源项目 [GuDong2003/xianyu-auto-reply-fix](https://github.com/GuDong2003/xianyu-auto-reply-fix)，本仓库主要保存本机部署脚本、Docker Compose 配置、环境变量模板和使用说明。

> 仅建议用于自己的正常客服回复、订单记录和低风险虚拟商品交付。不要用于骚扰营销、批量采集、刷量、绕过平台风控或任何违法违规场景。Cookie、API Key、账号密码不要提交到 GitHub。

## 快速开始

### Windows

1. 安装 Git 和 Docker Desktop。
2. 克隆本仓库。

```powershell
git clone https://github.com/1264585648/xianyu.git
cd xianyu
```

3. 拉取上游项目并初始化本地目录。

```powershell
powershell -ExecutionPolicy Bypass -File scripts/setup-upstream.ps1
```

脚本会自动创建 `.env`，并生成随机 `ADMIN_PASSWORD` 和 `JWT_SECRET_KEY`。首次登录前可以打开 `.env` 查看或改成自己记得住的强密码。

4. 启动服务。

```powershell
docker compose up -d --build
```

5. 打开后台。

```text
http://localhost:9000
```

### macOS / Linux

```bash
git clone https://github.com/1264585648/xianyu.git
cd xianyu
chmod +x scripts/setup-upstream.sh
./scripts/setup-upstream.sh
docker compose up -d --build
```

访问地址：`http://localhost:9000`

## 常用命令

```bash
# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 重启服务
docker compose restart

# 更新上游项目
./scripts/setup-upstream.sh
# Windows 使用：powershell -ExecutionPolicy Bypass -File scripts/setup-upstream.ps1
```

## 默认安全策略

本仓库的默认配置偏保守：

- 后台端口只绑定本机 `127.0.0.1:9000`，避免直接暴露到公网。
- `AUTO_DELIVERY_ENABLED=false`，自动发货默认关闭。
- `AI_REPLY_ENABLED=false`，AI 回复默认关闭。
- `USER_REGISTRATION_ENABLED=false`，默认不开放注册。
- `vendor/`、`.env`、`data/`、`logs/`、`backups/` 均被 `.gitignore` 忽略。
- 初始化脚本会为本机 `.env` 自动生成随机管理员密码和 JWT 密钥。

配置好商品规则、发货内容和测试账号后，再按需打开 AI 回复或自动发货。

## 推荐上线顺序

1. 先只启用关键词回复。
2. 再启用 AI 回复兜底。
3. 小额、低风险商品开启自动发货。
4. 高金额订单、异常买家、重复下单继续人工确认。
5. 稳定后再考虑远程访问，优先使用 Tailscale、ZeroTier 或 Cloudflare Tunnel。

## 目录说明

```text
.
├── docker-compose.yml        # 本机 Docker Compose 包装配置
├── .env.example              # 环境变量模板
├── scripts/                  # 拉取/更新上游项目脚本
├── docs/                     # 使用和安全说明
├── vendor/                   # 上游项目代码，本地生成，不提交
├── data/                     # 数据库等运行数据，本地生成，不提交
├── logs/                     # 日志，本地生成，不提交
└── backups/                  # 备份，本地生成，不提交
```

## 重要提醒

- 不要把闲鱼 Cookie、API Key、账号密码提交到仓库。
- 不要把后台直接通过路由器端口转发暴露公网。
- 任何自动发货规则上线前，先用测试商品或低风险商品跑通。
- 上游项目采用 AGPL-3.0 协议，使用、修改、分发或对外提供服务时请遵守其协议要求。
