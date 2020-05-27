
```
Tim@DESKTOP-QOC5V2F MINGW64 ~
$ pacman -S pkg-config
正在解決依賴關係…
正在檢查衝突的軟體包…

軟體包 (1) pkg-config-0.29.2-1

總計安裝大小：  0.54 MiB

:: 進行安裝嗎？ [Y/n] y
(1/1) 正在檢查鑰匙圈中的鑰匙                       [#####################] 100%
(1/1) 正在檢查軟體包完整性                         [#####################] 100%
(1/1) 正在載入軟體包檔案                           [#####################] 100%
(1/1) 正在檢查檔案衝突                             [#####################] 100%
(1/1) 正在檢查可用磁碟空間                         [#####################] 100%
:: 正在處理軟體包變更…
(1/1) 正在安裝 pkg-config                          [#####################] 100%

Tim@DESKTOP-QOC5V2F MINGW64 ~
$ pkg-config --cflags glib-2.0
-mms-bitfields -I/mingw64/include/glib-2.0 -I/mingw64/lib/glib-2.0/include -I/mingw64/include

```