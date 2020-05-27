## vscode

安裝 ssh fs 插件，可以遠端使用 vscode 編輯 server 上的檔案

1 - 先從 Extension 尋找 ssh fs 並安裝好
2 - 然後到 File/Preference/Setting 編輯 setting.json，加入以下資訊

```json
{
    "remote.onstartup": true,
    "sshfs.configs": [
        {
            "root":"/home/guest",
            "host": "misavo.com",
            "username": "guest",
            "password": "csienqu",
            "name": "guest"
        }
    ]
}
```

3 - 按下 F1 輸入 ssh fs 選 SSH FS:Connect as Workspace Folder 

然後會看到 Explorer 中出現 SSH FS-guest 的資料夾

裡面有 sp 這個子資料夾，於是你可以用 vscode 直接修改檔案。


