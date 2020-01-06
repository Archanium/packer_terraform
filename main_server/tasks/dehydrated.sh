#!/usr/bin/env bash
set -e

echo "---- dehydrated"


TEMP="$(mktemp)" &&
wget -O "$TEMP" "https://github.com/lukas2511/dehydrated/releases/download/v0.6.5/dehydrated-0.6.5.tar.gz" &&
sudo mkdir -p /etc/dehydrated/ &&
sudo tar xvf "$TEMP" --strip-components=1 --directory=/usr/bin/   dehydrated-0.6.5/dehydrated ;
rm -f "$TEMP"
sudo mkdir -p /var/certs && sudo chown www-data:www-data /var/certs;
sudo mkdir -p /etc/dehydrated/accounts/aHR0cHM6Ly9hY21lLXYwMi5hcGkubGV0c2VuY3J5cHQub3JnL2RpcmVjdG9yeQo/
cat << EOF | sudo tee  /etc/dehydrated/accounts/aHR0cHM6Ly9hY21lLXYwMi5hcGkubGV0c2VuY3J5cHQub3JnL2RpcmVjdG9yeQo/registration_info.json
{
  "id": 46812899,
  "key": {
    "kty": "RSA",
    "n": "5hWl4dREw7LFqvrxQVCbUA-x1m83qN6B8ZLX3iABT8-uhe0noF9a6rmVjlWwKS0oNrpMuzg9FS6gyFlqzWx3g3nVI1XVb9gE4FlzAum-Wuw_DM2SfBxyvW4DqZG77fId_wlBLpbWZYBk0Xq_MPlLLvM9tyaGb8EfmCuKWxpbs8-l2PqhNTpN4U9DF_zDiyyFcoZ0-O6aEgDCmfq3kohkp1wu_U4EAcx1lN0HrDnFtAMzi_Dg1l5nl50F67aCeMHFSX8do_npS_f6x3pOYobY9SJgV5SKeWWlnSRMHOpOe_HXRgjRi2Xgamo3ERSQ-7OateMbOSbsVsL93fftVrFXcf2YvvvWH8poR5Efdq-WYKS_qUJR2Y6BkNiGKZZexAtTfJ7dAEij9c314fXSg02Rf1SpTSPFvwcsTMCoHSVueRWb6vxYYq3ZKhOzh44bwK7PXYfC6gI0enGUNkXFynRrgN2CxnhKSEEbLvVOUv-ZCJ58ILQq7gL6b6JQ-oNGh_XyKyLuvHz5Lwl0t0PPlGJknE_-CeIn-PxbpuZswhQqYZUjNsnAytLzMeWrqendsuORvteAKmCm_gN2ooTYSMQ6i1__vxYUfYq0me8P9NtlsXozExjJlSQ-R7HZ5CDJDFyiTBs1dYmL7w4iDHaNd4yx_zSPOXH52GJX6uu2jQs1G7E",
    "e": "AQAB"
  },
  "contact": [
    "mailto:thomas+ssl@dreamabout.dk"
  ],
  "initialIp": "34.245.171.200",
  "createdAt": "2018-11-30T17:21:41.436051263Z",
  "status": "valid"
}
EOF
cat << EOF | sudo tee /etc/dehydrated/accounts/aHR0cHM6Ly9hY21lLXYwMi5hcGkubGV0c2VuY3J5cHQub3JnL2RpcmVjdG9yeQo/account_key.pem
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----

EOF
sudo chown -R www-data:www-data /etc/dehydrated