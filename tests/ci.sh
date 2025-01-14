#!/usr/bin/env bash
set -o errexit
set -o nounset
cd "$(dirname "$0")"

perl config.pl --force --architecture "$ARCH" \
               --cluster-path "$CLPATH" --cluster-name "$CLNAME" \
               --db-type "$DBTYPE" --db-version "$DBVERSION" \
               --docker-image "$DOCKERI" --extra-vars "$EXTRA_VARS"
sed -i "s/pg1/$CLNAME-1/g" "$CLPATH/$CLNAME/config.yml"
sed -i "s/pg2/$CLNAME-2/g" "$CLPATH/$CLNAME/config.yml"
sed -i "s/pg3/$CLNAME-3/g" "$CLPATH/$CLNAME/config.yml"
sed -i "s/bck-host/$CLNAME-bck/g" "$CLPATH/$CLNAME/config.yml"
echo "ACTIVITY = '$ACTIVITY'"
export ACTIVITY=$ACTIVITY
echo "RUN_ARGS = '$RUN_ARGS'"
sh run.sh -c "$CLPATH/$CLNAME" "$RUN_ARGS"
