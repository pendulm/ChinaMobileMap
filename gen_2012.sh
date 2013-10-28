function dispatch_posts() {
    awk -v DIR=result -v POSTS=$1 \
        'BEGIN {
            getline
            total = $1
            user = $2
            year = $3
            month = $4
            printf "%s,%s\n", user, total >DIR"/"year"/"POSTS"/month"month
        }

        {
            printf "%s,%s\n", $2, $1 >DIR"/"$3"/"POSTS"/month"$4
            if ($2 == user && $3 == year)
                total += $1
            else {
                printf "%s,%s\n", user, total >DIR"/"year"/"POSTS"/year"
                user = $2
                year = $3
                total = $1
            }
        }

        END { printf "%s,%s\n", user, total >DIR"/"year"/"POSTS"/year" }'
}

# awk 'BEGIN{RS="\\|\\*\\|";FS="\\|!\\|"}
    # NF==5 {
        # split($4, a, "-");
        # print $2, a[1], a[2];
        # 
    # }' roller_comment_2012.txt | sort -k 1 -k 2 -k 3 > comments_2012.txt

# awk 'BEGIN{RS="\\|\\*\\|";FS="\\|!\\|"}
    # NF == 7 {
        # split($6, a, "-");
        # printf "%s %s %s", $1 , a[1], a[2];
    # }' weblogentry_2012.txt | sort -k 1 -k 2 -k 3 | \
# python3 -c '
# import csv
# import os
# import sys
# import pickle

# with open("staff_blog_id_map.pkl", "rb") as f:
    # staff_blog_id = pickle.load(f)

# for l in open("result/weblogs_2012.txt"):
    # user_id, year, month = l.split()
    # if user_id in staff_blog_id:
        # user = staff_blog_id[user_id]
    # else:
        # user = user_id
    # print(user, year, month)
# ' > result/weblogs_2012.txt
mkdir -p result/2012/{comments,posts,weblogs}
uniq -c result/comments_2012.txt | dispatch_posts comments
uniq -c result/weblogs_2012.txt | dispatch_posts weblogs
sort -k 1 -k 2 -k 3 -m result/{weblogs,comments}_2012.txt | \
    uniq -c | dispatch_posts posts 
