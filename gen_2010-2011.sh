function clean_data() {
    iconv -f cp936 -c -t utf-8 $1 | perl -p -e 's/\|#\|/|#|\n/g'
}

function dispatch_maps() {
    awk -v DIR=result \
        'BEGIN {
            getline
            total = $1
            user1 = $2
            user2 = $3
            year = $4
            month = $5
            printf "%s,%s,%s\n", user1, user2, total  >DIR"/"year"/maps/month"month
        }

        {
            printf "%s,%s,%s\n", $2, $3, $1 >DIR"/"$4"/maps/month"$5
            if ($2 == user1 && $3 == user2 && $4 == year)
                total += $1
            else {
                printf "%s,%s,%s\n", user1, user2, total >DIR"/"year"/maps/year"
                user1 = $2
                user2 = $3
                year = $4
                total = $1
            }
        }
        END { printf "%s,%s,%s\n", user1, user2, total >DIR"/"year"/maps/year" }
        '
}

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

# generate maps
clean_data roller_comment.txt | awk \
    'BEGIN{FS = "\\|!\\|"}; NF==13{print $2, $12, $6}' > extract_comments.txt

awk 'BEGIN{RS="\\|#\\|";FS="\\|!\\|"};NF==28 {print $1, $2}' \
    roller_weblog_entry{,_{1,2,3}}.txt > extract_weblogs.txt

mkdir -p result/{2010,2011}/maps

python3 convert_to_user_id.py | \
    python3 convert_to_login_name.py | \
    sort -k 1 -k 2 -k 3 -k 4 | uniq -c | dispatch_maps 

# generate posts
mkdir -p result/{2010,2011}/{comments,posts,weblogs}

python3 convert_to_user_id.py | python3 convert_to_login_name.py | \
    awk '{print $1, $3, $4}' | sort -k 1 -k 2 -k 3 > result/comments.txt
uniq -c result/comments.txt | dispatch_posts comments

awk 'BEGIN{RS="\\|#\\|";FS="\\|!\\|"};NF==28 {print $2, $6}' \
    roller_weblog_entry{,_{1,2,3}}.txt | \
    python3 id_to_loginname.py |  sort -k 1 -k 2 -k 3 > result/weblogs.txt
uniq -c result/weblogs.txt | dispatch_posts weblogs

sort -k 1 -k 2 -k 3 -m result/{weblogs,comments}.txt > result/posts.txt
uniq -c result/posts.txt | dispatch_posts posts 
