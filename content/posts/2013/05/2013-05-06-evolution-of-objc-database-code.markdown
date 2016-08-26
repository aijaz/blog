---
title: "Evolution of Objective C Database Code"
date: 2013-05-06 23:02
comments: false
Category:
- Computers
tags:
- ObjectiveC
- ARC
- FMDB
- SQLite3
- SQL
- QuranMemorizer
- Literals
---

## First

One of the features of [Qur'an Memorizer](http://quranmemorizer.com), my
first iOS app, is the ability to highlight a verse (ayah) when it's
tapped.  To do this I access a database of verse x and y locations and
retrieve the 4 coordinates I need to draw the resulting polygon.

The first version of the code released to the App Store looked a little
bit like this:

<!-- more -->

    :::objc
    - (AyahInfo *) clickedAyahForPoint:(CGPoint)point forPage:(int)page inMushaf:(int)mushaf {
        int y = (int)point.y;
        int x = (int)point.x;
        int ayahNum = 0;
        int x1, y1, y1p, x2, y2, y2p;
    
        char * c_vloc = 
            "SELECT ayahNumber, x1, y1, y1p, x2, y2, y2p                         "
            "FROM qmAyahInfo                                                     "
            "WHERE    mushaf=?                                                   "
            "     AND page=?                                                     "
            "     AND (                                                          "
            "           (y1p < y2p AND x1 < ? AND x2 <= ? AND y1 >= ? AND y2 > ?)"
            "           OR                                                       "
            "           (  (y1p >= y2p)                                          "
            "              AND                                                   "
            "              (  (y1 <= ? AND y1p < ? AND x1  > ?)                  "
            "                 OR                                                 "
            "                 (y2 > ? AND y2p <= ? AND x2 >= ?)                  " 
            "                 OR                                                 "
            "                 (y1p >= ? AND y2p > ?)                             "
            "              )                                                     "
            "           )                                                        "
            "         )                                                          ";
    
            sqlite3_stmt * stmt;
            int error = sqlite3_prepare_v2(database, c_vloc, -1, &stmt, NULL);
            if (error == SQLITE_OK) { 
                    
            sqlite3_bind_int(stmt, 1, mushaf);
            sqlite3_bind_int(stmt, 2, page);
            
            sqlite3_bind_int(stmt, 3, x);
            sqlite3_bind_int(stmt, 4, x);
            sqlite3_bind_int(stmt, 5, y);
            sqlite3_bind_int(stmt, 6, y);
            
            sqlite3_bind_int(stmt, 7, y);
            sqlite3_bind_int(stmt, 8, y);
            sqlite3_bind_int(stmt, 9, x);
            
            sqlite3_bind_int(stmt, 10, y);
            sqlite3_bind_int(stmt, 11, y);
            sqlite3_bind_int(stmt, 12, x);
            
            sqlite3_bind_int(stmt, 13, y);
            sqlite3_bind_int(stmt, 14, y);
             
        }
        else {
            // handle error
        }
    
        if (sqlite3_step(stmt) == SQLITE_ROW) { 
            ayahNum = sqlite3_column_int(stmt, 0);
            x1 = sqlite3_column_int(stmt, 1);
            y1 = sqlite3_column_int(stmt, 2);
            y1p = sqlite3_column_int(stmt, 3);
            x2 = sqlite3_column_int(stmt, 4);
            y2 = sqlite3_column_int(stmt, 5);
            y2p = sqlite3_column_int(stmt, 6);
            sqlite3_finalize(stmt);
            
            AyahInfo * ayahInfo = [[AyahInfo alloc] initWithAyahNumber:ayahNum x1:x1 y1:y1 y1p:y1p x2:x2 y2:y2 y2p:y2p];  // client should release
            return ayahInfo;
        }
        sqlite3_finalize(stmt);
        return nil;
    }

## Later

Some time later I learned about [FMDB](https://github.com/ccgus/fmdb),
which is a wrapper around the sqlite3 C functions.  This simplified my
code by adding a layer of abstraction.  It was better, but still more
verbose than I would have liked,
because the methods involved need NSNumbers instead of regular
```int```s:

    :::objc
    - (AyahInfo *) clickedAyahForPoint:(CGPoint)point forPage:(int)page inMushaf:(int)mushaf {
        NSString * sql =
           @"SELECT ayahNumber, x1, y1, y1p, x2, y2, y2p                         "
            "FROM qmAyahInfo                                                     "
            "WHERE    mushaf=?                                                   "
            "     AND page=?                                                     "
            "     AND (                                                          "
            "           (y1p < y2p AND x1 < ? AND x2 <= ? AND y1 >= ? AND y2 > ?)"
            "           OR                                                       "
            "           (  (y1p >= y2p)                                          "
            "              AND                                                   "
            "              (  (y1 <= ? AND y1p < ? AND x1  > ?)                  "
            "                 OR                                                 "
            "                 (y2 > ? AND y2p <= ? AND x2 >= ?)                  " 
            "                 OR                                                 "
            "                 (y1p >= ? AND y2p > ?)                             "
            "              )                                                     "
            "           )                                                        "
            "         )                                                          ";
        int y = (int)point.y;
        int x = (int)point.x;
        int ayahNum = 0;
        int x1, y1, y1p, x2, y2, y2p;
    
        FMResultSet * rs = [_db executeQuery:sql,
                            [NSNumber numberWithInt: mushaf],
                            [NSNumber numberWithInt: page],
    
                            [NSNumber numberWithInt: x],
                            [NSNumber numberWithInt: x],
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: y],
    
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: x],
    
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: x],
    
                            [NSNumber numberWithInt: y],
                            [NSNumber numberWithInt: y]
                            ];
     
        if ([rs next]) {
            ayahNum = [rs intForColumnIndex:0];
            x1 = [rs intForColumnIndex:1];
            y1 = [rs intForColumnIndex:2];
            y1p = [rs intForColumnIndex:3];
            x2 = [rs intForColumnIndex:4];
            y2 = [rs intForColumnIndex:5];
            y2p = [rs intForColumnIndex:6];
            
            QMBVAyahInfo * ayahInfo = [[QMBVAyahInfo alloc] initWithAyahNumber:ayahNum x1:x1 y1:y1 y1p:y1p x2:x2 y2:y2 y2p:y2p];
            return ayahInfo;
        }
        return nil;
    }

