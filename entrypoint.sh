#!/bin/bash

DEBUG="${INPUT_DEBUG}"

if [[ "$DEBUG" == "true" ]]; then
  set -x
fi

# 判断 INPUT_CLONE_STYLE 是否等于 "ssh"，如果不等于则退出
if [[ "$INPUT_CLONE_STYLE" != "ssh" ]]; then
  echo "INPUT_CLONE_STYLE is only support 'ssh'. Exiting script."
  exit 1
fi

mkdir -p /root/.ssh
echo "${INPUT_SRC_KEY}" > /root/.ssh/src_rsa
chmod 600 /root/.ssh/src_rsa

echo "${INPUT_DST_KEY}" > /root/.ssh/dst_rsa
chmod 600 /root/.ssh/dst_rsa

python3 -m venv /hub-mirror/venv
source /hub-mirror/venv/bin/activate
pip3 install -r /hub-mirror/requirements.txt

git lfs install

python3 /hub-mirror/hubmirror.py --src "${INPUT_SRC}" --dst "${INPUT_DST}" \
--dst-token "${INPUT_DST_TOKEN}" \
--account-type "${INPUT_ACCOUNT_TYPE}" \
--src-account-type "${INPUT_SRC_ACCOUNT_TYPE}" \
--dst-account-type "${INPUT_DST_ACCOUNT_TYPE}" \
--clone-style "${INPUT_CLONE_STYLE}" \
--cache-path "${INPUT_CACHE_PATH}" \
--black-list "${INPUT_BLACK_LIST}" \
--white-list "${INPUT_WHITE_LIST}" \
--static-list "${INPUT_STATIC_LIST}" \
--force-update "${INPUT_FORCE_UPDATE}" \
--debug "${INPUT_DEBUG}" \
--timeout  "${INPUT_TIMEOUT}" \
--mappings  "${INPUT_MAPPINGS}" \
--lfs "${INPUT_LFS}"

# Skip original code
exit $?
