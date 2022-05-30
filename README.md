# SUSTech_CS202_CPU

## 介绍

小组分工

- 12011543 林洁芳：基础模块、部分IO模块、汇编测试
- 12011411 吴笑丰：顶层模块、部分IO模块、Uart模块
- 12011906 汤奕飞：汇编测试

本小组 CPU 实现了

## 功能

### 实现指令

- Minisys中的全部指令
- 其他指令

### 外部设备

- 24个拨码开关
- 17个 Led 灯
- 3个按钮

### 其他实现

- UART
- 性能优化？

uart 三种模式

- 按下 rst 进入正常工作状态；
- 按下复位 rst 进入复位模式；
- 通信开始后，进入 uart 通信模式；
- 通信结束后，进入复位模式，再次按下rst正常工作。

## 测试

### 基本测试

- 测试一：开关与 led 灯对应测试（老师提供）

```python
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
# 测试存读数据 -> 存啥显示啥        		
switled:								
	lw   $1,0xC70($28)				
	sw   $1,0xC60($28)				
	lw   $1,0xC72($28)
	sw   $1,0xC62($28)	
	j switled
```

- 测试二：加法测试

```python
start: lui   $1,0xFFFF			
       ori   $28,$1,0xF000
       addi   $s0, $zero, 0
       addi   $s2, $zero, 1
       addi   $s3, $zero, 2
       addi   $s4, $zero, 0x0001FFFF
switled:
	lw $t0, 0xC70($28)
	bne $t0, $s4, new_number
	j switled
new_number:									
	sw $s4, 0xC70($28)				
	addi $s0, $s0, 1
	beq $s0, $s3, cal
	add $s1, $zero, $t0
	j switled
cal:
	add $t2, $t0, $s1
	sw  $t2,0xC62($28)
	addi $s0, $zero, 1
	j switled
```

### 场景1

### 场景2

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