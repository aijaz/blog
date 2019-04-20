comments: false
date: '2010-04-01 23:02:41'
slug: communicating-during-a-crisis
title: Communicating During A Crisis
Category: Computers
Tags: Communication, Crisis, Delegation, DNS, Honesty, iPhone, Leadership, Management, Pogue

A few day ago the data center where I used to host my name servers lost its
connection to the Internet for a very long time (almost 36 hours).   Whatever
the cause, the web, mail and application servers of customers big and small
were dead in the water.  There was no way to reach them via the Internet.  The
data center's owner, who's a friend of mine, was on the phone with his service
providers, getting the issue sorted out.  In the first 24 hours I sent him
around five text messages and was able to speak with him a couple of times.
However, many of his other clients couldn't reach him, and some of them even
called me asking if I knew what was going on.
<!-- more -->

Also that week, many of us heard of Line2, an app for the iPhone that allows
you to make calls using WiFi and bypassing AT&T.  After New York Times
columnist David Pogue [wrote about it](http://www.nytimes.com/2010/03/25/technology/personaltech/25pogue.html),
hundreds of readers went to the iTunes store to download the app, only to find
it missing.  Soon after, Pogue received hundreds of angry emails blaming him
for bringing the app to Apples attention, saying that Apple pulled the app.
After some investigative work [Pogue found out](http://pogue.blogs.nytimes.com/2010/03/27/why-the-line-2-app-is-up-and-down/) that it was the app developers themselves who pulled the app off the
iTunes store in response to a denial of service attack - automated sign-ups.
In that article's comments, Pogue noted that a lot of the finger pointing
could have been averted if the developers simply mentioned on their website
that they had pulled the app while they worked on the denial of service
attack.

<!-- ai l /wp/question.png /wp/question.png 204 140 -->
These episodes got me thinking about
the importance of communicating with clients during a crisis.  Most
individuals and businesses that I'm familiar with have very well-planned
procedures in the case of fire or building evacuation.  But that's seldom the
case with digital crises like internet access outages or denial of service
attacks.

[This article](http://www.ehow.com/how_15981_communicate-during-crisis.html)
on ehow.com has some good instructions on how to communicate during crises.
My own advice is to pay attention to the key questions:

###How

Have a plan that specifies how you will communicate with clients, especially when your normal means of communication are not available.  In the case of my friend, he couldn't email his clients, or even update his own website.  I think the best thing he could have done to prepare for this would be to have one name server at a competitor's data center, and have that name server be one of those responsible for his domain.  As his clients noticed their own sites were down, the next thing most of them would do (as I did) is check the website of the data center.  With a couple of quick commands, he could redirect his domain to a static web page that would give clients the information they need.  If that were planned in advance, this entire setup could be arranged for about $6 to $10 per month.  Not bad at all.

###Who

Identify what needs to be done to open the channels of communication during a crisis and assign your staff specific roles.  If you're the president of the company you may be too busy working behind the scenes calling in favors or negotiating with counterparties.  Again, in my friend's case, while he's on the phone calling his vendors, a member of his staff could be  running to the local Starbucks coffee shop with a laptop and logging in to the name server on their competitor's network and changing their DNS records. And then staying there for updates that need to be relayed to the clients.

###When

During a crisis, the most stressful thing for clients is 'radio silence.'  Sometimes it's inevitable that there will be nothing new to report for long periods of time.  Even then, let your clients know that there is nothing new to report.  Depending on the business, and the nature of the crisis,  the frequency of updates could be anywhere from five minutes to a few hours.

###What

This is really important.  Tell the truth.  Clients will bolt if they lose their trust in you.  If you tell them the truth they will likely sympathize with your situation and even offer to help.  Oh, and telling the truth is also the Right Thing To Do.  A 36 hour outage for a data center is usually catastrophic.  I was sure my friend was going to lose some big clients after such a prolonged outage.  I called him a few days after the dust settled and asked him about the fallout.  There was none.  He told everyone the truth - whether they paid $20 a month or thousands of dollars a month.  His biggest clients physically came in to the data center and weathered the storm with him.  They knew exactly what was going on and offered to help in many tangible ways.  Even though, in my opinion, my friend didn't do a good job on the "How," "Who," and "When," telling the truth to everyone who was able to get in touch with him allowed him to emerge from this crisis relatively unscathed.