## Now

Now, with the introduction
of [Objective C literals and Boxed Expressions](http://clang.llvm.org/docs/ObjectiveCLiterals.html),
it looks like this.  So much nicer.  Moral of the story: Take the time to
learn new technologies and constructs.   They could help you simplify your
code greatly.

    :::objc
    - (AyahInfo *) clickedAyahForPoint:(CGPoint)point forPage:(int)page inMushaf:(int)mushaf {
        NSString * sql =
           @"SELECT ayahNumber, x1, y1, y1p, x2, y2, y2p                         "
            "FROM qmAyahInfo                                                     "
            "WHERE    mushaf=?                                                   "
            "     AND page=?                                                     "
            "     AND (                                                          "
            "           (y1p < y2p AND x1 < ? AND x2 <= ? AND y1 >= ? AND y2 > ?)"
            "           OR                                                       "
            "           (  (y1p >= y2p)                                          "
            "              AND                                                   "
            "              (  (y1 <= ? AND y1p < ? AND x1  > ?)                  "
            "                 OR                                                 "
            "                 (y2 > ? AND y2p <= ? AND x2 >= ?)                  " 
            "                 OR                                                 "
            "                 (y1p >= ? AND y2p > ?)                             "
            "              )                                                     "
            "           )                                                        "
            "         )                                                          ";
        int y = (int)point.y;
        int x = (int)point.x;
        int ayahNum = 0;
        int x1, y1, y1p, x2, y2, y2p;
    
        FMResultSet * rs = [_db executeQuery:sql, @(mushaf), @(page),
                            @(x), @(x), @(y), @(y),
                            @(y), @(y), @(x),
                            @(y), @(y), @(x),
                            @(y), @(y)
                            ];
     
        if ([rs next]) {
            ayahNum = [rs intForColumnIndex:0];
            x1 = [rs intForColumnIndex:1];
            y1 = [rs intForColumnIndex:2];
            y1p = [rs intForColumnIndex:3];
            x2 = [rs intForColumnIndex:4];
            y2 = [rs intForColumnIndex:5];
            y2p = [rs intForColumnIndex:6];
            
            QMBVAyahInfo * ayahInfo = [[QMBVAyahInfo alloc] initWithAyahNumber:ayahNum x1:x1 y1:y1 y1p:y1p x2:x2 y2:y2 y2p:y2p];
            return ayahInfo;
        }
        return nil;
    }

