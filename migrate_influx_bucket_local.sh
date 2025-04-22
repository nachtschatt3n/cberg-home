#!/bin/bash

# === CONFIGURATION ===
SRC_HOST="https://influx.mathiasuhl.com"
SRC_ORG="cberg"
SRC_BUCKET="iobroker"
SRC_TOKEN="Nv1orc3Zg1wen9lIqMWkrOfNeyteadCXv5bWH-me7jQxstk95UvxeVkSQ1Bi6JJMw4aqpPBK6ICDWrSPYN8UMg=="

DST_HOST="https://influx.uhl.cool"
DST_ORG="cberg"
DST_BUCKET="iobroker"
DST_TOKEN="QYK1sqsHDBB2-fyZCT1H-YhQMutpEyDL2E7tB6NqOEcYZDsYQrQP-Lzjibj-LTK8WfDw2SUMamWBSxIg3IzpsA=="

echo "🔄 Migrating data from '$SRC_BUCKET' at $SRC_HOST to '$DST_BUCKET' at $DST_HOST..."
influx query \
  --org "$SRC_ORG" \
  --host "$SRC_HOST" \
  --token "$SRC_TOKEN" \
  --raw '
from(bucket: "'"$SRC_BUCKET"'")
  |> range(start: -100y)
  |> to(
    host: "'"$DST_HOST"'",
    org: "'"$DST_ORG"'",
    bucket: "'"$DST_BUCKET"'",
    token: "'"$DST_TOKEN"'"
  )' || { echo "❌ Migration failed. Aborting."; exit 1; }

echo "✅ Migration completed successfully."