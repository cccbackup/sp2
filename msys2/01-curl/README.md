# curl

* https://www.ruanyifeng.com/blog/2019/09/curl-reference.html

## 安裝

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/02-wget
$ pacman -Ss curl
mingw32/mingw-w64-i686-curl 7.59.0-2
    Command line tool and library for transferring data with URLs. (mingw-w64)
mingw32/mingw-w64-i686-flickcurl 1.26-2
    Flickcurl is a C library for the Flickr API (mingw-w64)
mingw64/mingw-w64-x86_64-curl 7.59.0-2 [已安裝]
    Command line tool and library for transferring data with URLs. (mingw-w64)
mingw64/mingw-w64-x86_64-flickcurl 1.26-2
    Flickcurl is a C library for the Flickr API (mingw-w64)
msys/curl 7.58.0-1 (base) [已安裝]
    Multi-protocol file transfer utility
msys/libcurl 7.58.0-1 (libraries) [已安裝]
    Multi-protocol file transfer library (runtime)
msys/libcurl-devel 7.58.0-1 (development)
    Libcurl headers and libraries

user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/02-wget
$ pacman -S mingw-w64-x86_64-curl
警告：mingw-w64-x86_64-curl-7.59.0-2 已經爲最新 -- 重新安裝
正在解決依賴關係...
正在檢查衝突的套件...

套件 (1) mingw-w64-x86_64-curl-7.59.0-2

總計安裝大小：  2.39 MiB
淨升級大小：  0.00 MiB

:: 進行安裝嗎？ [Y/n] y
(1/1) 正在檢查鑰匙圈中的鑰匙                         [###########################] 100%
(1/1) 正在檢查套件完整性                             [###########################] 100%
(1/1) 正在載入套件檔案                               [###########################] 100%
(1/1) 正在檢查檔案衝突                               [###########################] 100%
(1/1) 正在檢查可用磁碟空間                           [###########################] 100%
:: 正在處理套件變更...
(1/1) 正在重裝 mingw-w64-x86_64-curl                 [###########################] 100%


```

## 執行

```
user@DESKTOP-96FRN6B MINGW64 /d/ccc/course/sp/code/c/06-os1windows/04-pacman/01-curl
$ curl https://www.example.com
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1256  100  1256    0     0    717      0  0:00:01  0:00:01 --:--:--   717<!doctype html>
<html>
<head>
    <title>Example Domain</title>

    <meta charset="utf-8" />
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style type="text/css">
    body {
        background-color: #f0f0f2;
        margin: 0;
        padding: 0;
        font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;

    }
    div {
        width: 600px;
        margin: 5em auto;
        padding: 2em;
        background-color: #fdfdff;
        border-radius: 0.5em;
        box-shadow: 2px 3px 7px 2px rgba(0,0,0,0.02);
    }
    a:link, a:visited {
        color: #38488f;
        text-decoration: none;
    }
    @media (max-width: 700px) {
        div {
            margin: 0 auto;
            width: auto;
        }
    }
    </style>
</head>

<body>
<div>
    <h1>Example Domain</h1>
    <p>This domain is for use in illustrative examples in documents. You may use this
    domain in literature without prior coordination or asking for permission.</p>
    <p><a href="https://www.iana.org/domains/example">More information...</a></p>
</div>
</body>
</html>
```
