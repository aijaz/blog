title: Optionals In Swift
date: 2015-09-20 22:30
comments: false
description: I'd like to share with you the way I teach optionals in Swift.
Category: Computers
Tags: Swift, Optionals, iOS, Teaching

I'd like to share with you the way I teach optionals in Swift. I'm pretty sure I'm not the first person who thought of this method, but since I haven't seen anyone else write this up, I've taken it upon myself to do so.

<!-- more -->

I did this yesterday. I handed each student a slip of paper, a pen, and a pencil and gave them the following instructions: 

1. I will ask you a question. If you know the answer to the question, write it down on the slip of paper.
2. Guessing is not allowed. If you do not know the answer to the question, do not write anything down on the slip of paper.
3. If you know that the answer will __never__ change, write the answer down using the pen.
4. If you think that the answer could reasonably change some time in the future, write the answer down using the pencil.
5. After you're done writing (or not writing) the answer I want you to fold the paper in half. You know what, normally we call this "folding", but in this class we'll call it "wrapping". I want you to wrap the paper in half. 

You can see where I went with this. 

I asked some students questions like "What's 2 + 2" and "What is your name?" Others were asked questions like "What number am I thinking of right now" and "What did my mother have for breakfast today?"

We then went through the physical action of force unwrapping the optionals (by unfolding the strips of paper) and trying to add the two numbers represented by the numerical questions above. We saw how we couldn't come up with a answer to "What's 4 plus the number Aijaz is thinking of?". We translated these actions into Swift statements in a playground.

With this simple, enjoyable exercise the students learned that: 

* Some variables can be `var` while others are better specified `let`
* Optionals need to be unwrapped before the values can be used in an expression
* Optionals may be nil
* Force unwrapping optionals (with `!`) in an expression can lead to a hard crash of the app if the value isn't assigned 

In the next class we'll explore the `if let` syntax.

Please let me know what you think of this 'real world analogy.' I think it worked pretty well in yesterday's class.

See you tomorrow.

_This is the 20th of my [30 days][] posts._

[30 days]: /2015/08/31/30-days/
