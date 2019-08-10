while getopts ":d:f:x" opt; do
  case $opt in
    d)
      DEST=$OPTARG
    f)
      FILES=$OPTARG
      ;;
    x)
      FUNC=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

cd src

for FILE in $FILES;
do
 zip -g $FILE $DEST
 echo "FILE_NAME: $FILE"
done

aws lambda update-function-code --function-name $FUNC --zip-file fileb://$DEST
aws lambda update-function-configuration --function-name refresh-fixtures-func --environment Variables="{GFG_ENV=prod, FOOTBALL_API_KEY=${FOOTBALL_API_KEY}}"

rm $DEST
exit 0