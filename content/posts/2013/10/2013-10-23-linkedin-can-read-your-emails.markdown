title: LinkedIn Can Read Your Emails
date: 2013-10-23 21:44
comments: false
Category: Computers
Tags: Security, LinkedIn, MITM, description: Linked In is asking users to install Man-in-the-middle code, to their own detriment.

The stupidity of this is mind-boggling.  Essentially, LinkedIn is asking you to insert a man-in-the-middle IMAP server that parses ALL your email and modifies the body so as to 'enhance mobile email, giving professionals the information they need to be brilliant with people.' The following tweet from [Justin Miller](http://twitter.com/incanus77) first brought this to my attention:

<!-- more -->

<blockquote class="twitter-tweet"><p>Holy crap. Is this what we’ve come to? <a href="http://t.co/fGPAmLf5t1">http://t.co/fGPAmLf5t1</a></p>&mdash; Justin Miller (@incanus77) <a href="https://twitter.com/incanus77/statuses/393130253838606336">October 23, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[The article](http://engineering.linkedin.com/mobile/linkedin-intro-doing-impossible-ios) describes how the 
'IMAP Proxy Service' would have access to all your email, as well as the password associated with your email address.  
So if Alice sends an email to Bob, and Bob has this thing installed, Alice's emails are being intercepted and parsed by 
Linked In without her knowing it.   Alice __does not__ need a Linked In account to be vulnerable to this.  What's more, 
those emails that Bob sent and received in the late 1990s (before Linked In was even formed)? Linked in now has access 
to those emails as well. 

It's funny how proud they are of this, when in reality it's an awful thing to do.  In my experience, the majority of 
people aren't (and shouldn't need to be) technically savvy enough to understand that doing what Linked In suggests puts 
their privacy at risk not just for one operation, but continuously.  

Asking users for their emails and passwords isn't new: Networks like Facebook, Path -- and Linked In, too --
ask for email passwords to harvest users' contacts.  But for those types of operations the assumption is that the 
passwords aren't saved and credentials are discarded after the collection of contacts' names and adresses.  However, 
with a proxy email server even as all your present and future emails are being scanned, older emails are also
technically at risk of being read.  The window of opportunity isn't momentary it's as long as you have the IMAP proxy 
installed. 

This isn't a new risk that Linked In has just exposed us to.  This risk has been around since SMTP has been around.  You 
have never been able to control what happens to your email once you hit 'Send.'  

Is the extra information that you get from Linked In worth this egregious invasion of your privacy?  In my opinion, no.  I think [Ian Keith's](http://twitter.com/ikeith) analogy is apt: 

<blockquote class="twitter-tweet"><p><a href="https://twitter.com/incanus77">@incanus77</a> That wallet looks like a hassle. Why don&#39;t you let me hold it instead? I&#39;ll have your credit card ready for you when you need it.</p>&mdash; Ian Keith (@ikeith) <a href="https://twitter.com/ikeith/statuses/393148791609499648">October 23, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
