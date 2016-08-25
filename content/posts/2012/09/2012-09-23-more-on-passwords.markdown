---
title: "More on Passwords"
date: 2012-09-24 06:00
comments: false
Category:
- Computers
tags: 
- Security
- Passwords
- bcrypt
- Hashes
- SecondConf
description: There were some great discussions and questions following my recent Blitz Talk at SecondConf. I summarize them in this post.
---

After my [recent Blitz Talk at SecondConf](/2012/09/22/protecting-your-users-privacy/) I had
some great conversations with fellow attendees in the meal lines and around the beverage
table.  I'm presenting them here for further discussion.  

<!-- more -->

---

**You say to hash the email. How would you send out emails, then?**

If you need to send out emails when the user is logged in, and if the user's email address
is the login 'id', then you can save the cleartext email address in the session when the
user logs in successfully.  Then, when the session expires, you delete the email from the
session data structure or table.

If, on the other hand, you need send out emails when the user *isn't* logged in, the way
sites like Amazon and eBay do, then you're gonna have to store the email in a way in which
you can read it later.  You don't *have* to store it cleartext; you could encrypt it and
store the encrypted value.  Encryption is different from hashing because with encryption
you can get back to the original text (the email address).  By definition, you can't do
that with a hash.

What you *shouldn't* ever do is use your hash salt as an encryption key. The reason is that
hash salts are well known and should not be hidden.  In contrast, encyption keys are supposed
to be secret.  If you use a hash salt as an encryption key, you're effectively storing your
data in cleartext.  

At some point you have to store some valuable information in your database - your system
will always do more than provide a secure login and password.  Hashes will not absolve you
of the need to engage in secure data storage practices.

---

**As a user is there anything you can do to tell if a site is secure?**

Unfortunately, no.  The best you can do is ask the site's owners. You may or may not get a
satisfactory answer; the people best qualified to answer that question may not be
management or customer support, or even technical support.  The people who can answer best
may be the developers.

I do not recommend trying to determine this on your own by hunting for weaknesses in
websites -- that might be punishable by law.

---

**That rehashing stuff is cool! You can just automatically increase the strength of your users' hashes every year!**

I know, right?  But hold on: you can't have your system automatically increase the
strength of everyone's password as a batch job. You can only do it when the user logs in
successfully.  That's the only time you as a system know (and ought to know) the user's
password.  The only opportunity you have to do the rehashing is during the login process
before sending the user a successful HTTP response.

Do *NOT* try to be efficient here by saving the cleartext password in an on-file queue for
processing so that you can return back to user as soon as possible.  Saving the cleartext
password on file should be forbidden for *any* reason.

---

**When you said use a salt, and make sure it's random, is that now a two step process? Generate a random system salt, and use that for the password hashes?**

Oh, no no no.  You use a different random salt for every hash.  You really don't need to
worry about it too much - most good hash generating functions will generate a random salt
for you. In fact, in most cases you have to go out of your way to use the same salt for every hash.

For example, here's how you hash a password using PostgreSQL:

    myDb=> SELECT crypt('mySuperPassword', gen_salt('bf', 10));
                                crypt                             
    --------------------------------------------------------------
     $2a$10$G3dJM9XGFHuUTDOKu8bk.eCB1fl0cWiLOKkRBFQOv6tAtxxNtAjrW
    (1 row)
    
    myDb=>

In the example above, the password is ```mySuperPassword```, the hash is bcrypt (as
specified by ```bf``` and the hash strength is ```10```.  Since I use PostgreSQL as a
backend database, its native support for bcrypt makes hash generation and later
strengthening very easy.

## Thanks

I would like to thank SecondConf for giving me the opportunity to speak.  I would also
like to thank the volunteers who helped make this event such a resounding success.
Finally, I would like to thank all the people who came over to me afterwards for their
kind words and engaging conversation.  I'm very happy to be part of this community.
