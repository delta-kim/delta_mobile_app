if (typeof window.delta == "object") {
  console.log("window.delta already exists！")
} else {
  console.log("window.delta binding11");
  window.delta = {
    // duration = 0;
    // position = 0;
    // playerState = 'stopped';
    handles: {},
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
      let message = { model: "callApi", actor, funcName: funcName, args: args, handle: "callApi" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },
    toast: function (content) {
      let message = { model: "toast", args: [content], handle: "toast" + new Date().getTime() };
      window.flutter.postMessage(JSON.stringify(message));
    },
    showConfirm: function (content, title = null) {
      let message = { model: "showConfirm", args: [content, title], handle: "showConfirm" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },
    showAlert: function (content, title = null) {
      let message = { model: "showAlert", args: [content, title], handle: "showAlert" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },

    authByIdentToken: function () {
      let message = { model: "authByIdentToken", args: [this.AppId], handle: "authByIdentToken" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },

    getDAppAcctInfo(dAppIdentToken) {
      let message = { model: "getDAppAcctInfo", args: [dAppIdentToken], handle: "getDAppAcctInfo" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },

    listAvatarNickname(dids) {
      let message = { model: "listAvatarNickname", args: [dids], handle: "listAvatarNickname" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },

    languageCodes() {
      let message = { model: "languageCodes", args: [], handle: "languageCodes" + new Date().getTime() };
      return new Promise((resolve, reject) => {
        window.flutter.postMessage(JSON.stringify(message));
        this.handles[message.handle] = resolve;
      });
    },

    receiveFlutterResults: function (handle, results) {
      let reject = this.handles[handle];
      if (reject) {
        if (results == "void")
          reject();
        else
          reject(results);
      }
    }
  };
  const event = new CustomEvent("deltaReady");
  setTimeout(window.dispatchEvent, 500, event);
}