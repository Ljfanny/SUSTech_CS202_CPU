# SUSTech_CS202_CPU

## 遇到的问题

### git 仓库同步问题

注意到 vivado 在运行时会生成许多文件，尤其在每个ip核内都会更新对应的 `.xml` 文件，记录下 `.coe` 文件的路径。可能是由于该问题，导致如果这些本地记录的配置被同步到远端以后，其他人 pull 以后会出现路径相关的问题。基于以上种种原因，我们在 git 仓库中添加了以下 `.gitignore` 文件：

```gitignore

```

### 时钟 ip 核问题

在按照课件配置时钟 ip 核以后，发现在 implementation 过程中出现了以下错误:

![](images/clock_ip.png)


查阅相关资料后，将时钟来源从更改为了 `Global buffer`。

参考：https://blog.csdn.net/qq_39507748/article/details/115909998