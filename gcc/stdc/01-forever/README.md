# forever.c


## forground

```
PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> gcc forever.c -o forever
PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> ./forever
```

## Start-Process: NewWindow

```
PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> Start-Process forever.exe
// 此時會開出一個新視窗去跑 forever.exe

PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> Get-Process -name forever

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
     50       5      684       2716      17.03  10368   7 forever

// 接著按 Ctrl-Alt-Del 選工作管理員，看有沒有 forever.exe
```

## Start-Process : NoNewWindow

```
PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> Start-Process -NoNewWindow forever.exe
PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> Get-Process -name forever

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
     50       5      684       2716      17.03  10368   7 forever

PS D:\ccc\course\sp\code\c\06-os1windows\02-forever> Stop-Process -name forever
```


