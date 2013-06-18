# coding: utf-8
from __future__ import print_function
import sqlite3

class DBWrapper(object):
    def __init__(self, dbfile):
        self.mark = 1
        self.count = 1
        self.conn = sqlite3.connect(dbfile)
        self.cur = self.conn.cursor()

    def executescript(self, sql):
        self.cur.executescript(sql)
        self.mark = 1
        self.count = 1

    def execute(self, sql, tuple_val):
        self.cur.execute(sql, tuple_val)
        if self.mark == 2000:
            self.conn.commit()
            self.mark = 1
            print("%d" % self.count)
        else:
            self.mark += 1
        self.count += 1

    def commit(self):
        self.conn.commit()

def get_month(time):
    return time.split("-")[1]

def fill_comment(fname, db):
    db.executescript("""
        create table if not exists roller_comment (
            blog_id,
            commenter_name,
            month,
            val
        );
    """)
    for l in open(fname):
        blog_id, commenter_name, time, val = l.split()
        month = get_month(time)
        db.execute("insert into roller_comment values (?, ?, ?, ?)", (
            blog_id, commenter_name, month, val))


def fill_weblog(fname, db):
    db.executescript("""
        create table if not exists weblogentry (
            publisher_id,
            crew_id,
            blog_id,
            month,
            val
        );
    """)
    for l in open(fname):
        publisher_id, crew_id, blog_id, time, val = l.split()
        month = get_month(time)
        db.execute("insert into weblogentry values (?, ?, ?, ?, ?)", (
            publisher_id, crew_id, blog_id, month, val))


def fill_user(fname, db):
    db.executescript("""
        create table if not exists user (
            login_name,
            publisher_id
        );
    """)
    for l in open(fname):
        l = l.decode('utf-8')
        _, login_name, _, publisher_id, _ = l.split(',')
        db.execute("insert into user values (?, ?)", (
            login_name, publisher_id))


if __name__ == "__main__":
    year = 2012
    dir_name = 'hakm_teamblog_%d/' % year
    dbname = 'db'
    db = DBWrapper(dir_name + dbname)
    fill_weblog(dir_name + 'weblogentry_%d.strip' % year, db)
    print("finish insert weblog")
    fill_comment(dir_name + 'roller_comment_%d.strip' % year, db)
    print("finish insert comment")
    fill_user("origin_data/name_and_blog_id.csv", db)
    print("finish insert user")
    db.commit()

