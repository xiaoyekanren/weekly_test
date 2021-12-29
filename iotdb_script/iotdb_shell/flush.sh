DIR="$( cd "$( dirname "$0"  )" && pwd  )"
. $DIR/env.sh
start-cli.sh -e "flush"
if [ "$?" != 0 ]; then
  echo "flush failed."
else
  echo "flush successed."
fi

