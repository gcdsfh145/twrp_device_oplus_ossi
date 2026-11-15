# OrangeFox / TWRP device tree — oplus ossi (一加 Ace 5 Pro)

基于你提供的 `DeviceTree_4.zip`（twrpdtgen 生成），按
[OrangeFox-Recovery-Builder](https://github.com/gcdsfh145/OrangeFox-Recovery-Builder)
的 README 做了**必要修改**，可直接作为 `device/oplus/ossi` 使用。

## 相对原始设备树的改动

| 文件 | 改动 | 原因 |
| --- | --- | --- |
| `omni_ossi.mk` → `twrp_ossi.mk` | 产品名改为 `twrp_ossi` | builder 工作流固定执行 `lunch twrp_ossi-eng` |
| `AndroidProducts.mk` | 指向 `twrp_ossi.mk`，加 `COMMON_LUNCH_CHOICES` | 让 `lunch twrp_ossi-eng` 能找到产品 |
| `vendorsetup.sh` | `omni_*` → `twrp_*` | 同上 |
| `OrangeFoxConfig.mk` | 新增 | builder README 要求 |
| `BoardConfig.mk` | 末尾 `-include $(DEVICE_PATH)/OrangeFoxConfig.mk` | 同上 |
| `BoardConfig.mk` | 删除 `BOARD_USES_RECOVERY_AS_BOOT := true`，改为 `BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true` | 本机 recovery_a.img 是 boot header v4 且 `kernel_size = 0`，recovery 分区不带内核 |
| `BoardConfig.mk` | 删除 `TARGET_FORCE_PREBUILT_KERNEL` / `TARGET_PREBUILT_KERNEL` / `TARGET_KERNEL_SOURCE` / `TARGET_KERNEL_CONFIG` | 树里没有 `prebuilt/kernel`，也没有内核源码；不删会构建失败 |
| `BoardConfig.mk` | 动态分区列表去重（原文件把每个分区写了 2~3 次） | 原文件明显是模板重复，会生成错误 super_empty |
| `BoardConfig.mk` | `AB_OTA_PARTITIONS` 换成 `ro.product.ab_ota_partitions` 的 stock 值 | 原模板只有 5 个分区，不准 |
| `BoardConfig.mk` | 加 `BOARD_RAMDISK_USE_LZ4 := true`、亮度节点、`TW_FRAMERATE` | stock ramdisk 是 lz4；不设亮度节点屏幕默认最暗 |
| `device.mk` | 精简为基础 product + TWRP common，去掉 `bootctrl.sun` / `update_engine` / `AB_OTA_POSTINSTALL_CONFIG` | 这些模块在 OrangeFox 的 minimal manifest 里不存在，会直接编译报错 |

## GitHub Actions 构建参数

在 builder 仓库跑 `OrangeFox-Compile` 工作流时填：

| 输入 | 值 |
| --- | --- |
| `MANIFEST_BRANCH` / OrangeFox 版本 | `14.1` |
| `DEVICE_TREE` | 你 push 后的仓库地址 |
| `DEVICE_TREE_BRANCH` | `main`（或你用的分支） |
| `DEVICE_PATH` | `device/oplus/ossi` |
| `DEVICE_NAME` | `ossi` |
| `BUILD_TARGET` | `recovery` |
| `DN` / 设备名 | `OnePlus Ace 5 Pro` |

> 注意：`DEVICE_NAME` 是 `ossi`，产物是 `out/target/product/ossi/recovery.img`。

### ⚠️ 必须改工作流里的 lunch 那一行

OrangeFox `14.1` 基于 AOSP 14，`lunch` 强制三段式
`<product>-<release>-<variant>`，而 builder 里写死的是两段式的
`lunch twrp_${DEVICE_NAME}-eng`，会直接报
`Invalid lunch combo: twrp_ossi-eng`。

在你 fork 的 `.github/workflows/OrangeFox-Compile.yml` 里改：

```diff
-        lunch twrp_${{ inputs.DEVICE_NAME }}-eng && mka ${{ inputs.BUILD_TARGET }}image
+        lunch twrp_${{ inputs.DEVICE_NAME }}-ap2a-eng && mka ${{ inputs.BUILD_TARGET }}image
```

如果报 `unknown release "ap2a"`，把 `ap2a` 换成 `next` 再跑。

## 本地编译（可选）

```bash
repo init --depth=1 -u https://gitlab.com/OrangeFox/sync.git -b 14.1
repo sync -j8 --force-sync
git clone <你的仓库> device/oplus/ossi
source build/envsetup.sh
lunch twrp_ossi-eng
mka recoveryimage
```

## 刷入

```bash
fastboot flash recovery recovery.img
# A/B 设备注意当前槽位，必要时：
fastboot flash recovery_a recovery.img
fastboot flash recovery_b recovery.img
# 或进入 fastbootd 后
fastboot reboot recovery
```

## 仍待确认 / 可自行调整

1. **`BOARD_SUPER_PARTITION_SIZE`**：现在是模板占位值 `9126805504`，只影响
   `super_empty.img`，不影响 `recovery.img`。拿到本机 GPT
   （`adb shell ls -l /dev/block/by-name/super` 或 `sgdisk -p`）后替换。
2. **`OF_SCREEN_H`**：按 1264x2780 设为 `2780`。如果开机 UI 缩放或触摸错位，
   改 `OrangeFoxConfig.mk` 里的 `OF_SCREEN_H` / `OF_STATUS_H`。
3. **解密（FBE）**：`OF_DEFAULT_KEYMASTER_VERSION := 4.0` 是 sun 平台的常见值，
   如果 data 解密失败，改成 `3.0` 再试。
4. **首次开机 log**：进入 recovery 后 `adb pull /tmp/recovery.log`，
   有问题看这个文件最快。
