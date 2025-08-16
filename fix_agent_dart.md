file : ".\lib\agent.dart"

Tip: Different versions may have different file paths for this code, you can find it by searching for "QueryResponseRejected("

``` dart
      switch (result.status) {
        case QueryResponseStatus.rejected:
          // throw QueryCallRejectedError(
          //   cid,
          //   methodName,
          //   QueryResponseRejected(
          //     rejectCode: result.rejectCode,
          //     rejectMessage: result.rejectMessage,
          //   ),
          // );
          throw QueryResponseRejected(  // Replace the above code with the code here
            rejectCode: result.rejectCode,
            rejectMessage: result.rejectMessage,
          );
        case QueryResponseStatus.replied:
          return decodeReturnValue(func.retTypes, result.reply!.arg!);
      }
      
```


C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_android-1.1.3\lib\src\in_app_webview\in_app_webview_controller.dart
C:\Users\ippow\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_inappwebview_ios-1.1.2\lib\src\in_app_webview\in_app_webview_controller.dart

``` dart
            toEncodable(Object? nonEncodable) {
              if (nonEncodable is BigInt) {
                return nonEncodable.toInt();
              }
              return nonEncodable.toString();
            }
            return jsonEncode(await _javaScriptHandlersMap[handlerName]!(args), toEncodable: toEncodable);
```
