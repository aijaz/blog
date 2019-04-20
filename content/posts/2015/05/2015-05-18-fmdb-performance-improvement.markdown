title: "Performance Improvement with FMDB"
date: 2015-05-17 23:20
comments: false
description: In this post I show you how a simple change in how I wrote my SQL took my execution time from 21 seconds down to 0.12 seconds.
Category: Computers
Tags: FMDB, SQL, Transactions, iOS, Databases

<!-- c /images/2015/05/view@2x.jpg Looking out at Hyderabad -->

When you have to execute SQL statements inside large loops, you may find that your app slows down considerably. In this post I show you one way of improving the performance of your app when database access is the bottleneck.

<!-- more -->

As I've mentioned in earlier posts, I use [FMDB][] for database access in my iOS apps. Recently I needed to do something like this (table names have been changed to protect the innocent): 

    :::objc
    NSInteger nextInvoiceID = 1;
    for (NSDictionary * dictionary in allInvoices) {
        [db executeUpdate:@"INSERT INTO Invoice(id, customerName)"
                           " values (?, ?)", 
                           @(nextInvoiceID), 
                           dictionary[kInvoiceCustomerName]];
        for (NSString * debit in dictionary[kInvoiceDebits]) {
            [db executeUpdate:@"INSERT INTO "
                               " InvoiceDebit(invoiceID, name)"
                               " values(?, ?)", 
                               @(nextContactID), debit];
        }
        for (NSString * credit in dictionary[kInvoiceCredits]) {
            [db executeUpdate:@"INSERT INTO "
                               " InvoiceCredit(invoiceID, name)"
                               " values(?, ?)", 
                               @(nextContactID), credit];
        }
        nextInvoiceID++;
    }

Before I even ran this code, I decided to wrap it up in an ```FMDatabaseQueue``` for thread safety. If I do this everywhere (and I do) I can be assured that I will never have two threads or queues writing to the database at the same time. So, this is what my code looked like: 

    :::objc
    [self.dbq inDatabase:^(FMDatabase *db) {
        NSInteger nextInvoiceID = 1;
        for (NSDictionary * dictionary in allInvoices) {
            [db executeUpdate:@"INSERT INTO Invoice(id, customerName)"
                               " values (?, ?)", 
                               @(nextInvoiceID), 
                               dictionary[kInvoiceCustomerName]];
            for (NSString * debit in dictionary[kInvoiceDebits]) {
                [db executeUpdate:@"INSERT INTO "
                                   " InvoiceDebit(invoiceID, name)"
                                   " values(?, ?)", 
                                   @(nextContactID), debit];
            }
            for (NSString * credit in dictionary[kInvoiceCredits]) {
                [db executeUpdate:@"INSERT INTO "
                                   " InvoiceCredit(invoiceID, name)"
                                   " values(?, ?)", 
                                   @(nextContactID), credit];
            }
            nextInvoiceID++;
        }
    }];

When I execute this code with a dictionary of about 500 Invoices, each with 2 to 4 debits and credits, it takes more than **21 seconds** to execute this query. That is unacceptable. The reason it takes so long is that each ```INSERT``` statement is its own little transaction. There's a lot of overhead in starting and ending each transaction inside that ```for``` loop.

When, instead, I wrap the entire loop in a transaction using ```inTransaction```, the entire loop takes **less than 0.12** seconds to complete. That's a speed increase of above 175 times. This is because I'm no longer incurring the transaction setup and teardown cost for every ```INSERT``` statement. Instead, I'm only incurring it once.

    :::objc
    [self.dbq inTransaction:^(FMDatabase *db, BOOL * rollback) {
        NSInteger nextInvoiceID = 1;
        for (NSDictionary * dictionary in allInvoices) {
            [db executeUpdate:@"INSERT INTO Invoice(id, customerName)"
                               " values (?, ?)", 
                               @(nextInvoiceID), 
                               dictionary[kInvoiceCustomerName]];
            for (NSString * debit in dictionary[kInvoiceDebits]) {
                [db executeUpdate:@"INSERT INTO "
                                   " InvoiceDebit(invoiceID, name)"
                                   " values(?, ?)", 
                                   @(nextContactID), debit];
            }
            for (NSString * credit in dictionary[kInvoiceCredits]) {
                [db executeUpdate:@"INSERT INTO "
                                   " InvoiceCredit(invoiceID, name)"
                                   " values(?, ?)", 
                                   @(nextContactID), credit];
            }
            nextInvoiceID++;
        }
    }];

Moral of the story: Use transactions whenever possible.  

P.S. Also check out ```shouldCacheStatements``` in ```FMDatabase.h```



[FMDB]: https://github.com/ccgus/fmdb