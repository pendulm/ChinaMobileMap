entry_user_dict = {}

with open("extract_weblogs.txt") as f:
    for l in f:
        entry, user = l.split()
        entry_user_dict[entry] = user


with open("extract_comments.txt") as f:
    for l in f:
        entry, user, date, _ = l.split()
        year, month, day = date.split('-')
        if entry in entry_user_dict:
            print(user, entry_user_dict[entry], year, month)


