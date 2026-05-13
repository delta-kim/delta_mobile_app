
## Login
1. Obtain the login loginSessionId

```js
const ic_options = {
	agentOptions: { host: "https://icp0.io" },
};
const cappCenterCanisterId =  "o4idh-taaaa-aaaam-adthq-cai";
const appId = 18;
const DappCenter = createActor(cappCenterCanisterId, DappCenterFactory, ic_options);
let deviceDesc = "Android, web browser";
//let loginSessionId = await DappCenter.createSubAppAuthSession(deviceDesc, appId); //To be discontinued soon
let accessToken = "XXXXX" // Get it at the bottom of the "App Management" page in the Developer Center.
let loginSessionId = await DappCenter.createSubAppAuthSession2(deviceDesc, appId, accessToken);
```

2. Create App Link and Launch Login

```js
<a href="delta://authorize/${loginSessionId}">Sign in with Delta App</a>

```

3. After clicking the login button, poll the authorization results through loginSessionId

```js

const pollhandle = setInterval(async () => {
let identityTokenOpt = await DappCenter.querySubAppAuthByApp(loginSessionId);
if(identityTokenOpt.length > 0){
    clearInterval(pollInterval);
    let identityTokenObj = identityTokenOpt[0];
    // const accCanisterId = appIdentityToken["accCanisterId"];
    // appIdentityToken
    localStorage.setItem("identityTokenObj", JSON.stringify(identityTokenObj));
}
}, 5000);

```

4. Accessing basic account information

```js
let identityTokenObj = localStorage.getItem("identityTokenObj");
identityTokenObj = JSON.parse(identityTokenObj);
let accCanisterId =  identityTokenObj["accCanisterId"];
let dAppIdentToken = identityTokenObj["dAppIdentToken"];

const Account = createActor(accCanisterId, AccountFactory, ic_options);

let acctInfo = await Account.getDAppAcctInfo(dAppIdentToken, appId);

```

## Dapp Top-up
1. 1. Create a Top-up listen token

```js
let luckyBitCanisterId = "fv2t3-siaaa-aaaam-ain2a-cai"
const LuckyBit = createActor(luckyBitCanisterId,LuckyBitFactory, ic_options);
let coinCode = "USDT";
let amount = 10000;
let listenToken =  await LuckyBit.createTopupListenToken(coinCode, amount, identityTokenObj);

```

2. Create Top-up AppLink and launch
```js
  <a href="delta://dapptopup/?dappId={dappId}&coinCode={coinCode}&amount={amount}&listenToken={listenToken}">Top-up with Delta App</a>

```

3. Confirm receipt (After completing the payment, switch to the web (dapp) and click Execute)
```js
let acct =  await LuckyBit.confirmWalletTopup(listenToken, identityTokenObj);

```





- Other
```js

import { Actor, HttpAgent } from "@dfinity/agent";

export const createActor = (canisterId, idlFactory, options = {}) => {
  const agent = options.agent || HttpAgent.createSync({ ...options.agentOptions });

  if (options.agent && options.agentOptions) {
    console.warn(
      "Detected both agent and agentOptions passed to createActor. Ignoring agentOptions and proceeding with the provided agent."
    );
  }

  if (options.agentOptions.host.startsWith("http://")) {
    console.log("fetchRootKey start");
    agent.fetchRootKey();
  }

  return Actor.createActor(idlFactory, {
    agent,
    canisterId,
    ...options.actorOptions,
  });
};


```