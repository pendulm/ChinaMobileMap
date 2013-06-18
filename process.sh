DIR=${1%%/}
year=${DIR##hakm_teamblog_}
# cat sql1.txt |sqlite3 $DIR/db > $DIR/result.txt
mkdir -p $DIR/data
# awk -f dispatch.awk -v DIR=$DIR $DIR/result.txt

cat sql1.txt |sqlite3 $DIR/db | awk -f dispatch.awk -v DIR=$DIR
mkdir -p archives
tar -cvf - "$DIR/data" | gzip > "archives/$year.tar.gz"

