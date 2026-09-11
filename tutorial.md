> **公开下载说明**：本页面下载的是公开包，包含 `cli`、`avg`、`voice`、`food` 四个 Profile。官方源中的内部 `text` Profile 和离线知识库不随公开包分发。以下教程保留官方文档原文，涉及内部 Profile 的内容仅供有权限的内部环境参考。

ipskill 是面向 Lumin 团队的 Codex Skill 官方发布包。团队通过 SVN 获取统一版本，再由 Codex 或根目录的 `install.cmd` 安装到本机；安装后可跨工程调用，同时将官方能力、个人经验和对话学习严格隔离。

<callout emoji="💡">
**先记住这四点：**普通成员使用 `consumer`；新机器优先运行 `install.cmd`；日常直接描述任务；真正安装、覆盖或同步必须由用户明确触发。
</callout>

# 一、安装

## 1. 安装前准备

1. 安装并登录 Codex。
2. 通过 SVN 将 ipskill 官方发布源拉取到本机任意目录。
3. 确认需要安装的 Profile。可以一次选择一个或多个。
4. 普通使用者统一选择 `consumer` 角色。
5. 部署飞书CLI，部署指南[飞书 CLI 能力介绍与最佳实践](https://open.feishu.cn/document/no_class/mcp-archive/feishu-cli-installation-guide.md)，指令（复制给AI）：帮我安装飞书 CLI：https://open.feishu.cn/document/no_class/mcp-archive/feishu-cli-installation-guide.md

## 2. 选择 Profile

| Profile | 业务 Skill 数 | 适用人群与用途 |
|-|-|-|
| `cli` | 28 | 飞书文档、表格、知识库、消息、日历、任务、会议、审批、应用开发、组合工作流，以及 Lumin Unity 统一控制路由。 |
| `avg` | 15 | Lumin AVG/Aside/NPC 配置、IP 组打表、当前编译器探测、Unity 控制路由、资源映射、源表分支增量同步，以及所需的飞书读取和文本安全能力。 |
| `voice` | 5 | Lumin 配音需求表生成、更新与审计，以及所需的飞书表格、文本安全和 Unity 控制路由。 |
| `food` | 1 | Windows 本机竹笋点餐页面定时提醒。独立于 `cli`、`avg` 和 `voice`，安装后只发布能力，不自动创建计划任务。 |

多个 Profile 会共享部分基础 Skill，因此数量不能直接相加。当前已验收的包版本为 `2.8.0`，共有 **41 个唯一业务 Skill**；每次安装还会附带 `ipskill-manager`，合计 **42 个 Skill**。当前共 5 个 Profile，其中 `food` 保持独立，不进入 `cli`、`avg` 或 `voice`。跨电脑实际可获得的版本始终以 SVN 中已经提交的内容为准。

## 3. 推荐：直接让 Codex 完成首次安装

把下面的话发给 Codex，并替换尖括号中的内容：

```text
请使用我刚拉取的 ipskill 官方发布源：<本机 SVN ipskill 目录>。
为我的本机 Codex 安装 <cli / avg / voice / food，可多选> profile，角色使用 consumer。
安装到本机 CODEX_HOME/skills，不要安装进当前工程。
同时建立我的个人 Skill 分区和全局隔离规范。
请先校验源包并预览；没有冲突后执行安装，最后运行 doctor 验证，并登记 SVN 来源用于以后检查更新。
```

Codex 会依次完成源包校验、安装预览、实际安装、环境检查和安装记录登记。若发现同名 Skill 或本地冲突，应先报告，不会静默覆盖。

## 4. 可移植安装命令（手动执行）

在 ipskill 官方发布源根目录中执行。首次运行先预览；只有增加 `-Apply` 才会写入。`install.cmd` 会处理新机器常见的 PowerShell 执行策略，并调用同目录的安装脚本。

```powershell
.\install.cmd -Profile avg
.\install.cmd -Profile avg -Apply

# 缺少正式 Python 3.9+ 时
.\install.cmd -Profile avg -InstallPython -Apply

# 按需准备 LuminWorkCLI Python 依赖
.\install.cmd -Profile avg -LuminProject "<Lumin工程>" -InstallLuminDependencies -Apply

# cli Profile 或画板渲染缺少 Node.js/npm/npx 时
.\install.cmd -Profile cli -InstallNode -Apply

# 只有需要直接读取飞书时才安装 lark-cli
.\install.cmd -Profile avg -InstallLarkCli -Apply
```

**竹笋点餐提醒（`food` Profile）**：先预览，确认后再安装。

```powershell
.\install.cmd -Profile food
.\install.cmd -Profile food -Apply
```

每台 Windows 电脑都需要分别安装 `food` Profile。安装只发布能力，不会自动创建或修改计划任务；只有用户在该电脑上明确提出创建或修改提醒后，Codex 才会配置本机任务。默认时间为周一至周五 `11:00`，使用 Windows 默认浏览器打开稳定点餐入口，不修改飞书功能，也不发送飞书消息。

安装器会从参数、环境变量、`py`、PATH 和正式 Python 常见目录中发现运行时，不依赖固定盘符、用户名或 Codex 缓存；Node.js/npm/npx 也会通过统一入口发现并校验成套运行时。`-InstallPython`、`-InstallNode`、`-InstallLuminDependencies`、`-InstallLarkCli` 与 `-Apply` 都是显式写入开关；需要组合多个 Profile 时，建议直接让 Codex 按前一节的话术执行。

## 5. 仅负责人：本机 maintainer 授权

**普通使用者不要执行本节。**默认角色永远是 `consumer`。只有负责维护官方发布源的人，才需要在自己的电脑上建立一次 maintainer 流程标记：

```powershell
.\install.cmd -Profile avg -Role maintainer -AuthorizeMaintainer
.\install.cmd -Profile avg -Role maintainer -AuthorizeMaintainer -Apply
```

该标记不保存账号、Token、密钥或 SVN 凭据。真正的 SVN 写权限仍由服务端 ACL 控制。

# 二、使用

## 1. 日常使用：直接描述目标

安装后无需记命令，也无需手动点名 Skill。直接告诉 Codex 你要完成什么；当任务与某个 Skill 匹配时，Codex 会读取对应流程并执行。

| 场景 | 示例说法 |
|-|-|
| 飞书 | “把这个飞书文档按安装、使用、原理和 Skill 清单重新整理。” |
| AVG | “把这个飞书台本生成传统 AVG，并校验当前项目的编译能力。” |
| NPC | “生成 NPC 模式对白，并把 NPC 的摆放、显隐、交互入口和任务依赖绑定到对应 AVG。” |
| 配音 | “根据这些台本生成 Lumin 配音需求表，并检查对白 ID 和角色分页。” |
| 点餐提醒 | “在这台电脑创建工作日 11:00 的竹笋点餐提醒；先预览配置，再安装计划任务。” |
| 更新管理 | “检查 ipskill 是否有更新。”或“同步更新 ipskill。” |

## 2. 检查更新

直接对 Codex 说“检查 ipskill 更新”。`ipskill-manager` 会从安装记录中自动读取 SVN 来源、已装 Profile、角色、安装 revision 和文件哈希，不需要每次重新提供路径。

检查是只读操作。结果会说明远端是否有新 revision、本机受管副本是否有冲突，以及当前安装状态是否正常。

## 3. 同步更新

只有明确说“同步、更新、升级、执行”时，Codex 才会真正应用更新。标准流程为：

1. 先预览待更新内容。
2. 检查官方受管副本是否偏离安装哈希。
3. 检查 SVN 工作副本是否干净。
4. 执行 `svn update`。
5. 校验新版官方包。
6. 仅替换内容有变化的已安装 Skill，并在替换前备份。
7. 更新本机安装记录。

命令等价于：

```powershell
python "<ipskill-manager 目录>/scripts/manage.py" status
python "<ipskill-manager 目录>/scripts/manage.py" sync
python "<ipskill-manager 目录>/scripts/manage.py" sync --apply
```

**跨电脑更新。**另一台电脑只执行 `svn update`，不会自动改写已经安装在 `CODEX_HOME/skills` 的旧 Skill；拉到新的已提交 revision 后，还要明确执行“同步 ipskill 更新”或 `sync --apply`。旧版 `ipskill-manager` 可以完成管理器自升级、变化项备份和已登记旧官方 Skill 的安全迁移；尚未提交到 SVN 的 maintainer 本地修改不会传播到其他电脑。

## 4. 周期检查

可以让 Codex 创建每周一次的更新检查。周期任务只运行只读的 `status`；只有发现更新、冲突或检查失败时才通知。周期任务不应自动执行 `sync --apply`。

## 5. 复杂 Skill 的能力预检

部分 AVG、NPC、配音或飞书任务依赖外部程序、登录态、工程资源或用户授权。执行前的预检结果分为：

| 状态 | 含义 |
|-|-|
| `READY` | 必需能力齐全，可以按标准流程执行。 |
| `LIMITED` | 部分能力缺失，但有明确、安全的降级方案；已有 AVG 目标尚未取得本次覆盖授权时，也会停在此状态。 |
| `BLOCKED` | 连降级模式也不可用，需要先补齐依赖。 |
| `UNSAFE` | 目标路径越出工程、触发硬性安全门禁或存在其他不可安全降级的问题，禁止写入。 |

# 三、注意事项和原理

## 1. 三个隔离分区

| 分区 | 典型位置 | 用途与修改边界 |
|-|-|-|
| 官方 SVN 工作副本 | `<SVN 拉取目录>/ipskill` | 官方发布源和更新源。consumer 只读；maintainer 也只有在用户明确要求维护官方源时才能修改。 |
| 官方受管副本 | `CODEX_HOME/skills` | 供 Codex 发现和运行官方 Skill。由安装器维护，不承接个人偏好、训练或对话学习。 |
| 个人 Skill 区 | `~/.agents/skills` | 存放个人沉淀，名称使用 `personal-<owner>-` 前缀，不参与官方更新、备份或覆盖。 |

## 2. 工作原理

首次安装会把所选 Profile 对应的 Skill 复制到本机 Codex 的全局 Skill 目录，同时写入安装记录和全局隔离规范。安装记录包含 SVN 来源、角色、个人分区、Profile、revision、已安装 Skill 及其哈希。

由于安装目标属于本机 Codex，而不是某个 Unity 工程，所以同一台电脑上的不同工程都可以发现这些 Skill。真正执行任务时，工程代码、Unity 资源、飞书账号与业务数据仍由当前环境提供。

在同时包含 `Assets/` 与 `Tools/LuminWorkCLI/luminworkcli.py` 的完整 Lumin 工程中，统一控制顺序为 **Editor MCP → Unity CLI/Pipeline → GUI**。项目内 Skill 可以补充工程约束，但不能反转该顺序；只要 Editor MCP 已可用且能力足够，缺少独立 `unity` 命令就不构成阻断。

## 3. consumer 与 maintainer 的边界

- `consumer`：使用官方受管副本，不修改官方 SVN 工作副本，也不修改官方受管副本。
- `maintainer`：运行和维护官方 Skill 时以源码工作副本为权威；修改只落在源码，校验后再同步受管副本。
- 无论哪种角色，普通对话中的“记住、学习、训练、以后这样做”都只能进入个人记忆或个人 Skill 区。
- 个人经验不能自动提升为官方规则。标准流程是：个人草稿 → 差异审计 → 负责人审核 → 官方源修改 → 校验 → 负责人手工提交 SVN。

## 4. 冲突、备份与覆盖

**Lumin 同名隔离。**官方 IP 组打表 Skill 使用唯一名称 `ipskill-lumin-table-build`，工程内面向整个项目的 `lumin-table-build` 保持不变，两者分层并存。旧官方副本只有在安装记录已登记且当前哈希匹配时才会先备份再退役；项目 Skill、个人 Skill、被修改的旧副本或未登记目录都不会被迁移删除。

- 安装和同步默认先预览；没有明确执行指令时不写入。
- 官方受管副本偏离上次安装哈希时，同步会停止，不会静默覆盖。
- SVN 工作副本存在本地修改或未版本化文件时，同步会停止。
- 需要替换内容不同的同名 Skill 时，应先列出冲突与备份方案，再由用户明确授权。
- 个人 Skill 不得与官方 Skill 同名覆盖。

## 5. 权限与安全边界

`maintainer-authorization.json` 只是本机流程角色标记，不是安全凭据。真正防止普通账号提交官方源，必须依靠 SVN 服务端 ACL：普通账号只读，负责人账号才有写权限。

安装记录和负责人标记不保存账号、Token、密钥或 SVN 凭据。任何能力预检参数都只能记录已确认的环境事实，不能绕过用户授权、安全确认或目标存在性检查。

## 6. 外部依赖并不会随 Skill 一起提供

Skill 描述的是工作流程和操作规则，不等于自动附带所有工具与数据。根目录 `install.cmd` 可以在显式开关下准备正式 Python、官方 Node.js/npm/npx、LuminWorkCLI Python 依赖和 `lark-cli`；飞书登录与业务权限、Lumin 工程、Unity Editor/MCP、资源表、台本和业务资源仍由使用者或目标工程提供。

## 7. 常见问题

| 问题 | 答案 |
|-|-|
| 每个工程都要重新安装吗？ | 不需要。默认安装到本机 Codex 的全局 Skill 目录，可跨工程使用。 |
| 可以同时安装多个 Profile 吗？ | 可以。重复的基础 Skill 会自动去重，建议直接让 Codex 组合安装。 |
| 新机器缺少 Python 或 lark-cli 怎么办？ | 从官方源根目录运行 `install.cmd`，按需增加 `-InstallPython`、`-InstallNode`、`-InstallLuminDependencies` 或 `-InstallLarkCli`。所有安装动作都必须显式增加对应开关与 `-Apply`。 |
| 已有 AVG 占位 asset/prefab 可以覆盖吗？ | 可以。先列出完整目标并取得本次授权，再使用 `--overwrite-existing`；当前生成器会保留 GUID，并在写入前备份 asset、prefab 和 `.meta`，失败时回滚。目录、越界路径或异常资源类型仍会被拦截。 |
| 正式 AVG 会生成到哪个目录？ | 必须按内容归属选择 `Assets/Res/Dialogue/AVG` 下已有的业务分类目录，并参考同章节、同剧情线及相邻 ID 的已落地资源；不能按播放模式机械分类，也不能把 `IPFlowGenerated` 当成正式交付目录。没有唯一匹配时，Codex 应列出候选依据，并先确认是否新建同级目录。 |
| NPC 模式由哪个 Skill 负责？ | `avg-config-expert` 负责 NPC 模式对白、`dialogueNPCAVG`、`dialogueStoryGroup` 及 AVG asset/prefab；`npc-config-expert` 负责 NPC 本体、摆放、显隐、交互入口、任务入口和全局注册。两者通过 story group、timeline 或 mission ID 做引用校验，不重复写入对方拥有的配置。 |
| 检查更新会改文件吗？ | 不会。检查是只读操作，真正同步必须明确触发。 |
| 个人训练会污染官方 Skill 吗？ | 不会。个人沉淀进入独立个人区，并使用专属名称前缀。 |
| 本机 maintainer 标记等于 SVN 写权限吗？ | 不等于。真正写权限由 SVN 服务端 ACL 决定。 |
| 发现同名或本地改动怎么办？ | 安装或同步会停止并报告冲突；确认备份与替换方案后再继续。 |

# 四、全部 Skill 分类与介绍

以下按能力分类列出当前已验收包的全部内容，共 **41 个唯一业务 Skill + 1 个管理 Skill**。同一个 Skill 即使被多个 Profile 引用，也只介绍一次；其他电脑实际可用清单以 SVN 已提交版本为准。

## A. 安装、治理与安全（3）

| Skill | 用途 |
|-|-|
| `ipskill-manager` | 安装、检查和同步 ipskill，管理 Profile、安装记录、冲突检查，并隔离官方 Skill 与个人 Skill。 |
| `lark-shared` | 处理 lark-cli 的安装检查、登录认证、身份选择、Scope 与权限问题，是其他飞书 Skill 的公共基础。 |
| `safe-text-transcoding` | 保护中文和混合文本在 PowerShell、文件及飞书 API 之间传递时不乱码，并提供写前检查与修复流程。 |

## B. Lumin 内容与工程（10）

| Skill | 用途 |
|-|-|
| `avg-config-expert` | 负责传统、现代、任务和 NPC 模式 AVG 的完整配置链路：把 IP 创意、飞书或 Excel 台本、任务对白及修改需求转成可校验的演出设计，更新源表、静态数据和 Unity AVG 资源。正式资源按内容归属写入现有业务分类目录，不使用 `IPFlowGenerated` 作为交付目录；分类不明确时先确认。 |
| `aside-config-expert` | 按实时命名空间规划、写入和验证 Lumin Aside 组表与句表，支持覆盖、删除、备份、原子回滚和精确回读。 |
| `npc-config-expert` | 负责 NPC 身份、摆放、显隐、交互入口、任务/AVG 绑定和全局注册；只处理 NPC 侧承载与联动，NPC 模式对白及 AVG asset/prefab 仍由 `avg-config-expert` 负责。 |
| `current-avg-compiler` | 以当前 Lumin 仓库中的 AVG direct generator 与 LuminWorkCLI 为实时权威，探测节点、版本和兼容性，并检查覆盖授权、GUID 保留与备份回滚能力。 |
| `ipskill-lumin-table-build` | 面向 IP 组处理本地临时打表、Unity 本地化写入、Jenkins 正式打表、Database 更新及相关验收；与工程内面向全项目的 `lumin-table-build` 分层并存。 |
| `sync-lumin-table-branches` | 在用户明确要求时，把指定源表变更按增量同步到另一数据分支；保留目标分支专属内容，不整表覆盖，也不自动提交 SVN。 |
| `lumin-unity-control-router` | 统一 Lumin Unity 操作路由：优先使用项目原生 Editor MCP，其次 Unity CLI/Pipeline，最后才使用 GUI。 |
| `dialogue-id-namer` | 根据文件名、章节信息和对白类型，生成符合项目规范的对话组 ID。 |
| `game-image-resource-id-mapper` | 按图素中文名或资源 path 实时查询当前 Lumin 图素配置 ID。 |
| `game-resource-id-mapper` | 按资源中文名、path 或配置 ID 实时查询当前 Lumin 背景、CG、Spine 演出图和互动图素。 |

## C. Lumin 配音（1）

| Skill | 用途 |
|-|-|
| `lumin-voice-demand-workbook` | 生成、更新和审计 Lumin 配音需求表，处理角色分页、对白与语音 ID、Aside、FMOD 等标准字段。 |

## D. 文档、知识与数据内容（9）

| Skill | 用途 |
|-|-|
| `green-dream-text-audit` | 在独立隔离工作区中，基于随包离线知识库核对绿梦世界观、玩家可见包装、术语、旧称、冲突与来源版本；默认只读，不处理 Unity、任务配置或一般飞书操作。 |
| `lark-doc` | 读取、创建和编辑飞书 Docx 或 Wiki 文档，支持结构化内容、富文本和文档内资源块。 |
| `lark-drive` | 管理飞书云空间中的文件与文件夹，包括上传、下载、创建、复制、移动、删除和元数据查询。 |
| `lark-wiki` | 管理飞书知识空间、成员和 Wiki 节点，包括查询、创建、移动与层级整理。 |
| `lark-sheets` | 创建和操作飞书电子表格，包括页签、行列、单元格、格式、公式、筛选和图表等。 |
| `lark-base` | 操作飞书多维表格的表、字段、记录、视图、公式、表单、仪表盘、工作流和权限。 |
| `lark-markdown` | 查看、创建、上传、编辑和比较飞书 Markdown 文件。 |
| `lark-slides` | 创建和编辑飞书幻灯片，管理页面并读取或替换页面内容。 |
| `lark-whiteboard` | 查询和编辑飞书画板，支持导出预览、SVG 或原始节点，并以 Mermaid、PlantUML、SVG 等格式更新内容。 |

## E. 沟通与个人协作（8）

| Skill | 用途 |
|-|-|
| `lark-im` | 收发飞书消息、搜索聊天记录、管理群聊与成员，并处理图片和文件。 |
| `lark-contact` | 在飞书通讯录中按姓名、邮箱或 open_id 查询人员、部门和联系方式。 |
| `lark-calendar` | 管理日历、日程、参会人和会议室，查询忙闲并推荐可用时间。 |
| `lark-task` | 管理飞书任务、清单和任务智能体，包括分配、拆分、更新状态及附件处理。 |
| `lark-approval` | 查询和处理审批待办、已办与实例，查看审批定义并发起原生审批。 |
| `lark-attendance` | 查询当前用户的飞书考勤打卡记录。 |
| `lark-okr` | 管理 OKR 周期、目标、关键结果、对齐关系、量化指标和进展记录。 |
| `lark-mail` | 查询、起草、发送、回复和转发飞书邮件，并管理草稿及附件。 |

## F. 会议与音视频（4）

| Skill | 用途 |
|-|-|
| `lark-vc` | 搜索历史视频会议，读取会议总结、待办、章节、逐字稿和参会人快照。 |
| `lark-vc-agent` | 让应用机器人加入或离开进行中的会议，读取会中事件并发送会中文本消息。 |
| `lark-minutes` | 搜索和管理飞书妙记，读取或编辑产物、下载音视频，并处理标题、说话人和关键词。 |
| `lark-note` | 在已知 note_id 时直接查询飞书会议纪要详情、展示类型、关联文档与统一内容。 |

## G. 平台开发与扩展（4）

| Skill | 用途 |
|-|-|
| `lark-apps` | 开发和托管飞书妙搭应用，覆盖应用创建、本地全栈开发、云端生成迭代、设计与发布。 |
| `lark-event` | 监听、订阅和消费飞书实时事件，用于事件驱动的自动化与集成。 |
| `lark-openapi-explorer` | 从官方文档库探索尚未被 CLI 封装的飞书原生 OpenAPI，并辅助构造调用方案。 |
| `lark-skill-maker` | 把飞书 API 操作封装成可复用的 lark-cli 自定义 Skill。 |

## H. 组合工作流（2）

| Skill | 用途 |
|-|-|
| `lark-workflow-meeting-summary` | 汇总指定时间范围内的会议纪要，生成结构化会议回顾或周报。 |
| `lark-workflow-standup-report` | 组合日历与任务数据，生成指定日期的日程、待办和站会摘要。 |

## I. 本机辅助（1）

| Skill | 用途 |
|-|-|
| `zhusun-food-reminder` | 在 Windows 本机预览、创建、修改、查看、试运行或移除竹笋点餐页面的工作日定时提醒。默认周一至周五 11:00 使用系统默认浏览器打开稳定入口；不修改飞书功能，不发送飞书消息。 |

---

本文档按已完成本机验收的 ipskill v2.8.0 manifest、Profile 和 Skill 定义更新。正式跨电脑可用版本仍以 SVN 已提交内容为准；后续增删 Skill 时，应同步更新 Profile 数量、分类清单与发布状态。
