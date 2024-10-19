import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  // VU数: 仮想ユーザー
  stages: [
    { duration: "15s", target: 15 }, // 15秒かけてでVU数を0から15まで徐々に増加
    { duration: "30s", target: 15 }, // 10秒間、VU数を15で維持
    { duration: "15s", target: 0  }, // 15秒かけて、VU数を15から0まで徐々に減少
  ],
};

export default function () {
  let res = http.get("http://nginx:80/");
  check(res, { "status was 200": (r) => r.status == 200 });
  sleep(1)
}
