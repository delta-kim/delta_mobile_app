file : ".\lib\agent.dart"

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
          throw QueryResponseRejected(
            rejectCode: result.rejectCode,
            rejectMessage: result.rejectMessage,
          );
        case QueryResponseStatus.replied:
          return decodeReturnValue(func.retTypes, result.reply!.arg!);
      }
      
```
