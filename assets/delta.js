if (typeof window.delta == "object") {
  console.log("window.delta already exists！")
} else {
  console.log("window.delta binding");
  window.delta = {
    // duration = 0;
    // position = 0;
    // playerState = 'stopped';
    AppId: () => window.flutter_inappwebview.callHandler('AppId'),
    brightnessMode: () => window.flutter_inappwebview.callHandler('brightnessMode'),
    languageCode() { return window.flutter_inappwebview.callHandler('languageCode'); },
    showGoBack: false,
    popShowGoBack() {
      let _showGoBack = this.showGoBack;
      if (this.showGoBack) {
        this.showGoBack = false;
      }
      return _showGoBack;
    },
    payload() {
      return window.flutter_inappwebview.callHandler('payload');
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
      return window.flutter_inappwebview.callHandler('authByIdentToken');
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

    pickImage() {
      return window.flutter_inappwebview.callHandler('pickImage');
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
  // const event = new CustomEvent("deltaReady");
  // setTimeout(window.dispatchEvent, 500, event);
}

// NativeOverlay implementation for high-stability dApp UI
if (typeof window.NativeOverlay !== "object") {
  window.NativeOverlay = {
    _container: null,
    _isVisible: false,

    _getContainer() {
      let container = document.getElementById("native-overlay-root");
      if (!container) {
        container = document.createElement("div");
        container.id = "native-overlay-root";
        document.body.appendChild(container);
      }
      return container;
    },

    _setupStyles() {
      if (document.getElementById("native-overlay-styles")) return;
      const style = document.createElement("style");
      style.id = "native-overlay-styles";
      style.innerHTML = `
        :root {
          --ov-surface: rgba(255, 255, 255, 0.85);
          --ov-on-surface: #1c1c1e;
          --ov-on-surface-variant: rgba(60, 60, 67, 0.6);
          --ov-primary: #007AFF;
          --ov-divider: rgba(0, 0, 0, 0.1);
          --ov-backdrop: rgba(0, 0, 0, 0.4);
          --ov-blur: 20px;
        }
        @media (prefers-color-scheme: dark) {
          :root {
            --ov-surface: rgba(28, 28, 30, 0.85);
            --ov-on-surface: #f2f2f7;
            --ov-on-surface-variant: rgba(235, 235, 245, 0.6);
            --ov-primary: #0A84FF;
            --ov-divider: rgba(255, 255, 255, 0.15);
            --ov-backdrop: rgba(0, 0, 0, 0.6);
          }
        }
        #native-overlay-root {
          position: fixed;
          top: 0; left: 0; width: 100%; height: 100%;
          z-index: 1000000;
          display: none;
          flex-direction: column;
          font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
          -webkit-tap-highlight-color: transparent;
        }
        .ov-backdrop {
          position: absolute;
          top: 0; left: 0; width: 100%; height: 100%;
          background: var(--ov-backdrop);
          backdrop-filter: blur(8px);
          -webkit-backdrop-filter: blur(8px);
          opacity: 0;
          transition: opacity 0.3s ease;
        }
        .ov-active .ov-backdrop { opacity: 1; }
        
        .ov-content-wrapper {
          position: relative;
          width: 100%;
          height: 100%;
          display: flex;
          flex-direction: column;
          pointer-events: none;
        }
        
        /* Bottom Sheet */
        .ov-sheet {
          margin-top: auto;
          width: 100%;
          background: var(--ov-surface);
          backdrop-filter: blur(var(--ov-blur));
          -webkit-backdrop-filter: blur(var(--ov-blur));
          border-radius: 32px 32px 0 0;
          padding: 12px 20px 48px 20px;
          box-sizing: border-box;
          transform: translateY(100%);
          transition: transform 0.4s cubic-bezier(0.1, 0.8, 0.2, 1);
          pointer-events: auto;
          box-shadow: 0 -10px 40px rgba(0,0,0,0.2);
          border-top: 0.5px solid rgba(255,255,255,0.1);
        }
        .ov-active .ov-sheet { transform: translateY(0); }
        .ov-handle { width: 36px; height: 5px; background: var(--ov-divider); border-radius: 3px; margin: 0 auto 24px auto; }
        
        /* Modal */
        .ov-modal-container {
          margin: auto;
          width: 88%;
          max-width: 340px;
          background: var(--ov-surface);
          backdrop-filter: blur(var(--ov-blur));
          -webkit-backdrop-filter: blur(var(--ov-blur));
          border-radius: 28px;
          padding: 24px;
          box-sizing: border-box;
          transform: scale(0.8);
          opacity: 0;
          transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
          pointer-events: auto;
          box-shadow: 0 20px 60px rgba(0,0,0,0.3);
          border: 0.5px solid rgba(255,255,255,0.1);
          text-align: center;
        }
        .ov-active .ov-modal-container { transform: scale(1); opacity: 1; }

        /* General UI components */
        .ov-title { font-size: 20px; font-weight: 700; color: var(--ov-on-surface); margin-bottom: 8px; }
        .ov-text { font-size: 15px; color: var(--ov-on-surface-variant); line-height: 1.4; margin-bottom: 24px; }
        .ov-btn-row { display: flex; gap: 12px; }
        .ov-btn-row .ov-btn { flex: 1; }
        .ov-btn { padding: 12px; border: none; border-radius: 16px; font-size: 16px; font-weight: 600; cursor: pointer; transition: opacity 0.2s; }
        .ov-btn:active { opacity: 0.7; }
        .ov-btn-secondary { background: var(--ov-divider); color: var(--ov-on-surface); }
        .ov-btn-primary { background: var(--ov-primary); color: #FFFFFF; }
        .ov-btn-danger { background: #FF3B30; color: #FFFFFF; }
      `;
      document.head.appendChild(style);
    },

    showBottomSheet(html, skipHide = false) {
      if (this._isVisible && !skipHide) this.hide(true);
      this._setupStyles();
      const root = this._getContainer();

      root.innerHTML = `
        <div class="ov-backdrop"></div>
        <div class="ov-content-wrapper">
          <div class="ov-sheet">
            <div class="ov-handle"></div>
            ${html}
          </div>
        </div>
      `;

      root.style.display = "flex";
      setTimeout(() => root.classList.add("ov-active"), 10);
      this._isVisible = true;

      root.querySelector(".ov-backdrop").onclick = () => this.hide();
    },

    showModal(html, skipHide = false) {
      if (this._isVisible && !skipHide) this.hide(true);
      this._setupStyles();
      const root = this._getContainer();

      root.innerHTML = `
        <div class="ov-backdrop"></div>
        <div class="ov-content-wrapper">
          <div class="ov-modal-container">
            ${html}
          </div>
        </div>
      `;

      root.style.display = "flex";
      setTimeout(() => root.classList.add("ov-active"), 10);
      this._isVisible = true;

      root.querySelector(".ov-backdrop").onclick = () => this.hide();
    },

    showMenu(appInfo, options = {}) {
      const {
        onReload, onInfo, onMinimize, onClose,
        t = { reload: "Reload", info: "dApp Info", minimize: "Minimize", close: "Close", cancel: "Cancel", confirm: "Confirm", closeConfirm: "Are you sure you want to close this dApp?" }
      } = options;
      const appType = appInfo.appType || { mini: "1.0.0" };
      const html = `
        <div class="ov-menu-header" style="display: flex; align-items: center; margin-bottom: 24px;">
          <img src="https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/${appInfo.logo}" style="width: 52px; height: 52px; border-radius: 14px; margin-right: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);" onerror="this.src='https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/default.png'">
          <div style="flex: 1; text-align: left;">
            <div style="font-size: 18px; font-weight: 700; color: var(--ov-on-surface);">${appInfo.name}</div>
            <div style="font-size: 13px; color: var(--ov-on-surface-variant);">v${appType.mini}</div>
          </div>
        </div>
        
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 32px;">
          <div class="ov-menu-item" id="menu-reload" style="background: rgba(52, 199, 89, 0.1); display: flex; flex-direction: column; align-items: center; padding: 14px 8px; border-radius: 20px; cursor: pointer;">
            <div style="font-size: 20px; margin-bottom: 6px;">🔄</div>
            <div style="font-size: 11px; font-weight: 600; color: #34C759;">${t.reload}</div>
          </div>
          <div class="ov-menu-item" id="menu-minimize" style="background: rgba(0, 122, 255, 0.1); display: flex; flex-direction: column; align-items: center; padding: 14px 8px; border-radius: 20px; cursor: pointer;">
          <div style="font-size: 20px; margin-bottom: 6px;">➖</div>
          <div style="font-size: 11px; font-weight: 600; color: #007AFF;">${t.minimize}</div>
          </div>
          <div class="ov-menu-item" id="menu-info" style="background: rgba(255, 149, 0, 0.1); display: flex; flex-direction: column; align-items: center; padding: 14px 8px; border-radius: 20px; cursor: pointer;">
            <div style="font-size: 20px; margin-bottom: 6px;">ℹ️</div>
            <div style="font-size: 11px; font-weight: 600; color: #FF9500;">${t.info}</div>
          </div>
        </div>

        <button id="menu-close" class="ov-btn ov-btn-danger" style="width: 100%; border-radius: 20px; padding: 13px; font-size: 16px; display: flex; align-items: center; justify-content: center; gap: 8px;">
          <span>${t.close}</span>
        </button>
      `;

      this.showBottomSheet(html);

      const bind = (id, fn) => {
        const el = document.getElementById(id);
        if (el) el.onclick = () => {
          this.hide(true); // Immediate hide to avoid race conditions
          if (fn) setTimeout(fn, 50);
        };
      };

      bind("menu-reload", onReload);
      bind("menu-info", onInfo);
      bind("menu-minimize", onMinimize);

      const closeBtn = document.getElementById("menu-close");
      if (closeBtn) closeBtn.onclick = () => onClose();

      // if (closeBtn) closeBtn.onclick = () => {
      //   this.confirm(t.closeConfirm, {
      //     title: t.close,
      //     confirmText: t.close,
      //     onConfirm: onClose
      //   });
      // };
    },

    _getAvatarUrl(avatarStr) {
      if (!avatarStr) return "assets/avatar/placeholder.jpg";
      const parts = avatarStr.split("#");
      const name = parts[0];
      const index = parseInt(parts[1]) || 0;
      if (name === "ICPunks") {
        return `https://punks.oss-ap-southeast-1.aliyuncs.com/icpunks/${index}.jpg?x-oss-process=image/resize,w_192,limit_0`;
      } else if (name === "BAYC") {
        return `https://punks.oss-ap-southeast-1.aliyuncs.com/BAYC/${index.toString().padStart(4, '0')}.png?x-oss-process=image/resize,w_192,limit_0`;
      }
      return `https://punks.oss-ap-southeast-1.aliyuncs.com/cryptopunks/${index.toString().padStart(4, '0')}.png?x-oss-process=image/resize,w_192,limit_0`;
    },

    showAppInfo(appInfo, moreInfo, options = {}) {
      const { t = {} } = options;
      const appType = moreInfo.appType || { mini: "1.0.0" };
      const score = appInfo.score || { good: 0, normal: 0, bad: 0 };
      const status = Object.keys(moreInfo.status || { Active: null })[0];

      const html = `
        <div style="text-align: left; height: 75vh; display: flex; flex-direction: column;">
          <!-- Header -->
          <div style="display: flex; align-items: center; margin-bottom: 20px; flex-shrink: 0;">
            <img src="https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/${appInfo.logo}" style="width: 56px; height: 56px; border-radius: 14px; margin-right: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);" onerror="this.src='https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/default.png'">
            <div style="flex: 1;">
              <div style="font-size: 19px; font-weight: 700; color: var(--ov-on-surface);">${appInfo.name}</div>
              <div style="display: flex; align-items: center; gap: 8px; margin-top: 4px;">
                <span id="version-btn" style="font-size: 13px; font-weight: 600; color: var(--ov-primary); text-decoration: underline; cursor: pointer;">v${appType.mini}</span>
                <span style="padding: 2px 8px; background: var(--ov-divider); border-radius: 6px; font-size: 11px; font-weight: 700; color: var(--ov-on-surface-variant);">${status}</span>
              </div>
            </div>
          </div>

          <!-- Tabs -->
          <div style="display: flex; gap: 16px; margin-bottom: 20px; border-bottom: 0.5px solid var(--ov-divider); flex-shrink: 0;">
            <div class="ov-tab active" data-tab="about" style="padding: 8px 4px; font-size: 14px; font-weight: 700; color: var(--ov-on-surface); border-bottom: 2px solid var(--ov-primary); cursor: pointer;">About</div>
            <div class="ov-tab" data-tab="devs" style="padding: 8px 4px; font-size: 14px; font-weight: 600; color: var(--ov-on-surface-variant); cursor: pointer;">${t.developers || 'Developers'}</div>
            <div class="ov-tab" data-tab="reviews" style="padding: 8px 4px; font-size: 14px; font-weight: 600; color: var(--ov-on-surface-variant); cursor: pointer;">${t.reviews || 'Reviews'}</div>
          </div>

          <!-- Content Scroll Area -->
          <div id="info-content-area" style="flex: 1; overflow-y: auto; padding-bottom: 20px;">
            <!-- Tab: About -->
            <div id="tab-about" class="ov-tab-pane">
              <div style="margin-bottom: 24px;">
                <div style="font-size: 12px; font-weight: 700; color: var(--ov-on-surface-variant); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px;">${t.description || "Description"}</div>
                <div style="font-size: 15px; color: var(--ov-on-surface); line-height: 1.6; opacity: 0.9;">${moreInfo.description || "No description available."}</div>
              </div>

              <div style="display: flex; gap: 10px; margin-bottom: 24px;">
                <div style="flex: 1; background: var(--ov-divider); padding: 12px; border-radius: 16px; text-align: center;">
                  <div style="font-size: 18px; margin-bottom: 2px;">👍</div>
                  <div style="font-size: 14px; font-weight: 700; color: var(--ov-on-surface);">${score.good}</div>
                </div>
                <div style="flex: 1; background: var(--ov-divider); padding: 12px; border-radius: 16px; text-align: center;">
                  <div style="font-size: 18px; margin-bottom: 2px;">😐</div>
                  <div style="font-size: 14px; font-weight: 700; color: var(--ov-on-surface);">${score.normal}</div>
                </div>
                <div style="flex: 1; background: var(--ov-divider); padding: 12px; border-radius: 16px; text-align: center;">
                  <div style="font-size: 18px; margin-bottom: 2px;">👎</div>
                  <div style="font-size: 14px; font-weight: 700; color: var(--ov-on-surface);">${score.bad}</div>
                </div>
              </div>
            </div>

            <!-- Tab: Devs -->
            <div id="tab-devs" class="ov-tab-pane" style="display: none;">
              <div id="devs-list" style="display: flex; flex-wrap: wrap; gap: 12px;">
                <div class="ov-loader" style="width: 100%; text-align: center; padding: 20px; color: var(--ov-on-surface-variant);">Loading team...</div>
              </div>
            </div>

            <!-- Tab: Reviews -->
            <div id="tab-reviews" class="ov-tab-pane" style="display: none;">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                <div style="font-size: 16px; font-weight: 700; color: var(--ov-on-surface);">${t.reviews || 'Reviews'}</div>
                <button id="add-review-btn" style="background: none; border: none; color: var(--ov-primary); font-size: 14px; font-weight: 600; cursor: pointer;">+ ${t.postReview || 'Post Review'}</button>
              </div>
              
              <div id="review-form" style="display: none; background: var(--ov-divider); padding: 16px; border-radius: 16px; margin-bottom: 20px;">
                <div style="margin-bottom: 12px; display: flex; gap: 12px;">
                  <label><input type="radio" name="score" value="good" checked> 👍</label>
                  <label><input type="radio" name="score" value="normal"> 😐</label>
                  <label><input type="radio" name="score" value="bad"> 👎</label>
                </div>
                <textarea id="review-content" style="width: 100%; min-height: 80px; background: var(--ov-surface); border: 1px solid var(--ov-divider); border-radius: 12px; padding: 10px; color: var(--ov-on-surface); font-family: inherit; font-size: 14px; margin-bottom: 12px;" placeholder="Tell us what you think..."></textarea>
                <div style="display: flex; gap: 8px;">
                  <button id="cancel-review" class="ov-btn ov-btn-secondary" style="padding: 8px; font-size: 13px;">${t.cancel}</button>
                  <button id="submit-review" class="ov-btn ov-btn-primary" style="padding: 8px; font-size: 13px;">${t.submit}</button>
                </div>
              </div>

              <div id="reviews-list">
                <div class="ov-loader" style="width: 100%; text-align: center; padding: 20px; color: var(--ov-on-surface-variant);">Loading reviews...</div>
              </div>
            </div>
          </div>

          <!-- Bottom Action -->
          <button class="ov-btn ov-btn-primary" style="width: 100%; border-radius: 20px; flex-shrink: 0;" onclick="NativeOverlay.hide()">${t.close}</button>
        </div>
      `;
      this.showBottomSheet(html, true);

      // --- Load Team ---
      const loadDevs = async () => {
        const teamDids = moreInfo.teamDids || [];
        console.log("NativeOverlay: loadDevs starting", teamDids);
        if (teamDids.length === 0) {
          document.getElementById("devs-list").innerHTML = '<div style="text-align: center; padding: 20px; color: var(--ov-on-surface-variant);">No team members listed.</div>';
          return;
        }
        if (document.getElementById("devs-list").querySelector(".dev-item")) return;

        try {
          if (window.flutter_inappwebview) {
            const list = await window.flutter_inappwebview.callHandler('appTeam', teamDids);
            console.log("NativeOverlay: appTeam response", list);
            const listArea = document.getElementById("devs-list");
            listArea.innerHTML = "";

            if (!list || list.length === 0) {
              listArea.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--ov-on-surface-variant);">No team data found.</div>';
              return;
            }

            list.forEach(dev => {
              const devEl = document.createElement("div");
              devEl.className = "dev-item";
              devEl.style.cssText = "text-align: center; width: 64px; cursor: pointer;";
              devEl.innerHTML = `
                <img src="${this._getAvatarUrl(dev[2])}" style="width: 48px; height: 48px; border-radius: 50%; border: 2px solid var(--ov-surface); margin-bottom: 4px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                <div style="font-size: 11px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--ov-on-surface);">${dev[1]}</div>
              `;
              devEl.onclick = () => alert(`${t.did || 'DID'}: ${dev[0]}\n${t.nickname || 'Name'}: ${dev[1]}`);
              listArea.appendChild(devEl);
            });
          }
        } catch (err) {
          console.error("NativeOverlay: loadDevs failed", err);
        }
      };

      // --- Load Reviews ---
      const loadReviews = async () => {
        console.log("NativeOverlay: loadReviews starting");
        if (document.getElementById("reviews-list").querySelector(".review-card")) return;
        try {
          if (window.flutter_inappwebview) {
            const res = await window.flutter_inappwebview.callHandler('appEvaluations', appInfo.id, 0);
            console.log("NativeOverlay: appEvaluations response", res);
            const listArea = document.getElementById("reviews-list");
            if (!res || !res.list || res.list.length === 0) {
              listArea.innerHTML = `<div style="text-align: center; padding: 20px; color: var(--ov-on-surface-variant);">No reviews yet.</div>`;
              return;
            }
            listArea.innerHTML = "";

            const nicknamesMap = {};
            if (res.nicknames) {
              res.nicknames.forEach(n => nicknamesMap[n[0]] = { name: n[1], avatar: n[2] });
            }

            res.list.forEach(rev => {
              const nick = nicknamesMap[rev.did] || { name: 'Anon', avatar: '' };
              const card = document.createElement("div");
              card.className = "review-card";
              card.style.cssText = "background: var(--ov-divider); padding: 12px; border-radius: 14px; margin-bottom: 12px;";
              card.innerHTML = `
                <div style="display: flex; align-items: center; margin-bottom: 8px;">
                  <img src="${this._getAvatarUrl(nick.avatar)}" style="width: 28px; height: 28px; border-radius: 50%; margin-right: 8px;">
                  <div style="flex: 1; font-size: 13px; font-weight: 700; color: var(--ov-on-surface);">${nick.name}</div>
                  <div style="font-size: 12px;">${Object.keys(rev.score)[0] === 'good' ? '👍' : Object.keys(rev.score)[0] === 'bad' ? '👎' : '😐'}</div>
                </div>
                <div style="font-size: 14px; color: var(--ov-on-surface); line-height: 1.4; opacity: 0.9;">${rev.content}</div>
                <div style="text-align: right; font-size: 11px; color: var(--ov-on-surface-variant); margin-top: 4px;">${new Date(Number(rev.timestamp) / 1000000).toLocaleDateString()}</div>
              `;
              listArea.appendChild(card);
            });
          }
        } catch (err) {
          console.error("NativeOverlay: loadReviews failed", err);
        }
      };

      // --- Tab Management ---
      const tabs = document.querySelectorAll(".ov-tab");
      const panes = document.querySelectorAll(".ov-tab-pane");
      tabs.forEach(tab => {
        tab.onclick = () => {
          tabs.forEach(t => { t.classList.remove("active"); t.style.borderBottom = "none"; t.style.fontWeight = "600"; t.style.color = "var(--ov-on-surface-variant)"; });
          panes.forEach(p => p.style.display = "none");
          tab.classList.add("active");
          tab.style.borderBottom = "2px solid var(--ov-primary)";
          tab.style.fontWeight = "700";
          tab.style.color = "var(--ov-on-surface)";
          document.getElementById(`tab-${tab.dataset.tab}`).style.display = "block";

          if (tab.dataset.tab === "devs") loadDevs();
          if (tab.dataset.tab === "reviews") loadReviews();
        };
      });

      // --- Add Review Logic ---
      const addBtn = document.getElementById("add-review-btn");
      const form = document.getElementById("review-form");
      if (addBtn && form) {
        addBtn.onclick = () => form.style.display = "block";
        document.getElementById("cancel-review").onclick = () => form.style.display = "none";
        document.getElementById("submit-review").onclick = async () => {
          const content = document.getElementById("review-content").value;
          const scoreRadio = document.querySelector('input[name="score"]:checked');
          const scoreVal = scoreRadio ? scoreRadio.value : "good";
          if (!content) return;

          console.log("NativeOverlay: Submitting review", content, scoreVal);
          const post = {
            "score": { [scoreVal]: null },
            "did": "",
            "timestamp": 0,
            "content": content,
          };

          try {
            const res = await window.flutter_inappwebview.callHandler('postEvaluation', appInfo.id, post);
            console.log("NativeOverlay: postEvaluation response", res);
            if (res) {
              form.style.display = "none";
              document.getElementById("review-content").value = "";
              document.getElementById("reviews-list").innerHTML = '<div class="ov-loader">Reloading reviews...</div>';
              loadReviews();
            }
          } catch (err) {
            console.error("NativeOverlay: postEvaluation failed", err);
          }
        };
      }

      // --- Version Notes ---
      const verBtn = document.getElementById("version-btn");
      if (verBtn) {
        verBtn.onclick = async () => {
          try {
            const notes = await window.flutter_inappwebview.callHandler('appVersionNotes', appInfo.id);
            if (!notes || notes.length === 0) {
              this.confirm("No version notes available.", { title: t.versionNotes || "Version Notes", cancelText: t.close || "Close", confirmText: "" });
              return;
            }
            let notesHtml = `<div style="text-align: left; padding: 4px; max-height: 50vh; overflow-y: auto;">`;
            [...notes].reverse().forEach(row => {
              notesHtml += `
                <div style="margin-bottom: 16px; border-bottom: 0.5px solid var(--ov-divider); padding-bottom: 8px;">
                  <div style="display: flex; justify-content: space-between; margin-bottom: 4px;">
                    <span style="color: #34C759; font-weight: 800; font-size: 14px;">v${row[0]}</span>
                    <span style="font-size: 12px; color: var(--ov-on-surface-variant);">${new Date(Number(row[1]) / 1000000).toLocaleDateString()}</span>
                  </div>
                  <div style="font-size: 14px; line-height: 1.5; color: var(--ov-on-surface); opacity: 0.85;">${row[2]}</div>
                </div>
              `;
            });
            notesHtml += "</div>";
            this.confirm(notesHtml, { title: t.versionNotes || "Version Notes", cancelText: t.close || "Close", confirmText: "" });
          } catch (err) {
            console.error("NativeOverlay: appVersionNotes failed", err);
          }
        };
      }
    },

    showAuthOverlay(appInfo, options = {}) {
      const {
        onCancel, onConfirm,
        t = { title: "Authorize dApp", subtitle: "Login with identity token", cancel: "Cancel", confirm: "Authorize Now", localAuth: "Local Authentication Required" }
      } = options;

      const html = `
        <div style="text-align: center; padding: 8px 4px;">
          <div style="font-size: 20px; font-weight: 800; color: var(--ov-on-surface); margin-bottom: 24px;">${t.title}</div>
          
          <img src="https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/${appInfo.logo}" style="display: block; margin: 0 auto 24px auto; width: 80px; height: 80px; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.15);text-align: center;" onerror="this.src='https://pub-127e19f7b07747c6b37b142adc82ba6b.r2.dev/dapplogo/default.png'">
          
          <div style="font-size: 18px; font-weight: 700; color: var(--ov-on-surface); margin-bottom: 8px;">${appInfo.name}</div>
          <div style="font-size: 14px; font-weight: 500; color: #FF3B30; margin-bottom: 32px;">[ ${t.localAuth} ]</div>
          
          <div class="ov-btn-row">
            <button id="auth-cancel-btn" class="ov-btn ov-btn-secondary">${t.cancel}</button>
            <button id="auth-confirm-btn" class="ov-btn ov-btn-primary">${t.confirm}</button>
          </div>
        </div>
      `;
      this.showBottomSheet(html);

      document.getElementById("auth-cancel-btn").onclick = () => {
        this.hide();
        if (onCancel) onCancel();
      };
      document.getElementById("auth-confirm-btn").onclick = () => {
        // We DON'T hide immediately so the user can see it until the native prompt appears
        if (onConfirm) onConfirm();
      };
    },

    confirm(message, options = {}) {
      const { confirmText = "Confirm", cancelText = "Cancel", onConfirm, title = "Confirm" } = options;
      const html = `
        <div class="ov-title">${title}</div>
        <div class="ov-text">${message}</div>
        <div class="ov-btn-row">
          <button id="ov-cancel-btn" class="ov-btn ov-btn-secondary">${cancelText}</button>
          <button id="ov-confirm-btn" class="ov-btn ov-btn-danger">${confirmText}</button>
        </div>
      `;
      this.showModal(html);
      document.getElementById("ov-cancel-btn").onclick = () => this.hide();
      document.getElementById("ov-confirm-btn").onclick = () => {
        if (onConfirm) onConfirm();
        this.hide();
      };
    },

    showImagePickerOverlay(translations = {}) {
      const t = {
        title: translations.photoTitle || 'Select Source',
        camera: translations.camera || 'Camera',
        gallery: translations.gallery || 'Gallery',
        cancel: translations.cancel || 'Cancel'
      };
      const html = `
        <div style="padding: 8px 4px;">
          <div style="font-size: 18px; font-weight: 700; color: var(--ov-on-surface); margin-bottom: 24px; text-align: center;">${t.title}</div>
          
          <div style="display: flex; gap: 16px; margin-bottom: 24px;">
            <div id="source-camera" style="flex: 1; background: var(--ov-divider); padding: 20px; border-radius: 20px; display: flex; flex-direction: column; align-items: center; cursor: pointer; transition: background 0.2s;">
              <div style="font-size: 32px; margin-bottom: 12px;">📸</div>
              <div style="font-size: 14px; font-weight: 600; color: var(--ov-on-surface);">${t.camera}</div>
            </div>
            <div id="source-gallery" style="flex: 1; background: var(--ov-divider); padding: 20px; border-radius: 20px; display: flex; flex-direction: column; align-items: center; cursor: pointer; transition: background 0.2s;">
              <div style="font-size: 32px; margin-bottom: 12px;">🖼️</div>
              <div style="font-size: 14px; font-weight: 600; color: var(--ov-on-surface);">${t.gallery}</div>
            </div>
          </div>

          <button id="picker-cancel" class="ov-btn ov-btn-secondary" style="width: 100%; border-radius: 20px; padding: 14px;">${t.cancel}</button>
        </div>
      `;
      this.showBottomSheet(html, true);

      document.getElementById("source-camera").onclick = () => {
        if (window.flutter_inappwebview) window.flutter_inappwebview.callHandler('sourceAction', 'camera');
        this.hide();
      };
      document.getElementById("source-gallery").onclick = () => {
        if (window.flutter_inappwebview) window.flutter_inappwebview.callHandler('sourceAction', 'gallery');
        this.hide();
      };
      document.getElementById("picker-cancel").onclick = () => {
        if (window.flutter_inappwebview) window.flutter_inappwebview.callHandler('sourceAction', 'cancel');
        this.hide();
      };
    },

    hide(immediate = false) {
      if (!this._isVisible) return;
      const root = this._getContainer();

      const cleanup = () => {
        root.style.display = "none";
        root.innerHTML = "";
        this._isVisible = false;
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler('closeOverlay');
        }
      };

      if (immediate) {
        cleanup();
      } else {
        root.classList.remove("ov-active");
        setTimeout(cleanup, 350);
      }
    }
  };
}