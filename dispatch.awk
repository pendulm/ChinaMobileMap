BEGIN { 
    FS="|"
    getline
    user1 = $1
    user2 = $2
    total = $4
    print $1, $2, $4 >DIR"/data/month"$3
}

{
    print $1, $2, $4 >DIR"/data/month"$3
    if ($1 == user1 && $2 == user2)
        total += $4
    else {
        print $1, $2, total >DIR"/data/year"
        user1 = $1
        user2 = $2
        total = $4
    }
}

END { print $1, $2, total >DIR"/data/year" }
