if (typeof window.delta == "object") {
  console.log("window.delta already exists！")
} else {
  console.log("window.delta binding11");
  window.delta = {
    // duration = 0;
    // position = 0;
    // playerState = 'stopped';
    get AppId() { return 0 },
    get languageCode() { return "en" },
    showGoBack: false,
    popShowGoBack() {
      let _showGoBack = this.showGoBack;
      if (this.showGoBack) {
        this.showGoBack = false;
      }
      return _showGoBack;
    },
    callApi: function (actor, funcName, args = null) {
      return window.flutter_inappwebview.callHandler('callApi', actor, funcName, args);
    },
    toast: function (content) {
      window.flutter_inappwebview.callHandler('toast', content);
    },
    showConfirm: function (content, title = null) {
      return window.flutter_inappwebview.callHandler('showConfirm', content, title);
    },
    showAlert: function (content, title = null) {
      return window.flutter_inappwebview.callHandler('showAlert', content, title);
    },
    showQRcode: function (content, style = "dots") {
      window.flutter_inappwebview.callHandler('showQRcode', content, style);
    },
    scanQR: function () {
      return window.flutter_inappwebview.callHandler('scanQR');
    },
    langText: function (label) {
      return window.flutter_inappwebview.callHandler('langText', label);
    },
    openUrl: function (url) {
      return window.flutter_inappwebview.callHandler('openUrl', url);
    },
    authByIdentToken: function () {
      return window.flutter_inappwebview.callHandler('authByIdentToken', this.AppId);
    },

    getDAppAcctInfo(dAppIdentToken) {
      return window.flutter_inappwebview.callHandler('getDAppAcctInfo', dAppIdentToken);
    },

    listAvatarNickname(dids) {
      return window.flutter_inappwebview.callHandler('listAvatarNickname', dids);
    },

    languageCodes() {
      return window.flutter_inappwebview.callHandler('languageCodes');
    },

    showAd(key, listener) {
      window.flutter_inappwebview.callHandler('showAd', key);
      this.adListener = listener;
    },

    walletPayment(coinCode, toAddress, amount, memo) {
      return window.flutter_inappwebview.callHandler('walletPayment', coinCode, toAddress, amount, memo);
    },

    listTransaction(coinCode, optFilterArgs, skipId, limit) {
      return window.flutter_inappwebview.callHandler('listTransaction', coinCode, optFilterArgs, skipId, limit);
    },

    adListener: {
      onShow() {
        console.log("onShow 默认！默认！")
      },
      onError(errorCode, errorMessage) {
        console.log("onError 默认！默认！", errorCode, errorMessage)
      },
      onClick() {
        console.log("onClick 默认！默认！")
      },
      onClose() {
        console.log("onClose 默认！默认！")
      },
    }
  };
  const event = new CustomEvent("deltaReady");
  setTimeout(window.dispatchEvent, 500, event);
}