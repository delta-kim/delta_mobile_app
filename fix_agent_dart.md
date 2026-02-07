
修复json转换
C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_android-1.1.3\lib\src\in_app_webview\in_app_webview_controller.dart
C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_ios-1.1.2\lib\src\in_app_webview\in_app_webview_controller.dart

``` dart
            toEncodable(Object? nonEncodable) {
              if (nonEncodable is BigInt)   return nonEncodable.toInt();
              return nonEncodable;
            }
            return jsonEncode(await _javaScriptHandlersMap[handlerName]!(args), toEncodable: toEncodable);
```

``` dart
    toEncodable(Object? nonEncodable) {
      if (nonEncodable is BigInt) {
        return nonEncodable.toInt();
      }
      return nonEncodable.toString();
    }
    data = json.decode(data, toEncodable : toEncodable);


```

C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_android-1.1.3\android\src\main\java\com\pichillilorenzo\flutter_inappwebview_android\plugin_scripts_js\JavaScriptBridgeJS.java'
C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_ios-1.1.2\ios\Classes\PluginScriptsJS\JavaScriptBridgeJS.swift
 
  ```js 
  JSON.stringify(... // 找到 ,  然后在后面添加第二个参数(以下函数)：

  function (k, v) {  if (typeof v == 'bigint') return Number(v);  return v;}
  ```