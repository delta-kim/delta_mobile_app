## Delta dApp interface call instructions

## Interface List

    1. delta.authByIdentToken
```javascript
    let res = await window.delta.authByIdentToken();
    if (res == null) return null;
    localStorage.setItem("identToken", JSON.stringify(res));
    return {
        accCanisterId: res.accCanisterId,
        dAppIdentToken: res.dAppIdentToken
    };
 ```

    2. delta.getDAppAcctInfo
```javascript
    let res = await window.delta.getDAppAcctInfo();
 ```
    3. delta.languageCode
```javascript
    let code = await window.delta.languageCode();
```
    4. delta.languageCodes
```javascript
    let codes = await window.delta.languageCodes();
```
    5. delta.listAvatarNickname
```javascript
    window.delta.listAvatarNickname(Array.from(dids)).then((listAvatar) => {
        for (const obj of listAvatar) {
            avatarNickname.value[obj.did] = { nickname: obj.nickname, avatarSrc: obj.avatarSrc };
        }
    });
```
    6. delta.toast
```javascript
    window.delta.toast("Hello!");
```

    7. delta.showAlert
```javascript
   let title = "Optional";
    let void = await window.delta.showAlert("this is alert!", title);
```

    8. delta.showConfirm
```javascript
   let title = "Optional";
   let bool =  await window.delta.showConfirm("Do you confirm?", title);
```

    9. delta.showGoBack
```javascript
   // This is a property. Tells the Delta host that navigation can be controlled using the device's Back key
   window.delta && (window.delta.showGoBack = true);
```

    10. delta.openUrl
```javascript
   // Open a web page in your browser
   window.delta.openUrl("https://www.google.com")
```

    11. Note: Before calling the delta object, you need to make sure the delta object is ready.
  ```javascript
    if (window.delta) { // Make sure the delta object is ready
        let bool = await window.delta.showConfirm($t("authorizeNow_getWritePermission"), title);
    }
```  

    12. Call advertisement
```javascript
  showAd(key, listener);
    // The key is fixed to "SOCIO_INTERSTITIAL", currently only for application SOCIO
    // Example
    window.delta.showAd("SOCIO_INTERSTITIAL", {
    onShow() {
      console.log("show Ad");
      //Successful advertisement display, start recording reward points
    },
    onError(errorCode, errorMessage) {
      console.log("onError", errorCode, errorMessage);
    },
    onClick() {
      console.log("click Ad");
    },
    onClose() {
      console.log("close Ad");
    },
  });
```
    13. Wallet payment

```javascript
      window.delta.walletPayment(coinCode, toAddress, amount, memo); // memo Maximum length of 32 characters
// Example
    let result =  await window.delta.walletPayment("USDT", "4iX5R3WzHrhZKk52M", 0.1, "Test");
    if(typeof result == 'object' && result != null ){
        let from_balance = result["from_balance"]; //Decimal The balance after payment to the sending address
        let to_balance = result["to_balance"]; //Decimal The balance of the receiving address after receiving the payment
        let id = result["id"]; // Transaction ID
    }else{
       console.log("Payment failed"); 
    }
```
    13. list Transaction
```javascript    
    listTransaction(coinCode, optFilterArgs, skipId, limit)
// Example
    let coinCode = "USDT";
    let skipId = Number.MAX_SAFE_INTEGER;
    let limit = 10;

    let array =  await window.delta.listTransaction(coinCode, [] , skipId, limit); // Query records without filtering conditions
    let array =  await window.delta.listTransaction(coinCode, [{"Id" : 100}] , skipId, limit); // The query filter is transaction id
    let array =  await window.delta.listTransaction(coinCode, [{"From" : "4iX5R3WzHrhZKk52M"}] , skipId, limit); // The query filter condition is From address
    let array =  await window.delta.listTransaction(coinCode, [{"To" : "4iX5R3WzHrhZKk52M"}] , skipId, limit); // The query filter condition is To address
    let array =  await window.delta.listTransaction(coinCode, [{"All" : "4iX5R3WzHrhZKk52M"}] , skipId, limit); // Filter conditions: From address or To address
    let array =  await window.delta.listTransaction(coinCode, [{"TxId" : "a4bb4ba5ff1173a360699469c4ca0632bd224daaa698bdb2ac4b22f811dfb146"}] , skipId, limit); // The filtering condition is the cross-chain transaction TxId

```









