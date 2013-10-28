import csv
import os
import sys
import pickle

staff_blog_id = {}

if os.path.exists("staff_blog_id_map.pkl"):
    with open("staff_blog_id_map.pkl", "rb") as f:
        staff_blog_id = pickle.load(f)
else:
    with open("staff.csv") as f:
        staffs = csv.reader(f)
        for row in staffs:
            if len(row) >= 4 and row[3].strip():
                    staff_blog_id[row[3]] = row[1]

    with open("depart.csv") as f:
        staffs = csv.reader(f)
        for row in staffs:
            if len(row) == 3 and row[0] not in staff_blog_id:
                staff_blog_id[row[0]] = row[1]

    with open("staff_blog_id_map.pkl", "wb") as f:
        pickle.dump(staff_blog_id, f)

for l in sys.stdin:
    user_id, datetime, *_ = l.split()
    year, month, *_ = datetime.split('-')
    month = "{:02}".format(int(month))
    if user_id in staff_blog_id:
        user = staff_blog_id[user_id]
    else:
        user = user_id
    print(user, year, month)
