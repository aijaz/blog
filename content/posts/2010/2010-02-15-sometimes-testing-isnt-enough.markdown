comments: false
date: '2010-02-15 01:41:07'
slug: sometimes-testing-isnt-enough
title: Sometimes Testing Isn't Enough
Category: Computers
Tags: Apple, Buzz, Google, iPad, My Software, Privacy, Services, SMS, Testing, Usability, Virgin Mobile

<!-- ai l /wp/IMG_7679.jpg /wp/IMG_7679-170x170.jpg 170 170 A bee.  Buzzing.  -->

In the first few days after the release of [Google Buzz](http://www.google.com/buzz) many people (including myself) criticized
Google for [exposing their users' private information](http://www.businessinsider.com/warning-google-buzz-has-a-huge-
privacy-flaw-2010-2).  This was a couple of weeks after Apple got a lot flak
for their unfortunately-named iPad, and the same week that we heard
[reports](http://www.winnipegfreepress.com/local/built-in-text-messages-ruined-life-says-city-man-83622857.html) of a woman who broke up with her
boyfriend after finding some suggestive text messages on his cell phone -
messages that came pre-loaded on the phone.  I think that all these cases were
not caused by a lack testing, but by testing the wrong audience.  Let's
examine these three cases and see what we can learn from them:
<!-- more -->

#### Google Buzz

Almost immediately after Google started rolling out Buzz to its Gmail clients
various blogs reported that there was an egregious flaw in the system that
exposed people's private contacts to the rest of the world.  When a Gmail user
logged in, they were presented with a dialog box that asked them if they
wanted an introduction to Buzz or not.  If the user declined, it didn't mean
that Buzz was disabled - it only meant that they didn't want the intro.  What
Google did behind the scenes was that they scanned the user's emails and
collected the emails of the people with whom the user corresponded most often.
Then, it automatically modified the user's Gmail account to 'follow' those
people in Buzz.

But here's the thing that infuriated most people - it made that list of the
people that user's following public: Anyone who looked at the user's public
Google profile could see who that person was following.  In other words,
anyone looking at that user's public profile could see who that user emailed
most often.

Now pretend you're a reporter who's communicating with dissidents in Myanmar
or Iran.  Would you want your heretofore anonymous sources made public?  [In one reported case](http://techcrunch.com/2010/02/12/google-buzz-privacy/), a
woman's most frequent contacts were her boyfriend and her mother.  Her third-
most-frequent contact (with a lot fewer emails) was her abusive ex-husband,
from whom she had kept her email address hidden.  But what Google did when
they released Buzz is automatically have her follow her ex, and share her
shared Google Reader messages, including her location and workplace with her
ex.

[Another blogger reported](http://news.cnet.com/8301-31322_3-10451428-256.html) that her
Android phone uploaded to her public profile a photo that she had taken, but
not uploaded. She thought her photo was private, but Google's assumption was
that if the photo was on her phone, it would be okay to upload it to her
public profile.

[The third problem](http://techcrunch.com/2010/02/11/reply-google-buzz-exposing-email/) that surfaced in the two days after Buzz was released was
that in some cases users thought that they were referencing a person's public
email address in a buzz (think of it as a retweet or a reply) but in reality
were referencing a private email address.  When they selected a person by
their name, it wasn't clear which email address was linked to that name.  For
example, if John Smith's public email address is john_smith@example.com, and
his personal address is js_123@example.com, and the public address is
associated with a Google profile, a Buzz user may inadvertently select the
private email address in a buzz, thus exposing John's private address to
everyone he follows.

#### The iPad

In the minutes after Apple's Steve Jobs announced the new mobile appliance's
name, people started making very funny, original and sometimes vulgar jokes
about the name iPad.  I could post them here, but the jokes are old by now.

#### Salacious Texts On Samsung Virgin Mobile Phones

According to [this article](http://www.winnipegfreepress.com/local/built-in-text-messages-ruined-life-says-city-man-83622857.html), a 49 year old man from
Winnipeg can no longer have a relationship with the woman he loved because she
accused him of cheating on him.  Her proof?  Sexy text messages on his cell
phones.  He denied the affair, but couldn't explain how they got there.  Only
later did he learn that the messages were pre-loaded by Virgin Mobile.

#### What Do These Cases Have in Common?

As an outsider it appears to me that in each of the three cases the problem
was that the population for whom the system was designed wasn't necessarily
the only population actually using the system.  Let's look at the Google Buzz
case.  If we claim that Google is neither evil nor stupid, what went wrong?  I
think there were several assumptions that the Google developers and designers
made that were incorrect.

Buzz seemed to have be designed for people who collaborate together in tightly
knit groups.  The assumption is that people who want to share information with
each other communicate a lot with each other.  In real life that isn't always
true, and neither is the converse.  In many cases the people that I want to
share the most with are people with whom I have so many channels of
communication (including the dinner table) that any single channel like email
contains a fraction of the actual communication taking place.  Similarly, as
in the case of the lady who was hiding her online identity from her ex, the
people we communicate with aren't always the people we want to share
information with.  If Google's designers approached their product with that
bias, they could have made (and did make) a technically excellent product that
worked as they intended, and whose test cases passed, but which did exactly
the wrong thing.

I think that that's essentially the core problem with the issue of the
publication of private photos and email addresses.  The joke in the blogs was
that Buzz was designed for an people like engineers at Google, not for people
who go to parties and take pictures that they would regret the next morning
(and I know they're not mutually exclusive groups).  Unlike in the business
world and the networks of sites like LinkedIn, people sometimes guard their
email addresses jealously and do not want them published without their
authorization.

I am certain Google tested their application thoroughly.  They've been known
to do extensive usability tests for the seemingly tiniest of changes to their
web site.  But even the most well-implemented tests are incomplete if they're
not performed on a statistically representative sample of the audience.

The same can be said for Apple and Virgin Mobile.  On of the most insightful
questions asked after the iPad announcement was, "Did Apple not have any women
on the product naming committee?"  Did Virgin Mobile think that their only
consumers would be teenagers who would find the default text messages cute and
funny and have the technical expertise to realize that these messages were
pre-loaded?  While Apple seemed to have failed to consider about half of the
human race while naming their product, Virgin failed to consider the less
savvy part of the population who are their customers.

What I don't know is this: Let's assume I'm wrong, and that in all three cases
a statistically-representative portion of the population was tested or
considered.  If that's true, then could these three cases be considered edge
conditions?  While a problem could exist in theory could the actual problems
be so few that they're statistically insignificant?  If you're the person
whose lost a relationship or now have to worry about being stalked by an ex it
doesn't really matter.  It's affected your life in a significant way.

#### What Can Software Developers Learn From This?

I don't think anyone or any company (not even Google) can make the perfect
application that pleases everyone.  But I think that there are a few rules of
thumb that we should follow, to prevent embarrassing and distressing problems.

First: Applications like these should not take action on behalf of the user.
The system should assume that the user always knows what's best for them.  The
most the program should do is make suggestions that the user can then decide
to obey or ignore.  This is exactly what Google did (among other things) to
change Buzz after the huge public outcry.

Second: Features, no matter how well-intentioned, no should never be opt-out.
They should always be opt-in.  Buzz was essentially an opt-out system.  You
could be vulnerable by not doing anything. It isn't that way now, but it was
for those two days when Google's reputation took a massive hit.

Third: Designers and service providers need to pay careful attention to who
their users actually are.  They're not necessarily men, not necessarily tech-
savvy teens or professionals looking to increase their network.  They could
include people very different from us.

As developers and designers we need to realize that the products we make will
be used in manners that we never imagined, by people who we don't understand.
If we give our customers the ability to control how our products and services
are used, we'll be helping them and thus helping ourselves.
