---
title: Home
layout: home
---

## 2nd iteration of deducing:

Re lists

My current theory is that spaces after a bullet point (e.g. "- Item" or "-  Item" or "#. Item" or "#   Item") are only relevant for the 1st bullet point. It affects whether x1, x2, or x3 spaces is the block/div's tab length.  
However, for 2nd-onwards, any spaces on the rhs are ignored. Instead, it's about how many full tab-lengths are achieved in spaces prior to the bullet point (i.e. the "#" or the "-" or "*" etc.) beginning.

Let's try:

1. Setting tab length as x1 space?
 1. Ergo, this is indented.
  1. And this is double indented.
1. Back to top-level.
   1. Now started with x3 spaces. So Triple level.
1. Back to top-level.
    1. x4 spaces, so stays as x3-level because that's the max?
1. Back to top-level.
      1. x6 spaces, so again, stays as x3-level because that's the max?
1. Guess we'll see.


## Learnings from Part 1:

A line ending with "  " or // will have a e-o-line. I.e. Some line spacing, however, not as much spacing as if there's a full blank-line's separation. Also, the spacing created by full separating blank line, doesn't increase/vary if it also has the top lne end with x2 spaces.

  Also, re headers. I think size/level of a heading affects how much top-spacing the heading has. However, we need to set a headings bottom spacing via blank lines or ending with x2 spaces.

Also, I think I'm yet to figure out how to indent plain paragraph elements.

Also re headers. I don't this I can cause them to be indented via spaces before a the #'s.

#### Hmmm ... What about the spaces after the #'s?
####  I guess we'll
####    See about that ...
#### I.e. Above, I tried indenting by x2 spaces, then indenting by x4 spaces. Which on basis that the 1st header was indented by 0 (i.e. not 1) spaces, should work. 

Re lists:

I was surprised that both "1. Item" & "* Item" cause list elements at the same level / with same indentation. However, if they follow each other, then they are considered to be different blocks/divs, and so there's extra spacing between them.  
Also, ending a bullet point with x2 vs. no spaces has no effect on the spacing between bullet points.

Encouraginly, I saw that after a "* Item" bullet point, I could have a new-line'd para that's indented by x2 spaces, and that causes that para elt to have the same indentation as the bullet point.

Re the numbered list, it's had to make conclusions.

1. My current theory is that re "#. Item" bullet-points, any spaces preceding the # are irrelevant. And it's entirely about the total spaces after the #.
1.  Thus, this item which has x2 spaces after it, is the next level of list-item.
1.   And, now I'm using x3 spaces after the "#." this is again next-level / a s double-indented.
1. While, now I'm back to level 1 / no extra indentation.

Cool. I wonder what happens with the above, if I then add a "#.    Item" I.e. Using x4 spaces to indent.

1. My current theory is that re "#. Item" bullet-points, any spaces preceding the # are irrelevant. And it's entirely about the total spaces after the #.
1.  Thus, this item which has x2 spaces after it, is the next level of list-item.
1.   And, now I'm using x3 spaces after the "#." this is again next-level / a s double-indented.
1. While, now I'm back to level 1 / no extra indentation.
1.    Did this ruin everything?
1. Guess we'll see ...


##  Part 1:

<!-- If below callout doesn't work, proba needs to be wrapped in a div with markdown="1" - Indeed. The div is necessary. 
<div markdown="1"> <- Concluded this prematurely --> 
{: .ghrepo-callout}
Just a test home page atm.
<!-- </div> -->

I've been wanting to get a better grip of indenting. Especially, using bullet points which continue over multiple line breaks / lines.  
(NB: I ended the above in x2 spaces.) However, I'm ending-line at end of this sentence without any spaces.
Anyway, to research I looked at https://kramdown.gettalong.org/syntax.html and using spaces instead of tabs appears to be important.

(Ended the above paragraph/line without spaces, but do have a blank line separting from here/this). In particular, it seems like I may only be allowed to indent by up to 3 spaces, and trying to achieve e.g. 6-space indentations, simply isn't possible.  

(Ended the above paragraph/line with x2 spaces, AND do have a blank line separting from here/this). So without further ado, let's play around.

Cool.

   ### Header with x3 spaces beforehand

Wonder if that caused indentation of the above header?

### Header without indentation.  
But ended with x2 spaces.

This⋅para⋅line⋅starts⋅at⋅the⋅first⋅column.⋅However,
      the⋅following⋅lines⋅can⋅be⋅indented⋅any⋅number⋅of⋅spaces/tabs. (Started with x6 spaces, above ended with no spaces)
   The⋅para⋅continues⋅here. (Started with x3 spaces, above ended with no spaces)

  This⋅is⋅another⋅paragraph,⋅not⋅connected⋅to⋅the⋅above⋅one.⋅But⋅⋅
with⋅a⋅hard⋅line⋅break.⋅\\
And⋅another⋅one.


### Okay, let's start playing with lists:

1. The first list marker in a list may be indented up to three spaces.
1. Hmm ... Does that mean that above "1. " consumes 3 spaces, and thus is the maximum allowed indentation.  
1. Surely not?!
1. Hmm ...

* Only a blank line separates these lists. However, a "* " uses only x2 spaces. So I expect this is treated as the end of the above 4-point list's block, and the beginning of a new block/element.  
  Let's test that. (NB: this line/para isn't a list. However, it was indented by the same x2 spaces).

Okay, maybe what is being said is that an indent-level / tab-character/tab-length will be inferred to be either x2 or x3 spaces, and no other lengths. E.g.  

 1. Item 1. The "I" started at character 4, so I expect our tab length ='s 2 for this list div/block.
   2. Okay. Now instead of x1 space before the point, I used x3.
      3.  Now, x10 spaces/characters are indenting. So will this be x5 indented?
 4. Back to just a single space before the "4. B".

Cool. That's a bit of stuff to learn from for now.

Although  

I'm sure there's still more to test/learn.

E.g. We haven't even experimented with non-list elements inside a list's block/div.







